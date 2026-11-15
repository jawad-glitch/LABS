`timescale 1ns/1ps
module tb_riscv_system;
    reg clk = 1'b0;
    reg reset = 1'b1;
    wire [31:0] pc;
    wire [31:0] reg_debug;
    integer i;
    integer errors;

    riscv_system dut(
        .clk(clk),
        .reset(reset),
        .pc_debug(pc),
        .reg_debug(reg_debug)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("riscv_core.vcd");
        $dumpvars(0, tb_riscv_system);
        errors = 0;

        repeat (2) @(posedge clk);
        #1 reset = 1'b0;
        repeat (12) @(posedge clk);
        #1;

        $display("=== Final RV32I register values ===");
        for (i = 0; i < 32; i = i + 1)
            $display("x%0d = 0x%08h (%0d)", i, dut.cpu.regs[i], dut.cpu.regs[i]);

        if (dut.cpu.regs[3] !== 32'd25) begin
            $display("FAIL x3 expected 25"); errors = errors + 1;
        end
        if (dut.cpu.regs[4] !== 32'd5) begin
            $display("FAIL x4 expected 5"); errors = errors + 1;
        end
        if (dut.cpu.regs[5] !== 32'd10) begin
            $display("FAIL x5 expected 10"); errors = errors + 1;
        end
        if (dut.cpu.regs[6] !== 32'd15) begin
            $display("FAIL x6 expected 15"); errors = errors + 1;
        end
        if (dut.cpu.regs[7] !== 32'd5) begin
            $display("FAIL x7 expected 5"); errors = errors + 1;
        end
        if (dut.cpu.regs[8] !== 32'd25) begin
            $display("FAIL x8 expected 25"); errors = errors + 1;
        end
        if (dut.cpu.regs[9] !== 32'd77) begin
            $display("FAIL branch target x9 expected 77"); errors = errors + 1;
        end
        if (dut.cpu.regs[10] !== 32'd0) begin
            $display("FAIL branch did not skip x10 instruction"); errors = errors + 1;
        end
        if (dut.cpu.regs[0] !== 32'd0) begin
            $display("FAIL x0 is not hardwired to zero"); errors = errors + 1;
        end
        if (errors == 0)
            $display("ALL CHECKS PASSED");
        else
            $display("CHECKS FAILED: %0d", errors);

        $finish;
    end
endmodule
