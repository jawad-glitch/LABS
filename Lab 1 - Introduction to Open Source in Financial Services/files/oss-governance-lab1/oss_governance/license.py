import os
from dataclasses import dataclass
from typing import Optional
from urllib.parse import quote

import requests


API = "https://api.github.com"
TIMEOUT = 20

TIER_MAP = {
    "MIT": "PERMISSIVE",
    "Apache-2.0": "PERMISSIVE",
    "BSD-2-Clause": "PERMISSIVE",
    "BSD-3-Clause": "PERMISSIVE",
    "ISC": "PERMISSIVE",

    "LGPL-2.1": "WEAK_COPYLEFT",
    "LGPL-2.1-only": "WEAK_COPYLEFT",
    "LGPL-2.1-or-later": "WEAK_COPYLEFT",
    "LGPL-3.0": "WEAK_COPYLEFT",
    "LGPL-3.0-only": "WEAK_COPYLEFT",
    "LGPL-3.0-or-later": "WEAK_COPYLEFT",
    "MPL-2.0": "WEAK_COPYLEFT",
    "CDDL-1.0": "WEAK_COPYLEFT",

    "GPL-2.0": "STRONG_COPYLEFT",
    "GPL-2.0-only": "STRONG_COPYLEFT",
    "GPL-2.0-or-later": "STRONG_COPYLEFT",
    "GPL-3.0": "STRONG_COPYLEFT",
    "GPL-3.0-only": "STRONG_COPYLEFT",
    "GPL-3.0-or-later": "STRONG_COPYLEFT",
    "AGPL-3.0": "STRONG_COPYLEFT",
    "AGPL-3.0-only": "STRONG_COPYLEFT",
    "AGPL-3.0-or-later": "STRONG_COPYLEFT",
}


def github_get(url: str, *, allow_404: bool = False):
    headers = {
        "Accept": "application/vnd.github+json",
        "X-GitHub-Api-Version": "2022-11-28",
        "User-Agent": "OSS-Governance-Lab",
    }

    # Read the token at request time, not at module import time.
    token = os.environ.get("GITHUB_TOKEN")
    if token:
        headers["Authorization"] = f"Bearer {token}"

    response = requests.get(url, headers=headers, timeout=TIMEOUT)

    if allow_404 and response.status_code == 404:
        return None

    if response.status_code == 403 and response.headers.get("X-RateLimit-Remaining") == "0":
        reset = response.headers.get("X-RateLimit-Reset", "unknown")
        raise RuntimeError(f"GitHub API rate limit reached; reset timestamp: {reset}")

    response.raise_for_status()
    return response


@dataclass
class LicenseRecord:
    repo_slug: str
    spdx_id: Optional[str]
    license_name: Optional[str]
    risk_tier: str
    requires_legal_review: bool
    stars: int
    primary_language: Optional[str]


class SPDXFallbackDetector:
    KEYWORD_MAP = {
        "Permission is hereby granted, free of charge": "MIT",
        "Apache License": "Apache-2.0",
        "Redistribution and use in source and binary forms, with or without modification": "BSD-3-Clause",
        "Redistribution and use in source and binary forms": "BSD-2-Clause",
        "Permission to use, copy, modify, and/or distribute this software": "ISC",
        "GNU LESSER GENERAL PUBLIC LICENSE": "LGPL-3.0",
        "GNU LESSER GENERAL PUBLIC LICENSE Version 2.1": "LGPL-2.1",
        "Mozilla Public License Version 2.0": "MPL-2.0",
        "COMMON DEVELOPMENT AND DISTRIBUTION LICENSE": "CDDL-1.0",
        "GNU GENERAL PUBLIC LICENSE Version 2": "GPL-2.0",
        "GNU GENERAL PUBLIC LICENSE Version 3": "GPL-3.0",
        "GNU AFFERO GENERAL PUBLIC LICENSE": "AGPL-3.0",
    }

    def detect(self, raw_license_text: str) -> Optional[str]:
        if not raw_license_text:
            return None

        # Prefer the longest matching distinctive phrase for deterministic results.
        text = raw_license_text.casefold()
        matches = [
            (len(keyword), keyword, spdx)
            for keyword, spdx in self.KEYWORD_MAP.items()
            if keyword.casefold() in text
        ]
        if not matches:
            return None

        matches.sort(key=lambda item: (-item[0], item[1]))
        return matches[0][2]

    def fetch_raw_license(
        self, repo_slug: str, default_branch: str = "main"
    ) -> Optional[str]:
        owner, repo = validate_slug(repo_slug)
        branch = quote(default_branch, safe="")
        for filename in ("LICENSE", "LICENSE.md", "LICENSE.txt", "COPYING", "COPYING.md"):
            url = (
                f"https://raw.githubusercontent.com/{owner}/{repo}/"
                f"{branch}/{filename}"
            )
            response = requests.get(
                url,
                headers={"User-Agent": "OSS-Governance-Lab"},
                timeout=TIMEOUT,
            )
            if response.status_code == 200:
                return response.text
            if response.status_code not in (403, 404):
                response.raise_for_status()
        return None


def validate_slug(repo_slug: str):
    parts = repo_slug.strip().split("/")
    if len(parts) != 2 or not all(parts):
        raise ValueError(f"Invalid repository slug: {repo_slug!r}")
    return parts[0], parts[1]


class LicenseClassifier:
    def __init__(self):
        self.fallback = SPDXFallbackDetector()

    def classify(self, repo_slug: str) -> LicenseRecord:
        owner, repo = validate_slug(repo_slug)
        url = f"{API}/repos/{quote(owner)}/{quote(repo)}"
        response = github_get(url)
        data = response.json()

        license_data = data.get("license") or {}
        spdx_id = license_data.get("spdx_id")
        license_name = license_data.get("name")
        default_branch = data.get("default_branch") or "main"

        if not spdx_id:
            raw_text = self.fallback.fetch_raw_license(repo_slug, default_branch)
            detected = self.fallback.detect(raw_text or "")
            if detected:
                spdx_id = detected
                license_name = license_name or detected

        tier = TIER_MAP.get(spdx_id, "UNKNOWN")
        return LicenseRecord(
            repo_slug=repo_slug,
            spdx_id=spdx_id,
            license_name=license_name,
            risk_tier=tier,
            requires_legal_review=(tier in ("UNKNOWN", "STRONG_COPYLEFT")),
            stars=int(data.get("stargazers_count") or 0),
            primary_language=data.get("language"),
        )

    def classify_batch(self, repo_slugs: list[str]) -> list[LicenseRecord]:
        return [self.classify(slug) for slug in repo_slugs]
