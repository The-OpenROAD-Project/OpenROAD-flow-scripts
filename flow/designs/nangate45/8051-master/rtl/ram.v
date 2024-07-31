

module ram(clk,rst,read,r_addr,r_data,write,w_addr,w_data);

input clk, rst;
input read,write;
input [7:0] r_addr,w_addr,w_data;
output reg [7:0] r_data;

reg [7:0] ram [0:255];

integer k;
initial
begin
for (k = 0; k < 256; k = k + 1)
begin
    ram[k] = 8'b0;
end
end

always@(posedge clk)
  if (rst) r_data <= 8'b0;
  else if (read) r_data <= ram[r_addr];
//always@(posedge clk)
//	if(read) r_data <= ram[addr8];

always@(posedge clk) begin
	if (write) ram[w_addr] <= w_data;	
end

endmodule
