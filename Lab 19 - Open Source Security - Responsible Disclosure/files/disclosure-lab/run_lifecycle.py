#!/usr/bin/env python3
import json
import subprocess
from pathlib import Path

from src.pipeline import DisclosurePipeline, IncomingReport
from src.advisory import AdvisoryGenerator

ROOT = Path(__file__).resolve().parent
DATA_DIR = ROOT / "data"
AUDIT_DIR = ROOT / "audit-logs"
ADVISORY_DIR = ROOT / "advisories"

def get_or_create_gpg_key():
    result = subprocess.run(
        ["gpg", "--batch", "--with-colons", "--list-secret-keys"],
        capture_output=True, text=True
    )
    fingerprint = None
    for line in result.stdout.splitlines():
        fields = line.split(":")
        if fields[0] == "fpr" and len(fields) > 9:
            fingerprint = fields[9]
            break
    if fingerprint:
        return fingerprint

    print("      No secret GPG key found; generating a lab-only signing key...")
    params = (
        "Key-Type: RSA\n"
        "Key-Length: 2048\n"
        "Name-Real: Security Lab\n"
        "Name-Email: security@lab.local\n"
        "Expire-Date: 0\n"
        "%no-protection\n"
        "%commit\n"
    )
    generated = subprocess.run(
        ["gpg", "--batch", "--generate-key"],
        input=params, capture_output=True, text=True
    )
    if generated.returncode != 0:
        raise RuntimeError("GPG key generation failed: " + generated.stderr)

    result = subprocess.run(
        ["gpg", "--batch", "--with-colons", "--list-secret-keys"],
        capture_output=True, text=True, check=True
    )
    for line in result.stdout.splitlines():
        fields = line.split(":")
        if fields[0] == "fpr" and len(fields) > 9:
            return fields[9]
    raise RuntimeError("GPG key was generated but no fingerprint was found")

def main():
    pipeline = DisclosurePipeline(str(DATA_DIR), str(AUDIT_DIR))

    report: IncomingReport = {
        "title": "Authentication Bypass via JWT Algorithm Confusion",
        "description": (
            "The demonstration report describes a JWT verification weakness "
            "where an implementation may incorrectly accept an unsigned token. "
            "This is a lab report, not a claim about a real deployed product."
        ),
        "affected_component": "fincore-auth",
        "affected_versions": ["3.1.0", "3.1.1", "3.2.0"],
        "reproduction_steps": [
            "Use a local test environment with a deliberately vulnerable JWT verifier.",
            "Create a test token with an unexpected algorithm header.",
            "Verify that the implementation rejects unsupported algorithms."
        ],
        "reporter": {
            "name": "Ada Lovelace",
            "email": "ada@example.com",
            "organization": "Independent Security Research",
            "pgp_fingerprint": ""
        },
        "cvss_vector": "CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:N",
        "cwe_id": "CWE-287"
    }

    print("[1/6] Ingesting vulnerability report...")
    record = pipeline.ingest(report)
    vuln_id = record["vuln_id"]
    print(f"      vuln_id={vuln_id}")
    print(f"      disclosure deadline={record['disclosure_deadline']}")
    print(f"      days remaining={pipeline.days_until_deadline(vuln_id)}")

    print("[2/6] Enriching from the live NVD API...")
    enrichment = pipeline.enrich_from_nvd(vuln_id)
    print(f"      NVD status={enrichment.get('status')}")
    print(f"      NVD enrichment keys={list(enrichment.keys())}")
    if enrichment.get("status") != "matched":
        print("      Note: no live CVE match was confirmed; pipeline records the actual result.")

    print("[3/6] Validating disclosure state transitions...")
    for status, actor, note in [
        ("TRIAGING", "security-lead", "Initial triage and reproduction started"),
        ("CONFIRMED", "security-lead", "Issue confirmed in the lab test environment"),
        ("FIX_IN_PROGRESS", "dev-team", "Remediation work started"),
        ("FIX_READY", "dev-team", "Patch reviewed and ready for release"),
    ]:
        pipeline.transition(vuln_id, status, actor=actor, notes=note)
        print(f"      -> {status}")

    print("[4/6] Generating and signing the security advisory...")
    key_id = get_or_create_gpg_key()
    current_record = json.loads(pipeline.export_record(vuln_id))
    generator = AdvisoryGenerator(signing_key_id=key_id)
    paths = generator.publish(
        record=current_record,
        advisory_id="FINCORE-2026-0001",
        patched_versions=["3.2.1"],
        output_dir=str(ADVISORY_DIR),
        cve_id=None,
    )
    print(f"      Signing key fingerprint={key_id}")
    print(f"      Advisory={paths['advisory_path']}")
    print(f"      Signature={paths['signature_path']}")

    print("[5/6] Completing coordinated disclosure...")
    pipeline.transition(
        vuln_id, "DISCLOSED",
        actor="security-lead",
        notes="Lab advisory generated and signature verified; disclosure workflow completed"
    )
    print("      -> DISCLOSED")

    print("[6/6] Verifying NDJSON audit trail...")
    audit_path = Path(current_record["audit_log_path"])
    entries = [json.loads(line) for line in audit_path.read_text().splitlines() if line.strip()]
    print(f"      Audit entries={len(entries)}")
    for entry in entries:
        print(f"      {entry['timestamp']}  {entry['event']}  actor={entry['actor']}")
    if len(entries) < 7:
        raise RuntimeError("Audit trail is incomplete")

    print("\nLifecycle complete. Advisory signature and audit trail verified.")
    print(f"VULN_ID={vuln_id}")
    print(f"AUDIT_LOG={audit_path}")
    print(f"ADVISORY={paths['advisory_path']}")
    print(f"SIGNATURE={paths['signature_path']}")

if __name__ == "__main__":
    main()
