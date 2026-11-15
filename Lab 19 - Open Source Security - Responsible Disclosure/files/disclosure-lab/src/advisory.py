from __future__ import annotations

import json
import subprocess
from datetime import datetime, timezone
from pathlib import Path
from typing import Optional, TypedDict

import yaml

from src.pipeline import VulnerabilityRecord

class AdvisoryMetadata(TypedDict):
    schema_version: str
    advisory_id: str
    cve_id: Optional[str]
    title: str
    severity: str
    affected_package: str
    affected_versions: list[str]
    patched_versions: list[str]
    cvss_vector: str
    cwe_ids: list[str]
    description: str
    references: list[str]
    credits: list[str]
    published_at: str
    withdrawn_at: Optional[str]

class AdvisoryGenerator:
    def __init__(self, signing_key_id: str) -> None:
        self.signing_key_id = signing_key_id.strip()
        if not self.signing_key_id:
            raise RuntimeError("A GPG signing key ID is required")
        result = subprocess.run(
            ["gpg", "--batch", "--list-secret-keys", self.signing_key_id],
            capture_output=True, text=True
        )
        if result.returncode != 0 or "sec" not in result.stdout:
            raise RuntimeError(f"GPG secret key not found: {self.signing_key_id}")

    def build_metadata(
        self,
        record: VulnerabilityRecord,
        advisory_id: str,
        patched_versions: list[str],
        cve_id: Optional[str] = None
    ) -> AdvisoryMetadata:
        report = record["report"]
        reporter_name = report.get("reporter", {}).get("name", "").strip()
        credits = [reporter_name] if reporter_name else []
        cwe = report.get("cwe_id", "").strip()
        references = [
            f"https://nvd.nist.gov/vuln/search/results?query={cwe}"
        ] if cwe else []
        if cve_id:
            references.append(f"https://www.cve.org/CVERecord?id={cve_id}")
        return {
            "schema_version": "1.4.0",
            "advisory_id": advisory_id,
            "cve_id": cve_id,
            "title": report["title"],
            "severity": record.get("severity", "UNKNOWN"),
            "affected_package": report["affected_component"],
            "affected_versions": list(report["affected_versions"]),
            "patched_versions": list(patched_versions),
            "cvss_vector": report.get("cvss_vector", ""),
            "cwe_ids": [cwe] if cwe else [],
            "description": report["description"],
            "references": references,
            "credits": credits,
            "published_at": datetime.now(timezone.utc).isoformat(),
            "withdrawn_at": None,
        }

    def render_markdown(self, metadata: AdvisoryMetadata) -> str:
        frontmatter = yaml.safe_dump(
            dict(metadata),
            sort_keys=False,
            allow_unicode=True,
            default_flow_style=False,
        )
        parsed = yaml.safe_load(frontmatter)
        if not isinstance(parsed, dict) or set(parsed) != set(metadata):
            raise ValueError("Advisory YAML front matter failed schema validation")

        versions = "\n".join(
            f"- `{version}`" for version in metadata["affected_versions"]
        ) or "- Not specified"
        patched = "\n".join(
            f"- `{version}`" for version in metadata["patched_versions"]
        ) or "- Not specified"
        cwes = ", ".join(metadata["cwe_ids"]) or "Not specified"
        refs = "\n".join(f"- {url}" for url in metadata["references"]) or "- None supplied"
        credits = ", ".join(metadata["credits"]) or "Not specified"

        return f"""---
{frontmatter.rstrip()}
---

# {metadata['title']}

## Summary

{metadata['description']}

## Severity

**{metadata['severity']}**

CVSS vector: `{metadata['cvss_vector'] or 'Not provided'}`

## Affected package

`{metadata['affected_package']}`

### Affected versions

{versions}

### Patched versions

{patched}

## Weakness classification

{cwes}

## References

{refs}

## Credits

{credits}

## Disclosure metadata

- Advisory: `{metadata['advisory_id']}`
- CVE: `{metadata['cve_id'] or 'Not yet assigned'}`
- Published: `{metadata['published_at']}`
- Schema version: `{metadata['schema_version']}`

This document is a lab-generated advisory draft. An internal advisory identifier is not a GHSA identifier or an assigned CVE. Submit through the appropriate GitHub Security Advisory and CNA processes before representing it as officially published.
"""

    def sign_advisory(self, advisory_text: str, output_path: str) -> str:
        path = Path(output_path).expanduser().resolve()
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(advisory_text, encoding="utf-8")
        signature_path = str(path) + ".asc"

        signed = subprocess.run(
            [
                "gpg", "--batch", "--yes",
                "--local-user", self.signing_key_id,
                "--armor", "--detach-sign",
                "--output", signature_path,
                str(path),
            ],
            capture_output=True, text=True
        )
        if signed.returncode != 0:
            raise RuntimeError("GPG signing failed: " + signed.stderr)

        verified = subprocess.run(
            ["gpg", "--batch", "--verify", signature_path, str(path)],
            capture_output=True, text=True
        )
        if verified.returncode != 0:
            raise RuntimeError("GPG signature verification failed: " + verified.stderr)
        return signature_path

    def publish(
        self,
        record: VulnerabilityRecord,
        advisory_id: str,
        patched_versions: list[str],
        output_dir: str,
        cve_id: Optional[str] = None
    ) -> dict[str, str]:
        if record.get("status") not in {"FIX_READY", "DISCLOSED"}:
            raise ValueError(
                f"Advisory publication forbidden while status is {record.get('status')}; "
                "required FIX_READY or DISCLOSED"
            )
        metadata = self.build_metadata(record, advisory_id, patched_versions, cve_id)
        text = self.render_markdown(metadata)
        output = Path(output_dir).expanduser().resolve()
        output.mkdir(parents=True, exist_ok=True)
        advisory_path = output / f"{advisory_id}.md"
        signature_path = self.sign_advisory(text, str(advisory_path))
        return {
            "advisory_path": str(advisory_path),
            "signature_path": signature_path,
        }
