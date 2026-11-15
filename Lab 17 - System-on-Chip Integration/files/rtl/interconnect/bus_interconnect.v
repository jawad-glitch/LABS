`timescale 1ns/1ps
module bus_interconnect(
    input wire clk, input wire rst_n,
    input wire [31:0] cpu_if_addr, input wire cpu_if_req,
    output wire [31:0] cpu_if_rdata, output wire cpu_if_valid,
    input wire [31:0] cpu_ls_addr, input wire [31:0] cpu_ls_wdata,
    input wire [3:0] cpu_ls_wstrb, input wire cpu_ls_req,
    output reg [31:0] cpu_ls_rdata, output reg cpu_ls_valid,
    output wire [31:0] uart_addr, output wire [31:0] uart_wdata,
    output wire [3:0] uart_wstrb, output wire uart_req,
    input wire [31:0] uart_rdata, input wire uart_valid,
    output wire [31:0] spi_addr, output wire [31:0] spi_wdata,
    output wire [3:0] spi_wstrb, output wire spi_req,
    input wire [31:0] spi_rdata, input wire spi_valid,
    input wire [31:0] if_mem_rdata
);
    reg pending;
    reg [1:0] target;
    reg [31:0] saved_addr, saved_wdata;
    reg [3:0] saved_strb;
    reg [31:0] dmem[0:4095];
    reg [31:0] response;
    integer i;

    assign cpu_if_rdata=if_mem_rdata;
    assign cpu_if_valid=cpu_if_req;
    assign uart_addr=saved_addr;
    assign uart_wdata=saved_wdata;
    assign uart_wstrb=saved_strb;
    assign spi_addr=saved_addr;
    assign spi_wdata=saved_wdata;
    assign spi_wstrb=saved_strb;
    assign uart_req=pending && target==2;
    assign spi_req=pending && target==3;

    always @(posedge clk) begin
        if (!rst_n) begin
            pending<=0; target<=0; cpu_ls_valid<=0;
            cpu_ls_rdata<=0; saved_addr<=0; saved_wdata<=0; saved_strb<=0;
            for (i=0;i<4096;i=i+1) dmem[i]<=0;
        end else begin
            cpu_ls_valid<=0;
            if (!pending && cpu_ls_req) begin
                saved_addr<=cpu_ls_addr;
                saved_wdata<=cpu_ls_wdata;
                saved_strb<=cpu_ls_wstrb;
                if (cpu_ls_addr[31:16]==16'h0001) begin
                    target<=1; pending<=1;
                    if (cpu_ls_wstrb!=0) begin
                        if (cpu_ls_wstrb[0]) dmem[cpu_ls_addr[13:2]][7:0]<=cpu_ls_wdata[7:0];
                        if (cpu_ls_wstrb[1]) dmem[cpu_ls_addr[13:2]][15:8]<=cpu_ls_wdata[15:8];
                        if (cpu_ls_wstrb[2]) dmem[cpu_ls_addr[13:2]][23:16]<=cpu_ls_wdata[23:16];
                        if (cpu_ls_wstrb[3]) dmem[cpu_ls_addr[13:2]][31:24]<=cpu_ls_wdata[31:24];
                    end
                end else if (cpu_ls_addr[31:4]==28'h1000000) begin
                    target<=2; pending<=1;
                end else if (cpu_ls_addr[31:4]==28'h2000000) begin
                    target<=3; pending<=1;
                end else begin
                    target<=0; pending<=1;
                end
            end else if (pending) begin
                case (target)
                    1: begin
                        cpu_ls_rdata<= (saved_strb==0) ? dmem[saved_addr[13:2]] : 0;
                        cpu_ls_valid<=1; pending<=0;
                    end
                    2: if (uart_valid) begin
                        cpu_ls_rdata<=uart_rdata; cpu_ls_valid<=1; pending<=0;
                    end
                    3: if (spi_valid) begin
                        cpu_ls_rdata<=spi_rdata; cpu_ls_valid<=1; pending<=0;
                    end
                    default: begin
                        cpu_ls_rdata<=32'hDEADBEEF;
                        cpu_ls_valid<=1; pending<=0;
                    end
                endcase
            end
        end
    end
endmodule
