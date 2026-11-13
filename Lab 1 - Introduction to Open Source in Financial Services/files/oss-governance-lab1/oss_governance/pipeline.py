import json
from dataclasses import asdict, dataclass
from datetime import datetime, timezone

from rich.console import Console
from rich.table import Table

from .compliance import ComplianceReport, FINOSComplianceScorer
from .license import LicenseClassifier, LicenseRecord


@dataclass
class GovernanceRecord:
    repo_slug: str
    assessed_at: str
    license_record: LicenseRecord
    compliance_report: ComplianceReport
    overall_status: str


class GovernancePipeline:
    def __init__(
        self,
        classifier: LicenseClassifier,
        scorer: FINOSComplianceScorer,
    ):
        self.classifier = classifier
        self.scorer = scorer

    @staticmethod
    def _status(license_record: LicenseRecord, compliance: ComplianceReport) -> str:
        if license_record.risk_tier == "STRONG_COPYLEFT":
            return "REJECTED"

        if (
            license_record.risk_tier == "PERMISSIVE"
            and compliance.finos_tier in ("ACTIVE", "MATURE")
        ):
            return "APPROVED"

        return "CONDITIONAL"

    def run(self, input_file: str, output_file: str) -> list[GovernanceRecord]:
        with open(input_file, encoding="utf-8") as source:
            repos = [
                line.strip()
                for line in source
                if line.strip() and not line.lstrip().startswith("#")
            ]

        if not repos:
            raise ValueError("The input portfolio contains no repository slugs.")

        records = []
        for slug in repos:
            license_record = self.classifier.classify(slug)
            compliance = self.scorer.score(slug)
            records.append(
                GovernanceRecord(
                    repo_slug=slug,
                    assessed_at=datetime.now(timezone.utc).isoformat(),
                    license_record=license_record,
                    compliance_report=compliance,
                    overall_status=self._status(license_record, compliance),
                )
            )

        report = {
            "generated_at": datetime.now(timezone.utc).isoformat(),
            "records": [asdict(record) for record in records],
        }

        with open(output_file, "w", encoding="utf-8") as destination:
            json.dump(report, destination, indent=2, ensure_ascii=False)
            destination.write("\n")

        table = Table(title="Open Source Governance Assessment")
        table.add_column("Repository")
        table.add_column("Risk Tier")
        table.add_column("FINOS Tier")
        table.add_column("Score", justify="right")
        table.add_column("Overall Status")

        for record in records:
            table.add_row(
                record.repo_slug,
                record.license_record.risk_tier,
                record.compliance_report.finos_tier,
                str(record.compliance_report.total_score),
                record.overall_status,
            )

        Console().print(table)
        print(f"JSON governance report written to: {output_file}")
        return records
