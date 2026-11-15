import re
import struct
import subprocess
from pathlib import Path

binary = Path("text.bin").read_bytes()

if len(binary) == 0 or len(binary) % 4 != 0:
    raise SystemExit("FAIL: .text is empty or not a multiple of four bytes")

words = list(struct.unpack("<" + "I" * (len(binary) // 4), binary))

disassembly = Path("all_formats.dis").read_text()
pattern = re.compile(
    r"^\s*[0-9a-fA-F]+:\s+([0-9a-fA-F]{8})\s+"
    r"([a-zA-Z0-9_.]+)\s*(.*)$"
)

expected = []
for line in disassembly.splitlines():
    match = pattern.match(line)
    if match:
        expected.append((int(match.group(1), 16), match.group(2).lower()))

if len(expected) != len(words):
    raise SystemExit(
        f"FAIL: disassembly has {len(expected)} instructions; "
        f"text.bin has {len(words)} words"
    )

if [item[0] for item in expected] != words:
    raise SystemExit("FAIL: raw .text words do not match objdump instruction words")

args = [f"0x{word:08x}" for word in words]

result = subprocess.run(
    ["./decoder", *args],
    text=True,
    stdout=subprocess.PIPE,
    stderr=subprocess.PIPE,
)

if result.returncode != 0:
    print(result.stdout)
    print(result.stderr)
    raise SystemExit("FAIL: decoder returned a non-zero status")

decoded = []
for line in result.stdout.splitlines():
    match = re.match(r"^([RIBSUJ])\s+([a-zA-Z0-9_.]+)", line)
    if match:
        decoded.append(match.group(2).lower())

if len(decoded) != len(expected):
    print(result.stdout)
    raise SystemExit(
        f"FAIL: decoder returned {len(decoded)} decoded instructions; "
        f"expected {len(expected)}"
    )

failures = []
for index, ((word, expected_name), actual_name) in enumerate(
    zip(expected, decoded)
):
    if expected_name != actual_name:
        failures.append(
            f"Instruction {index}: word 0x{word:08x}: "
            f"objdump={expected_name}, decoder={actual_name}"
        )

if failures:
    print("\n".join(failures))
    raise SystemExit("FAIL: decoder mnemonic comparison")

print(f"PASS: all {len(words)} machine-code words match objdump mnemonics")
print("PASS: all extracted words were decoded without UNKNOWN instructions")

print("\n=== Decoder output for all program instructions ===")
print(result.stdout)

unknown = subprocess.run(
    ["./decoder", "0xffffffff", "0x00000073"],
    text=True,
    stdout=subprocess.PIPE,
    stderr=subprocess.PIPE,
)

if "UNKNOWN: 0xffffffff" not in unknown.stdout:
    raise SystemExit("FAIL: unknown opcode handling")

if "ecall" not in unknown.stdout:
    raise SystemExit("FAIL: ECALL handling")

print("PASS: unknown opcode is reported and decoder continues to ECALL")
