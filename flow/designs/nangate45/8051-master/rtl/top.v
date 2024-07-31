`include "defines.v"

module top(rst,clk,acc);
output [7:0] acc;
input rst,clk;


wire [7:0] ins0,ins1,ins2;

//wire [7:0] DPTRL,DPTRH,PCL,PCH,SP,ACC,B,PSW;
wire [7:0] SP,ACC,B,PSW;
wire [15:0] DPTR, PC;
wire [7:0] R1,R0;

wire [17:0] source0,source1;
reg [17:0] source2,source3,source4;
wire [16:0] dest0,dest1;
reg [16:0] dest2,dest3,dest4;

wire [7:0] iram_read_data;
wire [7:0] eram_read_data;
wire [7:0] ram_write_data;
wire [7:0] ram_write_addr;

wire [7:0] operand,data; 
assign acc = ACC;
                       
wire [7:0] addr8;      
wire [15:0] addr16;  	

wire ram_read;
wire ram_write;

wire [5:0] ctrl1;
reg [5:0] ctrl2,ctrl3;

wire stall_addr,stall_addr1,stall_alu,stall_alu1;
wire [1:0] pc_incval, pc_branch;
wire [7:0] pc_reladdr;
wire [15:0] pc_absaddr;
wire [15:0] pc;
wire stall;

assign stall = stall_addr || stall_alu || stall_dec;
wire stall_dec_addr;

reg stall_dec_delay;
always@(posedge clk) stall_dec_delay <= stall_dec;


assign stall_dec_addr = stall_dec || stall_dec_delay;
//assign stall = stall_addr || stall_alu;

reg nop2, nop3, nop4;

INSTRUCTION_FETCH ins_fetch(clk, rst, pc, ins0, ins1, ins2);
//ROM rom(clk, pc, ins0, ins1, ins2);
reg rst_seq;
always@(posedge clk) rst_seq <= rst;

reg [1:0] state, next_state;
localparam NONE = 2'b0, S1 = 2'b1, S2 = 2'b10;
always@(posedge clk)
  if (rst) state <= NONE;
  else state <= next_state;

  always@(*) begin
  next_state = state;
  case(state)
    NONE:
      if(stall) next_state = S1;
    S1:
      if(!stall_dec_delay) next_state = S2;
    S2:
      next_state = NONE;
  endcase
  end

pc_module program_counter(
	.clk(clk),
	.reset(rst),
	.pc_inc_in(!stall && !rst_seq),
	.incval_in(pc_incval),
	.pc_branch_in(pc_branch),
	.reladdr_in(pc_reladdr),
	.absaddr_in(pc_absaddr),
	.insfetch_pc_out(pc));

reg nop_add;
wire nop_dec;
wire stall_dec;
wire nop_alu,branch_valid,branch_test;
reg stall_seq;
always@(posedge clk) stall_seq <= stall;
//assign nop_alu = 1'b0;
//assign branch_valid = 1'b0;
//assign branch_test = 1'b0;
wire R0_valid, R1_valid, R_invalid;
decode 		  dec(clk,rst,ins0,ins1,ins2,source0,dest0,ctrl1,pc_incval,pc_branch,pc_reladdr,pc_absaddr,branch_valid,branch_test,flush,nop_dec,stall_dec,stall_addr);
opAddress 	  opAdd(clk,rst,source0,dest0,source1,dest1,dest2,dest3,dest4,R0,R1,R0_valid,R1_valid,R_invalid,addr8,addr16,rom_read,i_ram_read,e_ram_read,PSW[4:3],stall_addr,stall_alu,stall_dec_addr,nop_add,nop2,nop3,nop4);
opReceive	  opRec(clk,rst,iram_read_data,eram_read_data,operand,source2,nop2);
alu           alu(clk,rst,ctrl3,operand,source3,dest3,nop3,branch_valid,branch_test,stall_alu,nop_alu,data,ACC,B,PSW,PC,SP,DPTR);
writeBack     writeBack(clk,rst,data,source4,dest4,ram_write_data,ram_write,ram_write_addr,nop4);
ramController ramCtrl(clk,rst,addr8,addr16,i_ram_read,iram_read_data,ram_write_addr,ram_write,ram_write_data,PSW[4:3],R0,R1,R0_valid,R1_valid,R_invalid);

// nop_dec, nop_alu
// nop due to stall
always@(*)
  if (rst || flush || nop_dec || stall_alu) nop_add = 1'b1;
  else nop_add = 1'b0;

always@(posedge clk) stall_dec_delay <= stall_dec;
always@(posedge clk) begin

	//if (rst || flush || ((nop_dec || stall_addr || (stall_dec_delay && stall_dec)) && !stall_alu))  nop2 <= 1'b1;
	if (rst || flush || ((nop_dec || stall_addr || stall_dec_delay) && !stall_alu))  nop2 <= 1'b1;
	else  nop2 <= 1'b0;

	if (rst || flush)  nop3 <= 1'b1;
	else  nop3 <= nop2;

	if (rst || nop_alu || stall_alu)   nop4 <= 1'b1;
	else  nop4 <= nop3;

	if (rst)								begin source2 <= 18'b0; dest2 <= 17'b0; end
	else if (!stall_addr && !stall_alu) 	begin source2 <= source1; dest2 <= dest1; end

	if (rst) 								begin source3 <= 18'b0; dest3 <= 17'b0; end
	else if (!stall_alu) 					begin source3 <= source2; dest3 <= dest2; end	

	if (rst) 								begin source4 <= 18'b0; dest4 <= 17'b0; end
	else if (!stall_alu) 					begin source4 <= source3; dest4 <= dest3; end
								
	if (!stall_addr && !stall_alu) 			ctrl2 <= ctrl1; 
	if (!stall_alu) 						ctrl3 <= ctrl2; 
end

endmodule