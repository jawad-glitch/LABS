import json
import tempfile
import unittest
from pathlib import Path

from src.pipeline import DisclosurePipeline
from src.policy_generator import PolicyGenerator

REPORT = {
    "title": "Test vulnerability",
    "description": "A test report for the disclosure pipeline.",
    "affected_component": "test-service",
    "affected_versions": ["1.0.0"],
    "reproduction_steps": ["Run the local test"],
    "reporter": {
        "name": "Test Researcher",
        "email": "researcher@example.com",
        "organization": "Independent",
        "pgp_fingerprint": "",
    },
    "cvss_vector": "CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:N",
    "cwe_id": "CWE-287",
}

class PipelineTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        root = Path(self.temp.name)
        self.pipeline = DisclosurePipeline(
            str(root / "data"), str(root / "audit")
        )

    def tearDown(self):
        self.temp.cleanup()

    def test_ingest_persists_record_and_audit(self):
        record = self.pipeline.ingest(REPORT)
        self.assertEqual(record["status"], "RECEIVED")
        self.assertEqual(len(record["vuln_id"]), 12)
        self.assertGreater(self.pipeline.days_until_deadline(record["vuln_id"]), 0)
        saved = json.loads(self.pipeline.export_record(record["vuln_id"]))
        self.assertEqual(saved["report"]["title"], REPORT["title"])
        self.assertTrue(Path(record["audit_log_path"]).exists())

    def test_valid_transition_sequence(self):
        record = self.pipeline.ingest(REPORT)
        vuln_id = record["vuln_id"]
        for status in ("TRIAGING", "CONFIRMED", "FIX_IN_PROGRESS", "FIX_READY", "DISCLOSED"):
            self.pipeline.transition(vuln_id, status, "test-actor", "test transition")
        saved = json.loads(self.pipeline.export_record(vuln_id))
        self.assertEqual(saved["status"], "DISCLOSED")
        self.assertEqual(len(saved["timeline"]), 6)

    def test_illegal_transition_is_rejected(self):
        record = self.pipeline.ingest(REPORT)
        with self.assertRaisesRegex(ValueError, "RECEIVED -> FIX_READY"):
            self.pipeline.transition(
                record["vuln_id"], "FIX_READY", "test-actor", "illegal edge"
            )

    def test_rejected_is_terminal(self):
        record = self.pipeline.ingest(REPORT)
        vuln_id = record["vuln_id"]
        self.pipeline.transition(vuln_id, "REJECTED", "triage", "not in scope")
        with self.assertRaisesRegex(ValueError, "REJECTED -> TRIAGING"):
            self.pipeline.transition(vuln_id, "TRIAGING", "triage", "illegal")

    def test_missing_record_raises(self):
        with self.assertRaises(FileNotFoundError):
            self.pipeline.export_record("000000000000")

class PolicyTests(unittest.TestCase):
    def test_policy_and_template_generation(self):
        config = {
            "project_name": "Test Project",
            "security_email": "security@example.com",
            "pgp_key_url": "https://example.com/key.asc",
            "supported_versions": [{"version": "1.x", "supported": True}],
            "sla": {
                "initial_response_hours": 48,
                "triage_days": 7,
                "fix_days_standard": 90,
                "fix_days_critical": 30,
            },
            "hall_of_fame": [],
        }
        with tempfile.TemporaryDirectory() as temp:
            paths = PolicyGenerator(config).write_artifacts(temp)
            self.assertTrue(Path(paths["SECURITY.md"]).is_file())
            template = Path(paths["vulnerability-report.md"]).read_text()
            self.assertIn("CVSS score and vector", template)
            self.assertIn("A10: Server-Side Request Forgery", template)

if __name__ == "__main__":
    unittest.main(verbosity=2)
