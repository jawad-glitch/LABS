import unittest
from unittest.mock import patch

from oss_governance.license import (
    LicenseClassifier,
    LicenseRecord,
    SPDXFallbackDetector,
)
from oss_governance.compliance import ComplianceReport
from oss_governance.pipeline import GovernancePipeline


class GovernanceLogicTests(unittest.TestCase):
    def test_mit_fallback(self):
        detector = SPDXFallbackDetector()
        text = (
            "Permission is hereby granted, free of charge, "
            "to any person obtaining a copy"
        )
        self.assertEqual(detector.detect(text), "MIT")

    def test_unknown_license_returns_none(self):
        self.assertIsNone(SPDXFallbackDetector().detect("Unrecognized license text"))

    def test_batch_uses_classify(self):
        classifier = LicenseClassifier()
        fake = LicenseRecord(
            "example/project", "MIT", "MIT License", "PERMISSIVE",
            False, 10, "Python"
        )
        with patch.object(classifier, "classify", return_value=fake) as mocked:
            result = classifier.classify_batch(["example/project"])
        self.assertEqual(result, [fake])
        mocked.assert_called_once_with("example/project")

    def test_status_rules_are_repeatable(self):
        pipeline = GovernancePipeline(None, None)
        compliant = ComplianceReport("x/y", 80, {}, [], "MATURE")
        weak = ComplianceReport("x/y", 40, {}, ["License"], "INCUBATING")

        permissive = LicenseRecord(
            "x/y", "MIT", "MIT", "PERMISSIVE", False, 1, "Python"
        )
        strong = LicenseRecord(
            "x/y", "GPL-2.0-only", "GPL", "STRONG_COPYLEFT", True, 1, "C"
        )
        unknown = LicenseRecord(
            "x/y", None, None, "UNKNOWN", True, 0, None
        )

        self.assertEqual(pipeline._status(permissive, compliant), "APPROVED")
        self.assertEqual(pipeline._status(permissive, weak), "CONDITIONAL")
        self.assertEqual(pipeline._status(strong, compliant), "REJECTED")
        self.assertEqual(pipeline._status(unknown, compliant), "CONDITIONAL")

        first_run = [
            pipeline._status(permissive, compliant),
            pipeline._status(strong, compliant),
            pipeline._status(unknown, weak),
        ]
        second_run = [
            pipeline._status(permissive, compliant),
            pipeline._status(strong, compliant),
            pipeline._status(unknown, weak),
        ]
        self.assertEqual(first_run, second_run)


if __name__ == "__main__":
    unittest.main()
