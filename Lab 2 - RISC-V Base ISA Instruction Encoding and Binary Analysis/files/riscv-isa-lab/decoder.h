#ifndef DECODER_H
#define DECODER_H

#include <stdint.h>

typedef struct {
    uint8_t opcode;
    uint8_t rd;
    uint8_t funct3;
    uint8_t rs1;
    uint8_t rs2;
    uint8_t funct7;
    int32_t imm;
    char format;
    char mnemonic[16];
    char operands[32];
} rv32i_insn_t;

int rv32i_decode(uint32_t word, rv32i_insn_t *out);
void rv32i_print(const rv32i_insn_t *insn);

#endif
