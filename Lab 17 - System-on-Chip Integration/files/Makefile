IVERILOG = iverilog
VVP = vvp
RTL_SRCS = rtl/cpu/riscv_cpu.v \
	rtl/peripherals/uart_periph.v \
	rtl/peripherals/spi_periph.v \
	rtl/interconnect/bus_interconnect.v \
	rtl/soc_top.v
TB_SRC = testbench/soc_tb.v
SIM_TOP = soc_tb
SIM_BIN = sim_out

.PHONY: all compile simulate clean

all: simulate

compile:
	$(IVERILOG) -g2012 -Wall -s $(SIM_TOP) -o $(SIM_BIN) $(RTL_SRCS) $(TB_SRC)

simulate: compile
	$(VVP) $(SIM_BIN)

clean:
	rm -f $(SIM_BIN) *.vcd
