#!/usr/bin/env python3
import json
import sys
import hashlib
from pathlib import Path
from datetime import datetime, timezone

def load_json(path):
    try:
        return json.loads(Path(path).read_text())
    except Exception:
        return {}

def normalize_license(value):
    if not value:
        return "UNKNOWN"
    value = str(value).strip()
    aliases = {
        "BSD": "BSD-3-Clause",
        "BSD License": "BSD-3-Clause",
        "MIT License": "MIT",
        "Apache License 2.0": "Apache-2.0",
        "Apache 2.0": "Apache-2.0",
        "GNU General Public License v3": "GPL-3.0",
        "GNU General Public License v3 (GPLv3)": "GPL-3.0",
        "GNU General Public License v2": "GPL-2.0",
        "GNU Lesser General Public License v2 or later (LGPLv2+)": "LGPL-2.1-or-later"
    }
    return aliases.get(value, value)

def main():
    if len(sys.argv) != 3:
        print("Usage: build_sbom.py PROJECT_ROOT PROJECT_LICENSE")
        return 2

    root = Path(sys.argv[1]).resolve()
    declared_license = sys.argv[2]
    matrix = load_json(root / "license-matrix.json")
    rules = matrix.get("rules", {})
    default_status = matrix.get("defaultStatus", "conditional")

    py_data = load_json(root / "pip-licenses.json")
    npm_data = load_json(root / "npm-licenses.json")

    packages = []

    for item in py_data if isinstance(py_data, list) else []:
        name = item.get("Name") or item.get("name")
        version = item.get("Version") or item.get("version")
        lic = normalize_license(item.get("License") or item.get("license"))
        if name and version:
            packages.append({
                "name": name,
                "versionInfo": str(version),
                "licenseDeclared": lic,
                "compatibilityStatus": rules.get(lic, {}).get("status", default_status),
                "ecosystem": "Python"
            })

    if isinstance(npm_data, dict):
        for name, item in npm_data.items():
            if not isinstance(item, dict):
                continue
            version = item.get("version")
            lic = normalize_license(item.get("licenses"))
            if isinstance(item.get("licenses"), list):
                lic = normalize_license(" OR ".join(item["licenses"]))
            if name and version:
                packages.append({
                    "name": name,
                    "versionInfo": str(version),
                    "licenseDeclared": lic,
                    "compatibilityStatus": rules.get(lic, {}).get("status", default_status),
                    "ecosystem": "Node.js"
                })

    # Ensure every direct manifest dependency is represented even if a scanner
    # cannot identify its license metadata. Mark unknowns for manual review.
    for line in (root / "requirements.txt").read_text().splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        name, _, version = line.partition("==")
        if not any(p["name"].lower() == name.lower() for p in packages):
            packages.append({
                "name": name,
                "versionInfo": version or "UNRESOLVED",
                "licenseDeclared": "UNKNOWN",
                "compatibilityStatus": default_status,
                "ecosystem": "Python"
            })

    package_json = load_json(root / "package.json")
    for name, version in package_json.get("dependencies", {}).items():
        if not any(p["name"] == name for p in packages):
            packages.append({
                "name": name,
                "versionInfo": str(version).lstrip("^~"),
                "licenseDeclared": "UNKNOWN",
                "compatibilityStatus": default_status,
                "ecosystem": "Node.js"
            })

    packages.sort(key=lambda p: (p["ecosystem"], p["name"].lower()))

    namespace_seed = (
        str(root) + declared_license +
        datetime.now(timezone.utc).isoformat()
    )
    namespace_hash = hashlib.sha256(namespace_seed.encode()).hexdigest()

    spdx_packages = []
    for index, package in enumerate(packages, 1):
        spdx_packages.append({
            "name": package["name"],
            "SPDXID": f"SPDXRef-Package-{index}",
            "versionInfo": package["versionInfo"],
            "downloadLocation": "NOASSERTION",
            "filesAnalyzed": False,
            "licenseConcluded": "NOASSERTION",
            "licenseDeclared": package["licenseDeclared"],
            "copyrightText": "NOASSERTION",
            "compatibilityStatus": package["compatibilityStatus"],
            "externalRefs": [{
                "referenceCategory": "OTHER",
                "referenceType": "other",
                "referenceLocator": package["ecosystem"]
            }]
        })

    sbom = {
        "spdxVersion": "SPDX-2.3",
        "dataLicense": "CC0-1.0",
        "SPDXID": "SPDXRef-DOCUMENT",
        "name": root.name,
        "documentNamespace": f"https://example.invalid/spdx/{namespace_hash}",
        "creationInfo": {
            "creators": ["Tool: ip-management-lab-1.0"],
            "created": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
        },
        "packages": spdx_packages,
        "comment": f"Declared project license: {declared_license}. compatibilityStatus is a lab policy extension."
    }

    (root / "sbom.spdx.json").write_text(json.dumps(sbom, indent=2) + "\n")

    lines = [
        "# Open Source License Compliance Report",
        "",
        f"**Project:** {root.name}",
        f"**Declared project license:** {declared_license}",
        f"**Dependencies inventoried:** {len(packages)}",
        "",
        "| Dependency | Ecosystem | Version | License | Compatibility |",
        "|---|---|---:|---|---|"
    ]

    for package in packages:
        lines.append(
            f"| {package['name']} | {package['ecosystem']} | "
            f"{package['versionInfo']} | {package['licenseDeclared']} | "
            f"{package['compatibilityStatus']} |"
        )

    lines.extend(["", "## Required Actions", ""])
    actions = 0
    for package in packages:
        status = package["compatibilityStatus"]
        if status in ("incompatible", "conditional"):
            action = rules.get(
                package["licenseDeclared"], {}
            ).get(
                "action",
                "Confirm the component's license and obligations before distribution."
            )
            lines.append(
                f"- **{package['name']} ({package['licenseDeclared']}) — "
                f"{status}:** {action}"
            )
            actions += 1

    if not actions:
        lines.append("- No conditional or incompatible dependencies were identified by the configured matrix.")

    lines.extend([
        "",
        "## Policy Notes",
        "",
        "Compatibility classifications are based on the project's local "
        "license-matrix.json policy. They are screening results, not legal advice.",
        "UNKNOWN license data is classified as conditional and requires manual verification.",
        "Scanner inventory and manifest fallback entries are distinguished by their metadata; "
        "review UNKNOWN entries before release.",
        ""
    ])

    (root / "COMPLIANCE-REPORT.md").write_text("\n".join(lines))
    print(f"SBOM created with {len(packages)} dependency entries.")
    print(f"Required action entries: {actions}")
    return 0

if __name__ == "__main__":
    sys.exit(main())
