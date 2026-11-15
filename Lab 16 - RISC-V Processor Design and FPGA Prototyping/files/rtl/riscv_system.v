module riscv_system(
    input wire clk,
    input wire reset,
    output wire [31:0] pc_debug,
    output wire [31:0] reg_debug
);
    wire [31:0] instruction;
    wire [31:0] data_addr;
    wire [31:0] data_wdata;
    wire [31:0] data_rdata;
    wire data_we;

    instruction_memory imem(
        .addr(pc_debug),
        .instr(instruction)
    );

    data_memory dmem(
        .clk(clk),
        .we(data_we),
        .addr(data_addr),
        .wdata(data_wdata),
        .rdata(data_rdata)
    );

    riscv_core cpu(
        .clk(clk),
        .reset(reset),
        .instr(instruction),
        .data_rdata(data_rdata),
        .pc(pc_debug),
        .data_addr(data_addr),
        .data_wdata(data_wdata),
        .data_we(data_we),
        .reg_debug(reg_debug)
    );
endmodule
