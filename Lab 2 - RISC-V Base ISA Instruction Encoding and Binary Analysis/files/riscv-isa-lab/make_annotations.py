import re
from pathlib import Path

disassembly = Path("all_formats.dis").read_text()

instructions = []
pattern = re.compile(
    r"^\s*([0-9a-fA-F]+):\s+([0-9a-fA-F]{8})\s+"
    r"([a-zA-Z0-9_.]+)\s*(.*)$"
)

for line in disassembly.splitlines():
    match = pattern.match(line)
    if match:
        address, word, mnemonic, operands = match.groups()
        instructions.append(
            (int(address, 16), int(word, 16), mnemonic.lower(), operands.strip())
        )

wanted = ["add", "addi", "lw", "sw", "bne", "lui", "jal"]
selected = []

for mnemonic in wanted:
    found = next((item for item in instructions if item[2] == mnemonic), None)
    if found is None:
        raise SystemExit(f"ERROR: instruction {mnemonic} not found in disassembly")
    selected.append(found)

def bits(value, width):
    return format(value & ((1 << width) - 1), f"0{width}b")

def signed(value, width):
    sign = 1 << (width - 1)
    return value - (1 << width) if value & sign else value

def field(name, bit_range, value, width, meaning):
    return (
        f"{name:<12} {bit_range:<22} {bits(value, width):<16} "
        f"{value:<10} {meaning}"
    )

output = []

for address, word, mnemonic, operands in selected:
    opcode = word & 0x7f
    rd = (word >> 7) & 0x1f
    funct3 = (word >> 12) & 7
    rs1 = (word >> 15) & 0x1f
    rs2 = (word >> 20) & 0x1f
    funct7 = (word >> 25) & 0x7f
    binary = bits(word, 32)

    output += [
        f"Instruction : {mnemonic} {operands}",
        f"Address     : 0x{address:08x}",
        f"Machine word: 0x{word:08x}",
        f"Binary      : {binary}",
        "",
        f"{'Field':<12} {'Bits':<22} {'Binary value':<16} {'Decimal':<10} Meaning",
    ]

    if mnemonic == "add":
        output += [
            field("funct7", "[31:25]", funct7, 7, "0 = ADD, 32 = SUB"),
            field("rs2", "[24:20]", rs2, 5, f"x{rs2} = second source"),
            field("rs1", "[19:15]", rs1, 5, f"x{rs1} = first source"),
            field("funct3", "[14:12]", funct3, 3, "0 = ADD/SUB family"),
            field("rd", "[11:7]", rd, 5, f"x{rd} = destination"),
            field("opcode", "[6:0]", opcode, 7, "51 = R-type arithmetic"),
        ]
    elif mnemonic == "addi":
        imm = signed((word >> 20) & 0xfff, 12)
        output += [
            field("imm[11:0]", "[31:20]", (word >> 20) & 0xfff, 12,
                  f"signed immediate = {imm}"),
            field("rs1", "[19:15]", rs1, 5, f"x{rs1} = source"),
            field("funct3", "[14:12]", funct3, 3, "0 = ADDI"),
            field("rd", "[11:7]", rd, 5, f"x{rd} = destination"),
            field("opcode", "[6:0]", opcode, 7, "19 = I-type arithmetic"),
        ]
    elif mnemonic == "lw":
        imm = signed((word >> 20) & 0xfff, 12)
        output += [
            field("imm[11:0]", "[31:20]", (word >> 20) & 0xfff, 12,
                  f"signed load offset = {imm}"),
            field("rs1", "[19:15]", rs1, 5, f"x{rs1} = base register"),
            field("funct3", "[14:12]", funct3, 3, "2 = LW"),
            field("rd", "[11:7]", rd, 5, f"x{rd} = destination"),
            field("opcode", "[6:0]", opcode, 7, "3 = load"),
        ]
    elif mnemonic == "sw":
        raw = (((word >> 25) & 0x7f) << 5) | ((word >> 7) & 0x1f)
        imm = signed(raw, 12)
        output += [
            field("imm[11:5]", "[31:25]", (word >> 25) & 0x7f, 7,
                  "upper store offset bits"),
            field("rs2", "[24:20]", rs2, 5, f"x{rs2} = stored value"),
            field("rs1", "[19:15]", rs1, 5, f"x{rs1} = base register"),
            field("funct3", "[14:12]", funct3, 3, "2 = SW"),
            field("imm[4:0]", "[11:7]", (word >> 7) & 0x1f, 5,
                  f"lower offset bits; full offset = {imm}"),
            field("opcode", "[6:0]", opcode, 7, "35 = store"),
        ]
    elif mnemonic == "bne":
        raw = (
            (((word >> 31) & 1) << 12)
            | (((word >> 25) & 0x3f) << 5)
            | (((word >> 8) & 0xf) << 1)
            | (((word >> 7) & 1) << 11)
        )
        imm = signed(raw, 13)
        high = (word >> 25) & 0x7f
        low = (word >> 7) & 0x1f
        output += [
            field("imm[12|10:5]", "[31:25]", high, 7,
                  f"upper branch bits; full offset = {imm}"),
            field("rs2", "[24:20]", rs2, 5, f"x{rs2} = second source"),
            field("rs1", "[19:15]", rs1, 5, f"x{rs1} = first source"),
            field("funct3", "[14:12]", funct3, 3, "1 = BNE"),
            field("imm[4:1|11]", "[11:7]", low, 5,
                  "lower shuffled branch bits"),
            field("opcode", "[6:0]", opcode, 7, "99 = conditional branch"),
        ]
    elif mnemonic == "lui":
        upper = (word >> 12) & 0xfffff
        output += [
            field("imm[31:12]", "[31:12]", upper, 20,
                  f"upper immediate; value = 0x{upper:05x}"),
            field("rd", "[11:7]", rd, 5, f"x{rd} = destination"),
            field("opcode", "[6:0]", opcode, 7, "55 = LUI"),
        ]
    elif mnemonic == "jal":
        raw = (
            (((word >> 31) & 1) << 20)
            | (((word >> 21) & 0x3ff) << 1)
            | (((word >> 20) & 1) << 11)
            | (((word >> 12) & 0xff) << 12)
        )
        imm = signed(raw, 21)
        encoded = (word >> 12) & 0xfffff
        output += [
            field("imm[20|10:1|11|19:12]", "[31:12]", encoded, 20,
                  f"shuffled jump immediate; byte offset = {imm}"),
            field("rd", "[11:7]", rd, 5, f"x{rd} = link destination"),
            field("opcode", "[6:0]", opcode, 7, "111 = JAL"),
        ]

    output += ["", "-" * 100, ""]

Path("annotations.txt").write_text("\n".join(output))
print("Created annotations.txt with seven instruction field tables.")
