// Behaviorial model of RAM to be synthesized
module DualPortNewRegisterReadAddressDataRAM(
    input clk,
    input ram_we,
    input [ADDR - 1:0] ram_wr_addr,
    input [WIDTH - 1 : 0] ram_din,
    input [ADDR - 1:0] ram_rd_addr,
    output [WIDTH - 1 : 0] ram_dout,
    input ram_re,
    input [ADDR - 1:0] ram_rd_addr2,
    output [WIDTH - 1 : 0] ram_dout2,
    input ram_re2
);
	parameter WIDTH = 512;
 	parameter ADDR = 16;

    reg [WIDTH - 1 : 0] my_ram [0: (1 << ADDR) - 1] /* verilator public */;

    assign ram_dout = my_ram[rd_addr];
    assign ram_dout2 = my_ram[rd_addr2];

    reg [ADDR - 1:0] rd_addr;
    reg [ADDR - 1:0] rd_addr2;

    always @(posedge clk) begin
        if (ram_we) begin
            my_ram[ram_wr_addr] = ram_din;
        end
        rd_addr <= ram_rd_addr;
        rd_addr2 <= ram_rd_addr2;
    end
endmodule
