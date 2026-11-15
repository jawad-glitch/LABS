`timescale 1ns/1ps
module riscv_cpu(
    input wire clk, input wire rst_n,
    output wire [31:0] if_addr, output wire if_req,
    input wire [31:0] if_rdata, input wire if_valid,
    output reg [31:0] ls_addr, output reg [31:0] ls_wdata,
    output reg [3:0] ls_wstrb, output wire ls_req,
    input wire [31:0] ls_rdata, input wire ls_valid,
    input wire [7:0] irq
);
    localparam FETCH=3'd0, DECODE=3'd1, EXEC=3'd2,
               LOAD=3'd3, STORE=3'd4;
    reg [2:0] state;
    reg [31:0] pc, instr;
    reg [31:0] regs[0:31];
    reg [31:0] a, b, result, address, store_value;
    reg [4:0] rd;
    reg [31:0] imm_i, imm_s, imm_b, imm_u, imm_j;
    integer k;

    assign if_addr = pc;
    assign if_req = (state == FETCH);
    assign ls_req = (state == LOAD || state == STORE);

    always @* begin
        imm_i = {{20{instr[31]}},instr[31:20]};
        imm_s = {{20{instr[31]}},instr[31:25],instr[11:7]};
        imm_b = {{19{instr[31]}},instr[31],instr[7],instr[30:25],instr[11:8],1'b0};
        imm_u = {instr[31:12],12'b0};
        imm_j = {{11{instr[31]}},instr[31],instr[19:12],instr[20],instr[30:21],1'b0};
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            pc <= 0;
            instr <= 32'h00000013;
            state <= FETCH;
            ls_addr <= 0;
            ls_wdata <= 0;
            ls_wstrb <= 0;
            a <= 0;
            b <= 0;
            result <= 0;
            address <= 0;
            store_value <= 0;
            rd <= 0;
            for (k=0;k<32;k=k+1) regs[k] <= 0;
        end else begin
            regs[0] <= 0;
            case (state)
                FETCH: begin
                    if (if_valid) begin
                        instr <= if_rdata;
                        state <= DECODE;
                    end
                end
                DECODE: begin
                    a <= regs[instr[19:15]];
                    b <= regs[instr[24:20]];
                    rd <= instr[11:7];
                    state <= EXEC;
                end
                EXEC: begin
                    case (instr[6:0])
                        7'h37: begin
                            if (rd != 0) regs[rd] <= imm_u;
                            pc <= pc + 4; state <= FETCH;
                        end
                        7'h17: begin
                            if (rd != 0) regs[rd] <= pc + imm_u;
                            pc <= pc + 4; state <= FETCH;
                        end
                        7'h13: begin
                            if (rd != 0) begin
                                case (instr[14:12])
                                    3'b000: regs[rd] <= a + imm_i;
                                    3'b111: regs[rd] <= a & imm_i;
                                    3'b110: regs[rd] <= a | imm_i;
                                    3'b100: regs[rd] <= a ^ imm_i;
                                    3'b010: regs[rd] <= ($signed(a) < $signed(imm_i)) ? 1 : 0;
                                    default: regs[rd] <= 0;
                                endcase
                            end
                            pc <= pc + 4; state <= FETCH;
                        end
                        7'h33: begin
                            if (rd != 0) begin
                                case ({instr[31:25],instr[14:12]})
                                    {7'h00,3'b000}: regs[rd] <= a+b;
                                    {7'h20,3'b000}: regs[rd] <= a-b;
                                    {7'h00,3'b111}: regs[rd] <= a&b;
                                    {7'h00,3'b110}: regs[rd] <= a|b;
                                    {7'h00,3'b100}: regs[rd] <= a^b;
                                    {7'h00,3'b010}: regs[rd] <= ($signed(a)<$signed(b)) ? 1 : 0;
                                    default: regs[rd] <= 0;
                                endcase
                            end
                            pc <= pc+4; state <= FETCH;
                        end
                        7'h03: begin
                            address <= a + imm_i;
                            ls_addr <= a + imm_i;
                            ls_wstrb <= 0;
                            state <= LOAD;
                        end
                        7'h23: begin
                            address <= a + imm_s;
                            store_value <= b;
                            ls_addr <= a + imm_s;
                            ls_wdata <= b;
                            ls_wstrb <= 4'b1111;
                            state <= STORE;
                        end
                        7'h63: begin
                            case (instr[14:12])
                                3'b000: if (a==b) pc <= pc+imm_b; else pc <= pc+4;
                                3'b001: if (a!=b) pc <= pc+imm_b; else pc <= pc+4;
                                3'b100: if ($signed(a)<$signed(b)) pc <= pc+imm_b; else pc <= pc+4;
                                3'b101: if ($signed(a)>=$signed(b)) pc <= pc+imm_b; else pc <= pc+4;
                                default: pc <= pc+4;
                            endcase
                            state <= FETCH;
                        end
                        7'h6f: begin
                            if (rd != 0) regs[rd] <= pc+4;
                            pc <= pc+imm_j; state <= FETCH;
                        end
                        7'h67: begin
                            if (rd != 0) regs[rd] <= pc+4;
                            pc <= (a+imm_i) & 32'hfffffffe; state <= FETCH;
                        end
                        default: begin
                            pc <= pc+4; state <= FETCH;
                        end
                    endcase
                end
                LOAD: begin
                    if (ls_valid) begin
                        if (rd != 0) begin
                            case (instr[14:12])
                                3'b000: regs[rd] <= {{24{ls_rdata[7]}},ls_rdata[7:0]};
                                3'b001: regs[rd] <= {{16{ls_rdata[15]}},ls_rdata[15:0]};
                                3'b100: regs[rd] <= {24'b0,ls_rdata[7:0]};
                                3'b101: regs[rd] <= {16'b0,ls_rdata[15:0]};
                                default: regs[rd] <= ls_rdata;
                            endcase
                        end
                        ls_wstrb <= 0;
                        pc <= pc+4;
                        state <= FETCH;
                    end
                end
                STORE: begin
                    if (ls_valid) begin
                        ls_wstrb <= 0;
                        pc <= pc+4;
                        state <= FETCH;
                    end
                end
                default: state <= FETCH;
            endcase
        end
    end
endmodule
