import sys
from pathlib import Path

if len(sys.argv) != 3:
    raise SystemExit("Usage: bin_to_hex.py input.bin output.hex")

data = Path(sys.argv[1]).read_bytes()
if len(data) > 16384:
    raise SystemExit("Firmware exceeds 16 KB instruction SRAM")

data += b"\0" * ((-len(data)) % 4)
words = []
for i in range(0, len(data), 4):
    words.append(f"{int.from_bytes(data[i:i+4], 'little'):08x}")
words += ["00000000"] * (4096 - len(words))
Path(sys.argv[2]).write_text("\n".join(words) + "\n")
print(f"Wrote {len(words)} words to {sys.argv[2]}")
