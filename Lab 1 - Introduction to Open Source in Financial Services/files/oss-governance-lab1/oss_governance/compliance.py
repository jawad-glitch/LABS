from dataclasses import dataclass
from urllib.parse import quote

from .license import API, TIER_MAP, github_get, validate_slug


@dataclass
class ComplianceReport:
    repo_slug: str
    total_score: int
    category_scores: dict[str, int]
    missing_categories: list[str]
    finos_tier: str


class FINOSComplianceScorer:
    WEIGHTS = {
        "License": 20,
        "Documentation": 20,
        "Community Health": 20,
        "CI/CD Maturity": 20,
        "Security Posture": 20,
    }

    def _contents(self, owner: str, repo: str, path: str):
        url = (
            f"{API}/repos/{quote(owner)}/{quote(repo)}"
            f"/contents/{quote(path, safe='/')}"
        )
        # A missing file/directory is ordinary negative evidence.
        return github_get(url, allow_404=True)

    def _file_exists(self, owner: str, repo: str, path: str) -> bool:
        response = self._contents(owner, repo, path)
        return response is not None and response.json().get("type") == "file"

    def score(self, repo_slug: str) -> ComplianceReport:
        owner, repo = validate_slug(repo_slug)
        repo_url = f"{API}/repos/{quote(owner)}/{quote(repo)}"
        metadata = github_get(repo_url).json()

        license_data = metadata.get("license") or {}
        spdx_id = license_data.get("spdx_id")
        license_ok = bool(spdx_id and TIER_MAP.get(spdx_id) in (
            "PERMISSIVE", "WEAK_COPYLEFT"
        ))

        documentation_ok = (
            self._file_exists(owner, repo, "README.md")
            and self._file_exists(owner, repo, "CONTRIBUTING.md")
        )

        community_ok = (
            int(metadata.get("open_issues_count") or 0) > 0
            and int(metadata.get("forks_count") or 0) > 5
        )

        workflow_response = self._contents(owner, repo, ".github/workflows")
        workflows_ok = False
        if workflow_response is not None and isinstance(workflow_response.json(), list):
            workflows_ok = any(
                item.get("type") == "file"
                and item.get("name", "").lower().endswith((".yml", ".yaml"))
                for item in workflow_response.json()
            )

        security_ok = self._file_exists(owner, repo, "SECURITY.md")

        evidence = {
            "License": license_ok,
            "Documentation": documentation_ok,
            "Community Health": community_ok,
            "CI/CD Maturity": workflows_ok,
            "Security Posture": security_ok,
        }

        category_scores = {
            name: self.WEIGHTS[name] if present else 0
            for name, present in evidence.items()
        }
        total = sum(category_scores.values())
        missing = [name for name, value in category_scores.items() if value == 0]

        if total >= 80:
            tier = "MATURE"
        elif total >= 60:
            tier = "ACTIVE"
        else:
            tier = "INCUBATING"

        return ComplianceReport(
            repo_slug=repo_slug,
            total_score=total,
            category_scores=category_scores,
            missing_categories=missing,
            finos_tier=tier,
        )

    def score_batch(self, repo_slugs: list[str]) -> list[ComplianceReport]:
        return [self.score(slug) for slug in repo_slugs]
