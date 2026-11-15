from __future__ import annotations

import fcntl
import json
import os
import tempfile
import time
import uuid
from datetime import datetime, timedelta, timezone
from pathlib import Path
from typing import Literal, TypedDict

import requests

SeverityLevel = Literal["CRITICAL", "HIGH", "MEDIUM", "LOW", "UNKNOWN"]
StatusValue = Literal[
    "RECEIVED", "TRIAGING", "CONFIRMED", "FIX_IN_PROGRESS",
    "FIX_READY", "DISCLOSED", "REJECTED"
]

class ReporterInfo(TypedDict):
    name: str
    email: str
    organization: str
    pgp_fingerprint: str

class IncomingReport(TypedDict):
    title: str
    description: str
    affected_component: str
    affected_versions: list[str]
    reproduction_steps: list[str]
    reporter: ReporterInfo
    cvss_vector: str
    cwe_id: str

class VulnerabilityRecord(TypedDict):
    vuln_id: str
    received_at: str
    status: StatusValue
    severity: SeverityLevel
    report: IncomingReport
    nvd_enrichment: dict
    timeline: list[dict]
    disclosure_deadline: str
    audit_log_path: str

ALLOWED_TRANSITIONS = {
    "RECEIVED": {"TRIAGING", "REJECTED"},
    "TRIAGING": {"CONFIRMED", "REJECTED"},
    "CONFIRMED": {"FIX_IN_PROGRESS", "REJECTED"},
    "FIX_IN_PROGRESS": {"FIX_READY"},
    "FIX_READY": {"DISCLOSED"},
    "DISCLOSED": set(),
    "REJECTED": set(),
}

NVD_URL = "https://services.nvd.nist.gov/rest/json/cves/2.0"

def utc_now() -> datetime:
    return datetime.now(timezone.utc)

def iso_now() -> str:
    return utc_now().isoformat()

def severity_from_nvd(item: dict) -> str:
    metrics = item.get("cve", {}).get("metrics", {})
    for metric_name in ("cvssMetricV31", "cvssMetricV30"):
        values = metrics.get(metric_name, [])
        if values:
            severity = values[0].get("cvssData", {}).get("baseSeverity", "UNKNOWN")
            if severity in {"CRITICAL", "HIGH", "MEDIUM", "LOW"}:
                return severity
    return "UNKNOWN"

class DisclosurePipeline:
    def __init__(self, data_dir: str, audit_dir: str) -> None:
        self.data_dir = Path(data_dir).expanduser().resolve()
        self.audit_dir = Path(audit_dir).expanduser().resolve()
        self.data_dir.mkdir(parents=True, exist_ok=True)
        self.audit_dir.mkdir(parents=True, exist_ok=True)

    def _record_path(self, vuln_id: str) -> Path:
        if not vuln_id or len(vuln_id) != 12 or any(c not in "0123456789abcdef" for c in vuln_id):
            raise ValueError("Invalid vulnerability ID")
        return self.data_dir / f"{vuln_id}.json"

    def _lock_path(self, vuln_id: str) -> Path:
        return self.data_dir / f"{vuln_id}.lock"

    def _locked(self, vuln_id: str):
        class Lock:
            def __init__(inner, path):
                inner.path = path
                inner.handle = None
            def __enter__(inner):
                inner.handle = open(inner.path, "a+")
                fcntl.flock(inner.handle.fileno(), fcntl.LOCK_EX)
                return inner
            def __exit__(inner, exc_type, exc, tb):
                fcntl.flock(inner.handle.fileno(), fcntl.LOCK_UN)
                inner.handle.close()
        return Lock(self._lock_path(vuln_id))

    def _load(self, vuln_id: str) -> VulnerabilityRecord:
        path = self._record_path(vuln_id)
        if not path.exists():
            raise FileNotFoundError(f"Vulnerability record not found: {vuln_id}")
        with path.open(encoding="utf-8") as handle:
            return json.load(handle)

    def _save(self, record: VulnerabilityRecord) -> None:
        path = self._record_path(record["vuln_id"])
        fd, temp_name = tempfile.mkstemp(prefix=path.name, suffix=".tmp", dir=str(self.data_dir))
        try:
            with os.fdopen(fd, "w", encoding="utf-8") as handle:
                json.dump(record, handle, indent=2, ensure_ascii=False)
                handle.write("\n")
                handle.flush()
                os.fsync(handle.fileno())
            os.replace(temp_name, path)
        finally:
            if os.path.exists(temp_name):
                os.unlink(temp_name)

    def _audit(self, record: VulnerabilityRecord, event: str, actor: str, details: dict | None = None) -> None:
        entry = {
            "timestamp": iso_now(),
            "vuln_id": record["vuln_id"],
            "event": event,
            "actor": actor,
            "details": details or {},
        }
        path = Path(record["audit_log_path"])
        line = (json.dumps(entry, ensure_ascii=False, separators=(",", ":")) + "\n").encode()
        fd = os.open(path, os.O_WRONLY | os.O_CREAT | os.O_APPEND, 0o600)
        try:
            os.write(fd, line)
            os.fsync(fd)
        finally:
            os.close(fd)

    def ingest(self, report: IncomingReport) -> VulnerabilityRecord:
        required = ("title", "description", "affected_component", "affected_versions",
                    "reproduction_steps", "reporter", "cvss_vector", "cwe_id")
        missing = [field for field in required if field not in report]
        if missing:
            raise ValueError("Missing report fields: " + ", ".join(missing))
        if not report["title"].strip() or not report["description"].strip():
            raise ValueError("Report title and description are required")

        received = utc_now()
        vuln_id = uuid.uuid4().hex[:12]
        audit_path = (self.audit_dir / f"{vuln_id}.ndjson").resolve()
        record: VulnerabilityRecord = {
            "vuln_id": vuln_id,
            "received_at": received.isoformat(),
            "status": "RECEIVED",
            "severity": "UNKNOWN",
            "report": report,
            "nvd_enrichment": {},
            "timeline": [{
                "timestamp": received.isoformat(),
                "event": "RECEIVED",
                "actor": "system",
                "notes": "Vulnerability report ingested",
            }],
            "disclosure_deadline": (received + timedelta(days=90)).date().isoformat(),
            "audit_log_path": str(audit_path),
        }
        with self._locked(vuln_id):
            self._save(record)
            self._audit(record, "RECEIVED", "system", {"title": report["title"]})
        return record

    def enrich_from_nvd(self, vuln_id: str) -> dict:
        with self._locked(vuln_id):
            record = self._load(vuln_id)
            report = record["report"]
            keywords = " ".join(
                part for part in (report.get("cwe_id", ""), report.get("affected_component", ""))
                if part
            ).strip()
            if not keywords:
                enrichment = {"status": "skipped", "reason": "No NVD search keywords supplied"}
            else:
                enrichment = {}
                last_error = None
                for attempt in range(4):
                    try:
                        response = requests.get(
                            NVD_URL,
                            params={"keywordSearch": keywords, "resultsPerPage": 5},
                            headers={"User-Agent": "ResponsibleDisclosureLab/1.0"},
                            timeout=20,
                        )
                        if response.status_code == 429:
                            if attempt == 3:
                                enrichment = {
                                    "status": "rate_limited",
                                    "http_status": 429,
                                    "message": "NVD public rate limit remained exceeded after 3 retries",
                                }
                                break
                            retry_after = response.headers.get("Retry-After", "")
                            try:
                                delay = max(6, int(retry_after))
                            except (TypeError, ValueError):
                                delay = 6 * (2 ** attempt)
                            time.sleep(min(delay, 60))
                            continue
                        response.raise_for_status()
                        body = response.json()
                        matches = body.get("vulnerabilities", [])
                        if matches:
                            top = matches[0]
                            enrichment = {
                                "status": "matched",
                                "resultsPerPage": body.get("resultsPerPage", 0),
                                "totalResults": body.get("totalResults", 0),
                                "top_result": top,
                            }
                            record["severity"] = severity_from_nvd(top)
                        else:
                            enrichment = {
                                "status": "no_match",
                                "resultsPerPage": body.get("resultsPerPage", 0),
                                "totalResults": body.get("totalResults", 0),
                                "keywordSearch": keywords,
                            }
                        break
                    except requests.RequestException as exc:
                        last_error = str(exc)
                        enrichment = {
                            "status": "unavailable",
                            "error": last_error,
                            "keywordSearch": keywords,
                        }
                        break

            record["nvd_enrichment"] = enrichment
            timestamp = iso_now()
            record["timeline"].append({
                "timestamp": timestamp,
                "event": "NVD_ENRICHMENT",
                "actor": "system",
                "notes": enrichment.get("status", "unknown"),
            })
            self._save(record)
            self._audit(record, "NVD_ENRICHMENT", "system", enrichment)
            return enrichment

    def transition(self, vuln_id: str, new_status: StatusValue, actor: str, notes: str) -> None:
        with self._locked(vuln_id):
            record = self._load(vuln_id)
            old_status = record["status"]
            if new_status not in ALLOWED_TRANSITIONS.get(old_status, set()):
                raise ValueError(f"Illegal transition: {old_status} -> {new_status}")
            timestamp = iso_now()
            record["status"] = new_status
            record["timeline"].append({
                "timestamp": timestamp,
                "event": new_status,
                "actor": actor,
                "notes": notes,
            })
            self._save(record)
            self._audit(record, new_status, actor, {"notes": notes, "from": old_status})

    def days_until_deadline(self, vuln_id: str) -> int:
        record = self._load(vuln_id)
        deadline = datetime.fromisoformat(record["disclosure_deadline"]).date()
        return (deadline - utc_now().date()).days

    def export_record(self, vuln_id: str) -> str:
        return json.dumps(self._load(vuln_id), indent=2, ensure_ascii=False)
