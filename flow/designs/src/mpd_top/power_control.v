module power_control (clk, rst, request, sleep, isolaten);
input clk, rst;
input request;
output sleep;
output isolaten;

reg [1:0] state;
reg [1:0] state_nxt;

always @(posedge clk or posedge rst)
  if (rst)
    state <= 1'b00 ;
  else
    state <= state_nxt ;

always @(state)
  case(state)
    2'b00: if (request) state_nxt = 2'b01;
    2'b01: state_nxt = 2'b11;
    2'b10: state_nxt = 2'b00;
    2'b11: if (!request) state_nxt = 2'b10;
  endcase

assign sleep = (state == 2'b11) ;
assign isolaten = (state != 2'b00) ;

endmodule

