`timescale 1ns/1ps
module spi_periph(
    input wire clk, input wire rst_n,
    input wire [31:0] bus_addr, input wire [31:0] bus_wdata,
    input wire [3:0] bus_wstrb, input wire bus_req,
    output reg [31:0] bus_rdata, output reg bus_valid,
    output reg spi_sclk, output wire spi_mosi,
    input wire spi_miso, output reg spi_csn, output reg spi_irq
);
    parameter DIVISOR=4;
    reg [7:0] tx_shift, rx_shift, rx_data;
    reg [3:0] bit_count;
    reg [15:0] div_count;
    reg busy, rx_ready;
    assign spi_mosi=tx_shift[7];

    always @(posedge clk) begin
        if (!rst_n) begin
            bus_valid<=0; bus_rdata<=0; spi_sclk<=0; spi_csn<=1;
            spi_irq<=0; tx_shift<=0; rx_shift<=0; rx_data<=0;
            bit_count<=0; div_count<=0; busy<=0; rx_ready<=0;
        end else begin
            bus_valid<=0; spi_irq<=0;
            if (bus_req) begin
                bus_valid<=1;
                if (bus_wstrb!=0 && bus_addr[3:0]==0 && !busy) begin
                    tx_shift<=bus_wdata[7:0]; rx_shift<=0;
                    bit_count<=0; div_count<=0; busy<=1;
                    rx_ready<=0; spi_sclk<=0; spi_csn<=0;
                end else if (bus_wstrb==0) begin
                    if (bus_addr[3:0]==4)
                        bus_rdata <= {30'b0,rx_ready,busy};
                    else
                        bus_rdata <= {24'b0,rx_data};
                end
            end
            if (busy) begin
                if (div_count==DIVISOR-1) begin
                    div_count<=0;
                    if (!spi_sclk) begin
                        spi_sclk<=1;
                        rx_shift<={rx_shift[6:0],spi_miso};
                        if (bit_count==7) begin
                            rx_data<={rx_shift[6:0],spi_miso};
                            rx_ready<=1; busy<=0; spi_csn<=1; spi_irq<=1;
                        end else bit_count<=bit_count+1'b1;
                    end else begin
                        spi_sclk<=0;
                        tx_shift<={tx_shift[6:0],1'b0};
                    end
                end else div_count<=div_count+1'b1;
            end
        end
    end
endmodule
