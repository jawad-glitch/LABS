#!/usr/bin/env python3
import re
import sys
from pathlib import Path

REGS = {
    "zero": 0, "ra": 1, "sp": 2, "gp": 3, "tp": 4,
    "t0": 5, "t1": 6, "t2": 7, "s0": 8, "fp": 8,
    "s1": 9, "a0": 10, "a1": 11, "a2": 12, "a3": 13,
    "a4": 14, "a5": 15, "a6": 16, "a7": 17,
    "s2": 18, "s3": 19, "s4": 20, "s5": 21, "s6": 22,
    "s7": 23, "s8": 24, "s9": 25, "s10": 26, "s11": 27,
    "t3": 28, "t4": 29, "t5": 30, "t6": 31
}

def reg(token):
    token = token.strip().lower()
    if token in REGS:
        return REGS[token]
    if re.fullmatch(r"x(?:[0-9]|[12][0-9]|3[01])", token):
        return int(token[1:])
    raise ValueError("Invalid register: " + token)

def imm(token, bits):
    value = int(token.strip(), 0)
    lo, hi = -(1 << (bits - 1)), (1 << (bits - 1)) - 1
    if not lo <= value <= hi:
        raise ValueError(f"Immediate {value} does not fit signed {bits}-bit field")
    return value & ((1 << bits) - 1)

def encode(line):
    parts = line.replace(",", " ").split()
    op = parts[0].lower()
    a = parts[1:]
    rtype = {
        "add": (0, 0), "sub": (0, 0x20), "and": (7, 0),
        "or": (6, 0), "xor": (4, 0), "slt": (2, 0)
    }
    if op == "nop":
        if a:
            raise ValueError("NOP takes no operands")
        return 0x00000013
    if op in rtype:
        if len(a) != 3:
            raise ValueError(f"{op} requires rd, rs1, rs2")
        f3, f7 = rtype[op]
        rd, rs1, rs2 = map(reg, a)
        return (f7 << 25) | (rs2 << 20) | (rs1 << 15) | (f3 << 12) | (rd << 7) | 0x33
    if op == "addi":
        if len(a) != 3:
            raise ValueError("ADDI requires rd, rs1, immediate")
        rd, rs1 = reg(a[0]), reg(a[1])
        return (imm(a[2], 12) << 20) | (rs1 << 15) | (rd << 7) | 0x13
    if op in ("lw", "sw"):
        if len(a) != 2:
            raise ValueError(f"{op.upper()} requires register, offset(base)")
        m = re.fullmatch(r"\s*(-?(?:0x[0-9a-fA-F]+|[0-9]+))\s*\(\s*([^)]+)\s*\)", a[1])
        if not m:
            raise ValueError("Expected offset(base), for example 4(x2)")
        offset, base = imm(m.group(1), 12), reg(m.group(2))
        r = reg(a[0])
        if op == "lw":
            return (offset << 20) | (base << 15) | (2 << 12) | (r << 7) | 0x03
        return (((offset >> 5) << 25) | (r << 20) | (base << 15) |
                (2 << 12) | ((offset & 31) << 7) | 0x23)
    if op in ("beq", "bne"):
        if len(a) != 3:
            raise ValueError(f"{op.upper()} requires rs1, rs2, byte-offset")
        rs1, rs2, offset = reg(a[0]), reg(a[1]), imm(a[2], 13)
        if offset & 1:
            raise ValueError("Branch offset must be 2-byte aligned")
        f3 = 0 if op == "beq" else 1
        return (((offset >> 12) & 1) << 31) | (((offset >> 5) & 0x3f) << 25) | (rs2 << 20) | (rs1 << 15) | (f3 << 12) | (((offset >> 1) & 0xf) << 8) | (((offset >> 11) & 1) << 7) | 0x63
    raise ValueError("Unsupported instruction: " + op)

def main():
    if len(sys.argv) != 2:
        print("Usage: python3 assembler.py source.s", file=sys.stderr)
        return 2
    source = Path(sys.argv[1])
    output = Path(__file__).resolve().parent / "program.hex"
    words = []
    for number, raw in enumerate(source.read_text().splitlines(), 1):
        line = raw.split("#", 1)[0].strip()
        if not line:
            continue
        try:
            words.append(encode(line))
        except Exception as exc:
            print(f"{source}:{number}: {exc}", file=sys.stderr)
            return 1
    if not words:
        print("No instructions found", file=sys.stderr)
        return 1
    output.write_text("".join(f"{word:08x}\n" for word in words))
    print(f"Assembled {len(words)} instructions -> {output}")
    return 0

if __name__ == "__main__":
    sys.exit(main())
