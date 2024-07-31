

module pc_module(
    input clk,
	input reset,
	input pc_inc_in,					//increment enable signal (from instruction decode)
    input [1:0] incval_in,				//increment value +1 +2 +3 (from instruction decode)
	input [1:0] pc_branch_in,			//brach enable signal (from instruction decode)
    input [7:0] reladdr_in,				//signed relative address (from instruction decode)
    input [15:0] absaddr_in,			//signed relative address (from instruction decode)
    output reg [15:0] insfetch_pc_out);	//PC (to fetch)
	
	reg [15:0] PC;
	//wire [15:0] rel_addr;
	
	//initial PC = 16'h0000;
	
	//assign rel_addr = (pc_inc_in)? {14'b0, incval_in} : {6'b0, reladdr_in[9:0]};
	//assign PC = (reset) ? 16'b0 :( (pc_inc_in)? (PC + rel_addr) : ( (pc_branch_in)? ((reladdr_in[10]) ? (PC - rel_addr) : (PC + rel_addr)) : PC ));
	//assign insfetch_pc_out = PC;

	always@(*) begin
		if (reset)
			insfetch_pc_out = 16'h0000;
		else if (pc_branch_in == 2'b10)
      insfetch_pc_out = PC + {{9{reladdr_in[7]}},reladdr_in[6:0]} + 16'd2;
      else if (pc_branch_in == 2'b01)
      insfetch_pc_out = PC + {{9{reladdr_in[7]}},reladdr_in[6:0]} + 16'd3;
			//insfetch_pc_out = (reladdr_in[7]) ? (PC - reladdr_in[6:0] + 2'd2) : (PC + reladdr_in[6:0] + 2'd2);
			//insfetch_pc_out = PC + reladdr_in;
		else if (pc_branch_in == 2'b11)
			insfetch_pc_out = absaddr_in;
		else if (pc_inc_in)
			insfetch_pc_out = PC + incval_in;
		else
			insfetch_pc_out = PC;
	end

	always@(posedge clk) 
		if(reset) 	PC <= 16'b0;
		else 		    PC <= insfetch_pc_out;

endmodule
