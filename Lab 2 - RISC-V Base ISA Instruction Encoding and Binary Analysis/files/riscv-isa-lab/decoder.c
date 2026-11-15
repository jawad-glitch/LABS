#include "decoder.h"

#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int32_t sign_extend(uint32_t value, unsigned width)
{
    uint32_t sign = UINT32_C(1) << (width - 1);
    uint32_t mask = (UINT32_C(1) << width) - 1U;

    value &= mask;
    return (int32_t)((value ^ sign) - sign);
}

static void set_name(rv32i_insn_t *out, const char *name)
{
    (void)snprintf(out->mnemonic, sizeof(out->mnemonic), "%s", name);
}

static void set_operands(rv32i_insn_t *out, const char *text)
{
    (void)snprintf(out->operands, sizeof(out->operands), "%s", text);
}

int rv32i_decode(uint32_t word, rv32i_insn_t *out)
{
    uint32_t opcode;
    uint32_t funct3;
    uint32_t funct7;
    uint32_t rd;
    uint32_t rs1;
    uint32_t rs2;
    uint32_t raw_imm;
    const char *name = NULL;

    if (out == NULL)
        return -1;

    memset(out, 0, sizeof(*out));

    opcode = word & 0x7fU;
    rd = (word >> 7) & 0x1fU;
    funct3 = (word >> 12) & 7U;
    rs1 = (word >> 15) & 0x1fU;
    rs2 = (word >> 20) & 0x1fU;
    funct7 = (word >> 25) & 0x7fU;

    out->opcode = (uint8_t)opcode;

    if (word == UINT32_C(0x00000073)) {
        out->format = 'I';
        set_name(out, "ecall");
        set_operands(out, "");
        return 0;
    }

    switch (opcode) {
    case 0x33U:
        out->format = 'R';
        out->rd = (uint8_t)rd;
        out->rs1 = (uint8_t)rs1;
        out->rs2 = (uint8_t)rs2;
        out->funct3 = (uint8_t)funct3;
        out->funct7 = (uint8_t)funct7;

        if (funct7 == 0x00U) {
            switch (funct3) {
            case 0: name = "add"; break;
            case 1: name = "sll"; break;
            case 2: name = "slt"; break;
            case 3: name = "sltu"; break;
            case 4: name = "xor"; break;
            case 5: name = "srl"; break;
            case 6: name = "or"; break;
            case 7: name = "and"; break;
            default: break;
            }
        } else if (funct7 == 0x20U) {
            if (funct3 == 0U) name = "sub";
            if (funct3 == 5U) name = "sra";
        }

        if (name == NULL)
            return -1;

        set_name(out, name);
        (void)snprintf(out->operands, sizeof(out->operands),
                       "x%u, x%u, x%u", rd, rs1, rs2);
        return 0;

    case 0x13U:
        out->format = 'I';
        out->rd = (uint8_t)rd;
        out->rs1 = (uint8_t)rs1;
        out->funct3 = (uint8_t)funct3;
        raw_imm = (word >> 20) & 0xfffU;
        out->imm = sign_extend(raw_imm, 12);

        switch (funct3) {
        case 0: name = "addi"; break;
        case 2: name = "slti"; break;
        case 3: name = "sltiu"; break;
        case 4: name = "xori"; break;
        case 6: name = "ori"; break;
        case 7: name = "andi"; break;
        case 1:
            if (funct7 == 0U) name = "slli";
            break;
        case 5:
            if (funct7 == 0U) name = "srli";
            if (funct7 == 0x20U) name = "srai";
            break;
        default:
            break;
        }

        if (name == NULL)
            return -1;

        set_name(out, name);
        (void)snprintf(out->operands, sizeof(out->operands),
                       "x%u, x%u, %" PRId32, rd, rs1, out->imm);
        return 0;

    case 0x03U:
        out->format = 'I';
        out->rd = (uint8_t)rd;
        out->rs1 = (uint8_t)rs1;
        out->funct3 = (uint8_t)funct3;
        out->imm = sign_extend((word >> 20) & 0xfffU, 12);

        switch (funct3) {
        case 0: name = "lb"; break;
        case 1: name = "lh"; break;
        case 2: name = "lw"; break;
        case 4: name = "lbu"; break;
        case 5: name = "lhu"; break;
        default: break;
        }

        if (name == NULL)
            return -1;

        set_name(out, name);
        (void)snprintf(out->operands, sizeof(out->operands),
                       "x%u, %" PRId32 "(x%u)", rd, out->imm, rs1);
        return 0;

    case 0x67U:
        if (funct3 != 0U)
            return -1;

        out->format = 'I';
        out->rd = (uint8_t)rd;
        out->rs1 = (uint8_t)rs1;
        out->funct3 = (uint8_t)funct3;
        out->imm = sign_extend((word >> 20) & 0xfffU, 12);
        set_name(out, "jalr");
        (void)snprintf(out->operands, sizeof(out->operands),
                       "x%u, %" PRId32 "(x%u)", rd, out->imm, rs1);
        return 0;

    case 0x23U:
        out->format = 'S';
        out->rs1 = (uint8_t)rs1;
        out->rs2 = (uint8_t)rs2;
        out->funct3 = (uint8_t)funct3;
        raw_imm = (((word >> 25) & 0x7fU) << 5)
                  | ((word >> 7) & 0x1fU);
        out->imm = sign_extend(raw_imm, 12);

        switch (funct3) {
        case 0: name = "sb"; break;
        case 1: name = "sh"; break;
        case 2: name = "sw"; break;
        default: break;
        }

        if (name == NULL)
            return -1;

        set_name(out, name);
        (void)snprintf(out->operands, sizeof(out->operands),
                       "x%u, %" PRId32 "(x%u)", rs2, out->imm, rs1);
        return 0;

    case 0x63U:
        out->format = 'B';
        out->rs1 = (uint8_t)rs1;
        out->rs2 = (uint8_t)rs2;
        out->funct3 = (uint8_t)funct3;

        raw_imm = (((word >> 31) & 1U) << 12)
                  | (((word >> 25) & 0x3fU) << 5)
                  | (((word >> 8) & 0xfU) << 1)
                  | (((word >> 7) & 1U) << 11);
        out->imm = sign_extend(raw_imm, 13);

        switch (funct3) {
        case 0: name = "beq"; break;
        case 1: name = "bne"; break;
        case 4: name = "blt"; break;
        case 5: name = "bge"; break;
        case 6: name = "bltu"; break;
        case 7: name = "bgeu"; break;
        default: break;
        }

        if (name == NULL)
            return -1;

        set_name(out, name);
        (void)snprintf(out->operands, sizeof(out->operands),
                       "x%u, x%u, %" PRId32, rs1, rs2, out->imm);
        return 0;

    case 0x37U:
    case 0x17U:
        out->format = 'U';
        out->rd = (uint8_t)rd;
        out->imm = (int32_t)(word & UINT32_C(0xfffff000));

        set_name(out, opcode == 0x37U ? "lui" : "auipc");
        (void)snprintf(out->operands, sizeof(out->operands),
                       "x%u, 0x%05" PRIx32, rd,
                       (word >> 12) & 0xfffffU);
        return 0;

    case 0x6fU:
        out->format = 'J';
        out->rd = (uint8_t)rd;

        raw_imm = (((word >> 31) & 1U) << 20)
                  | (((word >> 21) & 0x3ffU) << 1)
                  | (((word >> 20) & 1U) << 11)
                  | (((word >> 12) & 0xffU) << 12);
        out->imm = sign_extend(raw_imm, 21);

        set_name(out, "jal");
        (void)snprintf(out->operands, sizeof(out->operands),
                       "x%u, %" PRId32, rd, out->imm);
        return 0;

    default:
        return -1;
    }
}

static void print_field(const char *name, const char *range,
                        uint32_t value, unsigned width, const char *meaning)
{
    unsigned i;

    printf("%-18s %-13s ", name, range);

    for (i = 0; i < width; ++i) {
        unsigned shift = width - 1U - i;
        putchar(((value >> shift) & 1U) != 0U ? '1' : '0');
    }

    printf("  %-10" PRIu32 " %s\n", value, meaning);
}

static uint32_t reconstruct_word(const rv32i_insn_t *insn)
{
    uint32_t word = insn->opcode;

    switch (insn->format) {
    case 'R':
        word |= (uint32_t)insn->rd << 7;
        word |= (uint32_t)insn->funct3 << 12;
        word |= (uint32_t)insn->rs1 << 15;
        word |= (uint32_t)insn->rs2 << 20;
        word |= (uint32_t)insn->funct7 << 25;
        break;

    case 'I':
        word |= (uint32_t)insn->rd << 7;
        word |= (uint32_t)insn->funct3 << 12;
        word |= (uint32_t)insn->rs1 << 15;
        word |= ((uint32_t)insn->imm & 0xfffU) << 20;
        break;

    case 'S':
        word |= ((uint32_t)insn->imm & 0x1fU) << 7;
        word |= (uint32_t)insn->funct3 << 12;
        word |= (uint32_t)insn->rs1 << 15;
        word |= (uint32_t)insn->rs2 << 20;
        word |= (((uint32_t)insn->imm >> 5) & 0x7fU) << 25;
        break;

    case 'B': {
        uint32_t imm = (uint32_t)insn->imm & 0x1fffU;
        word |= ((imm >> 11) & 1U) << 7;
        word |= (uint32_t)insn->funct3 << 12;
        word |= (uint32_t)insn->rs1 << 15;
        word |= (uint32_t)insn->rs2 << 20;
        word |= ((imm >> 5) & 0x3fU) << 25;
        word |= ((imm >> 12) & 1U) << 31;
        break;
    }

    case 'U':
        word |= (uint32_t)insn->rd << 7;
        word |= (uint32_t)insn->imm & 0xfffff000U;
        break;

    case 'J': {
        uint32_t imm = (uint32_t)insn->imm & 0x1fffffU;
        word |= (uint32_t)insn->rd << 7;
        word |= ((imm >> 12) & 0xffU) << 12;
        word |= ((imm >> 11) & 1U) << 20;
        word |= ((imm >> 1) & 0x3ffU) << 21;
        word |= ((imm >> 20) & 1U) << 31;
        break;
    }

    default:
        break;
    }

    return word;
}

void rv32i_print(const rv32i_insn_t *insn)
{
    uint32_t word;
    uint32_t imm;
    uint32_t high;
    uint32_t low;
    unsigned i;

    if (insn == NULL)
        return;

    word = reconstruct_word(insn);

    printf("%c       %-10s %s\n",
           insn->format, insn->mnemonic, insn->operands);
    printf("Machine word: 0x%08" PRIx32 "\n", word);
    printf("Binary      : ");

    for (i = 0; i < 32U; ++i) {
        unsigned shift = 31U - i;
        putchar(((word >> shift) & 1U) != 0U ? '1' : '0');
    }
    putchar('\n');

    puts("Field              Bits          Binary value  Decimal    Meaning");

    switch (insn->format) {
    case 'R':
        print_field("funct7", "[31:25]", insn->funct7, 7, "R-type function");
        print_field("rs2", "[24:20]", insn->rs2, 5, "second source register");
        print_field("rs1", "[19:15]", insn->rs1, 5, "first source register");
        print_field("funct3", "[14:12]", insn->funct3, 3, "operation selector");
        print_field("rd", "[11:7]", insn->rd, 5, "destination register");
        print_field("opcode", "[6:0]", insn->opcode, 7, "R-type opcode");
        break;

    case 'I':
        imm = (uint32_t)insn->imm & 0xfffU;
        print_field("imm[11:0]", "[31:20]", imm, 12, "12-bit immediate");
        print_field("rs1", "[19:15]", insn->rs1, 5, "source/base register");
        print_field("funct3", "[14:12]", insn->funct3, 3, "operation selector");
        print_field("rd", "[11:7]", insn->rd, 5, "destination register");
        print_field("opcode", "[6:0]", insn->opcode, 7, "I-type opcode");
        break;

    case 'S':
        imm = (uint32_t)insn->imm & 0xfffU;
        high = (imm >> 5) & 0x7fU;
        low = imm & 0x1fU;
        print_field("imm[11:5]", "[31:25]", high, 7, "upper store offset");
        print_field("rs2", "[24:20]", insn->rs2, 5, "stored value register");
        print_field("rs1", "[19:15]", insn->rs1, 5, "base register");
        print_field("funct3", "[14:12]", insn->funct3, 3, "store width");
        print_field("imm[4:0]", "[11:7]", low, 5, "lower store offset");
        print_field("opcode", "[6:0]", insn->opcode, 7, "S-type opcode");
        break;

    case 'B':
        imm = (uint32_t)insn->imm & 0x1fffU;
        high = ((imm >> 12) & 1U) << 6 | ((imm >> 5) & 0x3fU);
        low = ((imm >> 1) & 0xfU) << 1 | ((imm >> 11) & 1U);
        print_field("imm[12|10:5]", "[31:25]", high, 7, "upper branch bits");
        print_field("rs2", "[24:20]", insn->rs2, 5, "second source register");
        print_field("rs1", "[19:15]", insn->rs1, 5, "first source register");
        print_field("funct3", "[14:12]", insn->funct3, 3, "branch condition");
        print_field("imm[4:1|11]", "[11:7]", low, 5, "lower branch bits");
        print_field("opcode", "[6:0]", insn->opcode, 7, "B-type opcode");
        break;

    case 'U':
        imm = (word >> 12) & 0xfffffU;
        print_field("imm[31:12]", "[31:12]", imm, 20, "upper immediate");
        print_field("rd", "[11:7]", insn->rd, 5, "destination register");
        print_field("opcode", "[6:0]", insn->opcode, 7, "U-type opcode");
        break;

    case 'J':
        imm = (word >> 12) & 0xfffffU;
        print_field("imm[20|10:1|11|19:12]", "[31:12]",
                    imm, 20, "shuffled jump immediate");
        print_field("rd", "[11:7]", insn->rd, 5, "link destination register");
        print_field("opcode", "[6:0]", insn->opcode, 7, "J-type opcode");
        break;

    default:
        break;
    }

    putchar('\n');
}

int main(int argc, char **argv)
{
    int i;
    int had_error = 0;

    if (argc < 2) {
        fprintf(stderr, "Usage: %s 0x12345678 [0x12345678 ...]\n",
                argv[0]);
        return 2;
    }

    for (i = 1; i < argc; ++i) {
        char *end = NULL;
        unsigned long parsed;
        rv32i_insn_t insn;

        if (strlen(argv[i]) != 10U
            || argv[i][0] != '0'
            || (argv[i][1] != 'x' && argv[i][1] != 'X')) {
            printf("INVALID: %s (expected 0x followed by 8 hex digits)\n",
                   argv[i]);
            had_error = 1;
            continue;
        }

        parsed = strtoul(argv[i], &end, 16);
        if (end == NULL || *end != '\0' || parsed > UINT32_MAX) {
            printf("INVALID: %s\n", argv[i]);
            had_error = 1;
            continue;
        }

        if (rv32i_decode((uint32_t)parsed, &insn) != 0) {
            printf("UNKNOWN: 0x%08" PRIx32 "\n", (uint32_t)parsed);
            continue;
        }

        rv32i_print(&insn);
    }

    return had_error ? 2 : 0;
}
