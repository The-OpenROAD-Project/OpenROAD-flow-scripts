`include "defines.v"
module ramController(clk,rst,addr8,addr16,read,r_data,w_addr,write,w_data,next_bank,R0,R1,R0_valid,R1_valid,R_invalid);

input clk,rst;
//reg [7:0] rom [0:65536];


input [7:0] addr8;
input [15:0] addr16;
input read,write;
input [7:0] w_addr;
input [7:0] w_data;
output [7:0] r_data;

input [1:0] next_bank;
output reg R0_valid, R1_valid;
output R_invalid;

output reg [7:0] R0;
output reg [7:0] R1;
reg [1:0] bank;

reg Read;
reg [7:0] R_addr;
wire [7:0] R_data;

localparam INIT = 2'b00, FETCH_R0 = 2'b01, FETCH_R1 = 2'b10, VALID = 2'b11;

reg [1:0] state, next_state, prev_state;

ram ram(clk,rst,Read,R_addr,R_data,write,w_addr,w_data);

assign r_data = R_data;

always@(posedge clk)
	if (rst) state <= INIT;
  else state <= next_state;

always@(posedge clk)
  if (rst) prev_state <= INIT;
  else prev_state <= state;

always@(*) begin
  next_state = state;
	case(state)
    INIT:
      next_state = FETCH_R0;
    FETCH_R0:
      if(R0_valid && R1_valid)  next_state = VALID;
      else if (R0_valid)        next_state = FETCH_R1;
      else if(!read)            next_state = FETCH_R1;
    FETCH_R1:
      if(R0_valid && R1_valid)  next_state = VALID;
      else if (R1_valid)        next_state = FETCH_R0;
      else if(!read)            next_state = VALID;
    VALID:
      if(!R0_valid)             next_state = FETCH_R0;
      else if (!R1_valid)       next_state = FETCH_R1;
  endcase
end

always@(*) begin
  if (rst) begin
    R_addr = 8'b0;
    Read = 1'b0;
  end
  else if (read) begin
    R_addr = addr8;
    Read = 1'b1;
  end
  else begin
    case(state)
      FETCH_R0: begin
        R_addr = {3'b0,next_bank,3'b0};
        Read = 1'b1;
      end
      FETCH_R1: begin
        R_addr = {3'b0,next_bank,3'b1};
        Read = 1'b1;
      end
      default: begin
        R_addr = addr8;
        Read = read;
      end
    endcase
  end
end

assign R_invalid = (bank != next_bank);

always@(posedge clk)
  if (rst) R0_valid <= 1'b0;
  else if (write && (w_addr == {3'b0,next_bank,3'b0})) R0_valid <= 1'b1;
  else if ((prev_state == FETCH_R0)&&(state != FETCH_R0)) R0_valid <= 1'b1;
  else if (R_invalid) R0_valid <= 1'b0;

always@(posedge clk)
  if (rst) R1_valid <= 1'b0;
  else if (write && (w_addr == {3'b0,next_bank,3'b1})) R1_valid <= 1'b1;
  else if ((prev_state == FETCH_R1)&&(state != FETCH_R1)) R1_valid <= 1'b1;
  else if (R_invalid) R1_valid <= 1'b0;

always@(posedge clk)
  if (rst) R0 <= 8'b0;
  else if ((prev_state == FETCH_R0) && (state != FETCH_R0)) R0 <= R_data;
  else if (write && (w_addr == {3'b0,next_bank,3'b0})) R0 <= w_data;

always@(posedge clk)
  if (rst) R1 <= 8'b0;
  else if ((prev_state == FETCH_R1) && (state != FETCH_R1)) R1 <= R_data;
  else if (write && (w_addr == {3'b0,next_bank,3'b1})) R1 <= w_data;

always@(posedge clk)
	if (rst) bank <= 2'b0;
	else if (bank != next_bank) bank <= next_bank;

endmodule

