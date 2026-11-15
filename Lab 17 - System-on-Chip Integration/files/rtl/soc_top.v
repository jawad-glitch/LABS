`timescale 1ns/1ps
module soc_top(
    input wire clk, input wire rst_n,
    input wire uart_rxd, output wire uart_txd,
    output wire spi_sclk, output wire spi_mosi,
    input wire spi_miso, output wire spi_csn
);
    reg [31:0] imem[0:4095];
    wire [31:0] if_addr, if_rdata, imem_rdata, ls_addr, ls_wdata, ls_rdata;
    wire [3:0] ls_wstrb;
    wire if_req, if_valid, ls_req, ls_valid;
    wire [31:0] ua, uw, ur, sa, sw, sr;
    wire [3:0] ust, sst;
    wire ureq, uv, sreq, sv, uart_irq, spi_irq;
    wire [31:0] unused_debug;
    wire [7:0] irq = {6'b0,spi_irq,uart_irq};

    assign imem_rdata=imem[if_addr[13:2]];

    riscv_cpu u_cpu(
        .clk(clk),.rst_n(rst_n),.if_addr(if_addr),.if_req(if_req),
        .if_rdata(if_rdata),.if_valid(if_valid),.ls_addr(ls_addr),
        .ls_wdata(ls_wdata),.ls_wstrb(ls_wstrb),.ls_req(ls_req),
        .ls_rdata(ls_rdata),.ls_valid(ls_valid),.irq(irq)
    );

    uart_periph u_uart(
        .clk(clk),.rst_n(rst_n),.bus_addr(ua),.bus_wdata(uw),
        .bus_wstrb(ust),.bus_req(ureq),.bus_rdata(ur),
        .bus_valid(uv),.uart_rxd(uart_rxd),.uart_txd(uart_txd),
        .uart_irq(uart_irq)
    );

    spi_periph u_spi(
        .clk(clk),.rst_n(rst_n),.bus_addr(sa),.bus_wdata(sw),
        .bus_wstrb(sst),.bus_req(sreq),.bus_rdata(sr),
        .bus_valid(sv),.spi_sclk(spi_sclk),.spi_mosi(spi_mosi),
        .spi_miso(spi_miso),.spi_csn(spi_csn),.spi_irq(spi_irq)
    );

    bus_interconnect u_interconnect(
        .clk(clk),.rst_n(rst_n),
        .cpu_if_addr(if_addr),.cpu_if_req(if_req),
        .cpu_if_rdata(if_rdata),.cpu_if_valid(if_valid),
        .cpu_ls_addr(ls_addr),.cpu_ls_wdata(ls_wdata),
        .cpu_ls_wstrb(ls_wstrb),.cpu_ls_req(ls_req),
        .cpu_ls_rdata(ls_rdata),.cpu_ls_valid(ls_valid),
        .uart_addr(ua),.uart_wdata(uw),.uart_wstrb(ust),
        .uart_req(ureq),.uart_rdata(ur),.uart_valid(uv),
        .spi_addr(sa),.spi_wdata(sw),.spi_wstrb(sst),
        .spi_req(sreq),.spi_rdata(sr),.spi_valid(sv),
        .if_mem_rdata(imem_rdata)
    );
endmodule
