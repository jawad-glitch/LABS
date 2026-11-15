`timescale 1ns/1ps
module uart_periph(
    input wire clk, input wire rst_n,
    input wire [31:0] bus_addr, input wire [31:0] bus_wdata,
    input wire [3:0] bus_wstrb, input wire bus_req,
    output reg [31:0] bus_rdata, output reg bus_valid,
    input wire uart_rxd, output reg uart_txd, output reg uart_irq
);
    parameter DIVISOR=8;
    reg [31:0] baud_count;
    reg [9:0] tx_frame;
    reg [3:0] tx_bits;
    reg tx_busy;
    reg [7:0] rx_sync;
    always @(posedge clk) begin
        if (!rst_n) begin
            bus_valid<=0; bus_rdata<=0; uart_txd<=1; uart_irq<=0;
            baud_count<=0; tx_frame<=10'h3ff; tx_bits<=0; tx_busy<=0;
        end else begin
            bus_valid<=0; uart_irq<=0;
            if (bus_req) begin
                bus_valid<=1;
                if (bus_wstrb!=0 && bus_addr[3:0]==0 && !tx_busy) begin
                    tx_frame <= {1'b1,bus_wdata[7:0],1'b0};
                    tx_bits <= 0; tx_busy<=1; baud_count<=0; uart_txd<=0;
                end else if (bus_wstrb==0) begin
                    if (bus_addr[3:0]==4) bus_rdata <= {31'b0,~tx_busy};
                    else bus_rdata <= {24'b0,8'b0};
                end
            end
            if (tx_busy) begin
                if (baud_count==DIVISOR-1) begin
                    baud_count<=0;
                    if (tx_bits==9) begin
                        tx_busy<=0; uart_txd<=1;
                    end else begin
                        tx_bits<=tx_bits+1'b1;
                        tx_frame<= {1'b1,tx_frame[9:1]};
                        uart_txd<=tx_frame[1];
                    end
                end else baud_count<=baud_count+1'b1;
            end
        end
    end
endmodule
