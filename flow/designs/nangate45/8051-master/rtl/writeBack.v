`include "defines.v"
module writeBack(clk,rst,data,source4,dest4,mem_data,mem_write,mem_addr,nop);

input clk,rst;
input [7:0] data;
input [17:0] source4;
input [16:0] dest4;
output [7:0]  mem_data;
output reg [7:0]  mem_addr;
output reg mem_write;

input nop;

assign mem_data = (source4[17] && !source4[16] && source4[15]) ? source4[7:0] : data;

always@(*) begin
  if(rst || nop) mem_write = 1'b0;
  else if(dest4[16] && !dest4[15] && dest4[14]) mem_write = 1'b1;
  else mem_write = 1'b0;
end

always@(*) begin
  if(rst) mem_addr = 8'b0;
  else if(dest4[16] && !dest4[15] && dest4[14]) mem_addr = dest4[7:0];
  else mem_addr = 8'b0;

end

endmodule



