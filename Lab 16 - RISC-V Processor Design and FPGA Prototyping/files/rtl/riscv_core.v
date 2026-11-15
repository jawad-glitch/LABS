module riscv_core(
    input wire clk,
    input wire reset,
    input wire [31:0] instr,
    input wire [31:0] data_rdata,
    output reg [31:0] pc,
    output reg [31:0] data_addr,
    output reg [31:0] data_wdata,
    output reg data_we,
    output wire [31:0] reg_debug
);
    reg [31:0] regs [0:31];
    reg [31:0] next_pc;
    reg [31:0] imm_i, imm_s, imm_b;
    reg [31:0] alu_a, alu_b, alu_result, writeback;
    reg [4:0] rd, rs1, rs2;
    reg reg_we;
    reg branch_taken;
    integer i;

    assign reg_debug = regs[3];

    always @* begin
        rd = instr[11:7];
        rs1 = instr[19:15];
        rs2 = instr[24:20];
        imm_i = {{20{instr[31]}}, instr[31:20]};
        imm_s = {{20{instr[31]}}, instr[31:25], instr[11:7]};
        imm_b = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};

        alu_a = regs[rs1];
        alu_b = regs[rs2];
        alu_result = 32'b0;
        writeback = 32'b0;
        reg_we = 1'b0;
        data_addr = 32'b0;
        data_wdata = 32'b0;
        data_we = 1'b0;
        branch_taken = 1'b0;
        next_pc = pc + 32'd4;

        case (instr[6:0])
            7'h13: begin
                alu_b = imm_i;
                reg_we = 1'b1;
                case (instr[14:12])
                    3'b000: alu_result = alu_a + alu_b;
                    default: alu_result = 32'b0;
                endcase
                writeback = alu_result;
            end
            7'h33: begin
                reg_we = 1'b1;
                case ({instr[31:25], instr[14:12]})
                    {7'h00,3'b000}: alu_result = alu_a + alu_b;
                    {7'h20,3'b000}: alu_result = alu_a - alu_b;
                    {7'h00,3'b111}: alu_result = alu_a & alu_b;
                    {7'h00,3'b110}: alu_result = alu_a | alu_b;
                    {7'h00,3'b100}: alu_result = alu_a ^ alu_b;
                    {7'h00,3'b010}: alu_result = ($signed(alu_a) < $signed(alu_b)) ? 32'd1 : 32'd0;
                    default: alu_result = 32'b0;
                endcase
                writeback = alu_result;
            end
            7'h03: begin
                data_addr = regs[rs1] + imm_i;
                reg_we = 1'b1;
                writeback = data_rdata;
            end
            7'h23: begin
                data_addr = regs[rs1] + imm_s;
                data_wdata = regs[rs2];
                data_we = 1'b1;
            end
            7'h63: begin
                if ((instr[14:12] == 3'b000 && regs[rs1] == regs[rs2]) ||
                    (instr[14:12] == 3'b001 && regs[rs1] != regs[rs2])) begin
                    branch_taken = 1'b1;
                    next_pc = pc + imm_b;
                end
            end
            default: begin
                reg_we = 1'b0;
            end
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            pc <= 32'b0;
            for (i = 0; i < 32; i = i + 1)
                regs[i] <= 32'b0;
        end else begin
            pc <= next_pc;
            if (reg_we && rd != 5'd0)
                regs[rd] <= writeback;
            regs[0] <= 32'b0;
        end
    end
endmodule
