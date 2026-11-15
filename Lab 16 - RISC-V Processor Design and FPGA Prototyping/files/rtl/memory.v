module instruction_memory #(
    parameter INIT_FILE = "../prog/program.hex"
)(
    input wire [31:0] addr,
    output wire [31:0] instr
);
    reg [31:0] mem [0:255];
    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1)
            mem[i] = 32'h00000013;
        $readmemh(INIT_FILE, mem);
    end
    assign instr = mem[addr[9:2]];
endmodule

module data_memory(
    input wire clk,
    input wire we,
    input wire [31:0] addr,
    input wire [31:0] wdata,
    output wire [31:0] rdata
);
    reg [31:0] mem [0:255];
    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1)
            mem[i] = 32'b0;
    end
    always @(posedge clk)
        if (we)
            mem[addr[9:2]] <= wdata;
    assign rdata = mem[addr[9:2]];
endmodule
