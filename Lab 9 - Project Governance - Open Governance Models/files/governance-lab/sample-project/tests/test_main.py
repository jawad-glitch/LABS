import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))
from main import project_status


class GovernanceTests(unittest.TestCase):
    def test_project_name(self):
        self.assertEqual(
            project_status()["name"],
            "Open Governance Sample Project"
        )

    def test_governance_model(self):
        self.assertEqual(project_status()["governance"], "hybrid")

    def test_project_active(self):
        self.assertEqual(project_status()["status"], "active")


if __name__ == "__main__":
    unittest.main()
