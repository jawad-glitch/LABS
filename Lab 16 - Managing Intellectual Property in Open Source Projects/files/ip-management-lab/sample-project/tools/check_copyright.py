#!/usr/bin/env python3
import json
import re
import sys
from pathlib import Path
from datetime import datetime

SOURCE_EXTENSIONS = {
    ".py", ".js", ".jsx", ".ts", ".tsx", ".go",
    ".java", ".c", ".h", ".cpp", ".sh", ".rb",
    ".php", ".rs", ".cs"
}
CURRENT_YEAR = datetime.now().year
YEAR_RE = re.compile(r"\bCopyright\b.*\b(20\d{2})\b", re.I)
SPDX_RE = re.compile(
    r"SPDX-License-Identifier:\s*[A-Za-z0-9.+-]+",
    re.I
)

def inspect_file(path):
    try:
        content = path.read_text(encoding="utf-8", errors="replace")
    except OSError:
        return "malformed"

    header = "\n".join(content.splitlines()[:12])
    year_match = YEAR_RE.search(header)
    spdx_match = SPDX_RE.search(header)

    if not year_match and not spdx_match:
        return "missing-header"

    if not year_match or not spdx_match:
        return "malformed"

    year = int(year_match.group(1))
    if not 2000 <= year <= CURRENT_YEAR:
        return "malformed"

    return "compliant"

def main():
    if len(sys.argv) != 2:
        print("Usage: check_copyright.py DIRECTORY")
        return 2

    root = Path(sys.argv[1]).resolve()
    if not root.is_dir():
        print("Directory does not exist:", root)
        return 2

    results = []
    ignored = {".git", "node_modules", ".venv", "__pycache__"}

    for path in sorted(root.rglob("*")):
        if not path.is_file() or path.suffix.lower() not in SOURCE_EXTENSIONS:
            continue
        if any(part in ignored for part in path.parts):
            continue

        status = inspect_file(path)
        results.append({
            "file": str(path.relative_to(root)),
            "classification": status
        })

    summary = {
        "compliant": sum(x["classification"] == "compliant" for x in results),
        "malformed": sum(x["classification"] == "malformed" for x in results),
        "missing": sum(x["classification"] == "missing-header" for x in results)
    }

    report = {
        "directory": str(root),
        "summary": summary,
        "total": len(results),
        "files": results
    }

    (root / "copyright-report.json").write_text(
        json.dumps(report, indent=2) + "\n",
        encoding="utf-8"
    )

    for item in results:
        if item["classification"] != "compliant":
            print(f"{item['file']}: {item['classification']}")

    print(
        "Copyright scan: "
        f"{summary['compliant']} compliant, "
        f"{summary['malformed']} malformed, "
        f"{summary['missing']} missing"
    )

    return 1 if summary["malformed"] or summary["missing"] else 0

if __name__ == "__main__":
    sys.exit(main())
