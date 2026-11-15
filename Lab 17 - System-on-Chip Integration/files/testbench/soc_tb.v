`timescale 1ns/1ps
module soc_tb;
    reg clk=0, rst_n=0, uart_rxd=1, spi_miso=0;
    wire uart_txd, spi_sclk, spi_mosi, spi_csn;
    reg [7:0] uart_byte;
    reg uart_done=0;
    integer i, cycles;

    localparam CLK_NS=20;
    localparam UART_DIV=8;
    localparam UART_BIT_NS=UART_DIV*CLK_NS;

    soc_top u_soc(
        .clk(clk),.rst_n(rst_n),.uart_rxd(uart_rxd),
        .uart_txd(uart_txd),.spi_sclk(spi_sclk),
        .spi_mosi(spi_mosi),.spi_miso(spi_miso),.spi_csn(spi_csn)
    );

    always #(CLK_NS/2) clk=~clk;

    task automatic uart_capture_byte(output reg [7:0] received);
        integer n;
        begin
            received=0;
            @(negedge uart_txd);
            #(UART_BIT_NS + UART_BIT_NS/2);
            for (n=0;n<8;n=n+1) begin
                received[n]=uart_txd;
                #(UART_BIT_NS);
            end
            #(UART_BIT_NS/2);
            if (uart_txd !== 1'b1)
                $error("UART stop bit was not high");
        end
    endtask

    task automatic spi_drive_miso(input [7:0] pattern);
        integer n;
        begin
            wait(spi_csn == 0);
            spi_miso = pattern[7];
            for (n=7; n>=0; n=n-1) begin
                @(posedge spi_sclk);
                if (n > 0) begin
                    @(negedge spi_sclk);
                    spi_miso = pattern[n-1];
                end
            end
            spi_miso = 0;
        end
    endtask

    initial begin
        $dumpfile("soc_lab.vcd");
        $dumpvars(0,soc_tb);
        $readmemh("software/firmware.hex",u_soc.imem);
        repeat(10) @(posedge clk);
        rst_n=1;

        fork
            begin
                uart_capture_byte(uart_byte);
                uart_done=1;
            end
            begin
                spi_drive_miso(8'hA5);
            end
        join_none

        wait(spi_csn==0);
        wait(spi_csn==1);
        repeat(100) @(posedge clk);

        if (!uart_done) begin
            $error("UART capture did not complete");
            $finish(1);
        end
        if (uart_byte !== 8'h55) begin
            $error("UART byte mismatch: received %02x expected 55",uart_byte);
            $finish(1);
        end
        if (u_soc.u_interconnect.dmem[0] !== 32'h000000A5) begin
            $error("Data SRAM mismatch: got %08x expected 000000A5",
                   u_soc.u_interconnect.dmem[0]);
            $finish(1);
        end

        $display("PASS: SoC integration test complete");
        $finish(0);
    end

    initial begin
        cycles=0;
        forever begin
            @(posedge clk);
            cycles=cycles+1;
            if (cycles>=2000000)
                $fatal(1,"SoC simulation timeout: PC=%08x state=%0d IFreq=%b LSreq=%b LSvalid=%b LSaddr=%08x",
                    u_soc.u_cpu.pc,u_soc.u_cpu.state,
                    u_soc.u_cpu.if_req,u_soc.u_cpu.ls_req,
                    u_soc.u_cpu.ls_valid,u_soc.u_cpu.ls_addr);
        end
    end
endmodule
