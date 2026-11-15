from __future__ import annotations

from pathlib import Path
from typing import TypedDict

class SLAConfig(TypedDict):
    initial_response_hours: int
    triage_days: int
    fix_days_standard: int
    fix_days_critical: int

class VersionEntry(TypedDict):
    version: str
    supported: bool

class PolicyConfig(TypedDict):
    project_name: str
    security_email: str
    pgp_key_url: str
    supported_versions: list[VersionEntry]
    sla: SLAConfig
    hall_of_fame: list[str]

class PolicyGenerator:
    def __init__(self, config: PolicyConfig) -> None:
        self.config = config

    def render_security_md(self) -> str:
        c = self.config
        versions = "\n".join(
            f"| {v['version']} | {'Yes' if v['supported'] else 'No'} |"
            for v in c["supported_versions"]
        )
        credits = "\n".join(f"- {name}" for name in c["hall_of_fame"]) or "- No entries yet."
        return f"""# Security Policy — {c['project_name']}

## Supported Versions

| Version | Security updates |
|---|---|
{versions}

## Reporting a Vulnerability

**Do not report security vulnerabilities through public issues, pull requests, or public chat.**

Email **{c['security_email']}** with:
- A description of the vulnerability and its impact.
- Affected components and versions.
- Reproduction steps or a proof of concept.
- A CVSS vector, if available.
- Your preferred attribution and PGP public-key fingerprint, if applicable.

PGP key: {c['pgp_key_url']}

Please allow maintainers to acknowledge receipt before sharing details publicly.

## Service-Level Targets

| Activity | Target |
|---|---:|
| Initial response | {c['sla']['initial_response_hours']} hours |
| Initial triage | {c['sla']['triage_days']} days |
| Standard remediation target | {c['sla']['fix_days_standard']} days |
| Critical remediation target | {c['sla']['fix_days_critical']} days |

These are response and remediation targets, not a guarantee that every issue can be fixed within the target.

## Coordinated Disclosure Timeline

The project uses a 90-day coordinated disclosure period beginning on the date a valid report is received. Maintainers aim to acknowledge, triage, reproduce, remediate, and prepare an advisory during this period. A reporter and maintainers may agree to a different disclosure date where circumstances require it. Critical issues may be expedited.

## Hall of Fame

{credits}

## Legal Safe Harbor

We consider security research conducted in good faith, within the scope of this policy, and designed to avoid privacy violations, service disruption, data destruction, or unauthorized access to third-party data to be authorized conduct. We will not pursue legal action for such research. Stop testing and report promptly if you encounter data that is not yours. This statement does not grant permission to violate applicable law or third-party terms.
"""

    def render_issue_template(self) -> str:
        categories = [
            "A01: Broken Access Control",
            "A02: Cryptographic Failures",
            "A03: Injection",
            "A04: Insecure Design",
            "A05: Security Misconfiguration",
            "A06: Vulnerable and Outdated Components",
            "A07: Identification and Authentication Failures",
            "A08: Software and Data Integrity Failures",
            "A09: Security Logging and Monitoring Failures",
            "A10: Server-Side Request Forgery",
        ]
        checks = "\n".join(f"- [ ] {category}" for category in categories)
        return f"""---
name: Vulnerability report
about: Security issue intake template — use the project's private security reporting channel
title: "[SECURITY] "
labels: security
assignees: ""
---

> **Privacy warning:** Public GitHub issues are visible to everyone. Do not submit secrets, personal data, weaponized exploit code, or sensitive vulnerability details here. Use the private vulnerability reporting feature or email {self.config['security_email']} for confidential reports.

## Vulnerability category
{checks}

## Affected component and versions
Describe the affected component and version range.

## CVSS score and vector
Score:
Vector:

## CWE
Example: CWE-89

## Reproduction steps
1.
2.
3.

## Impact assessment
Describe confidentiality, integrity, and availability impact.

## Evidence
Provide sanitized logs or screenshots. Do not include secrets or other users' data.

## Reporter attribution preference
- [ ] Credit me by name
- [ ] Credit my organization
- [ ] Keep me anonymous

Name / organization (optional):

## Contact details
Provide a secure contact method. For confidential details, use the private reporting channel rather than this public issue.
"""

    def write_artifacts(self, output_dir: str) -> dict[str, str]:
        root = Path(output_dir).expanduser().resolve()
        template = root / ".github" / "ISSUE_TEMPLATE" / "vulnerability-report.md"
        security = root / "SECURITY.md"
        template.parent.mkdir(parents=True, exist_ok=True)
        security.write_text(self.render_security_md(), encoding="utf-8")
        template.write_text(self.render_issue_template(), encoding="utf-8")
        return {
            "SECURITY.md": str(security),
            "vulnerability-report.md": str(template),
        }
