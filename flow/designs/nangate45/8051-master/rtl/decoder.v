`include "defines.v"
module decode(clk,rst,ins0,ins1,ins2,source0,dest0,alu,op_length,pc_branch,pc_reladdr,pc_absaddr,branch_valid,branch_test,flush,nop_dec,stall,stall_addr);

output stall;
input stall_addr;

input clk, rst;
input [7:0] ins0,ins1,ins2;

output reg [17:0] source0;
output reg [16:0] dest0;

output reg [5:0] alu;

output reg [1:0] op_length;
output reg [1:0] pc_branch;
output reg [7:0] pc_reladdr;
output reg [15:0] pc_absaddr;

output reg flush;
output nop_dec;

input branch_valid, branch_test;

assign nop_dec = (!(|ins0) || (ins0 == `LJMP)) ? 1'b1 : 1'b0;

//always@(*) begin
//  pc_branch = 2'b0;
//  pc_reladdr = 8'b0;
//  pc_absaddr = 8'b0;
//	casex(ins0)
//		`SJMP : 	begin pc_branch = 2'b10; pc_reladdr = ins1; end
//		`LJMP : 	begin pc_branch = 2'b11; pc_absaddr = {ins1,ins2}; end
//	endcase
//end

//reg [7:0] rel0, rel1, rel2;
//reg [16:0] pc0, pc1, pc2;
//reg [2:0] mark;
//reg [2:0] test;
//
//always@(posedge clk) begin
//	if (rst) test <= 3'b0;
//	else if (branch_valid) begin
//		if 		(mark[2]) 	  test[2] <= 1'b1;
//		else if (mark[1]) 	test[1] <= 1'b1;
//		else 				        test[0] <= 1'b1;
//	end
//end
//assign stall = ((state == WAIT) || (next_state == WAIT) || (state == DEL));
assign stall = (((state == WAIT) && (next_state != IDLE)) || (next_state == WAIT));
localparam WAIT = 2'b0, IDLE = 2'b1, DEL = 2'b10;
reg [1:0] state, next_state;

always@(*) begin
  next_state = state;
  case (state)
    WAIT : if(branch_valid) next_state = IDLE;
    IDLE : if(!stall_addr && (
    	(ins0 == `JBC) || 
    	(ins0 == `JB) || 
    	(ins0 == `JNB) || 
    	(ins0[7:3] == 5'b10111) ||
    	(ins0[7:1] == 7'b1011011) || 
    	(ins0 == `CJNE_D) || 
		(ins0 == `CJNE_C) || 
		(ins0 == `DJNZ_D) || 
		(ins0[7:3] == 5'b11011) || 
		(ins0 == `JC) || 
		(ins0 == `JNC) || 
		(ins0 == `JZ) || 
		(ins0 == `JNZ)))
          next_state = WAIT;
  endcase
end
always@(posedge clk)
  if(rst) state <= IDLE;
  else state <= next_state;

always@(*) begin
	flush = 1'b0;
	pc_branch = 2'b0;
  	pc_reladdr = 8'b0;
  	pc_absaddr = 8'b0;
	if (branch_valid && branch_test) begin
		flush = 1'b1;
		
	    if ((ins0 == `JC) || (ins0 == `JNC) || (ins0 == `JZ) || (ins0 == `JNZ) || (ins0[7:3] == 5'b11011)) begin
	    	pc_reladdr = ins1;
	    	pc_branch = 2'b10;
	    end
		else begin
			pc_reladdr = ins2;
			pc_branch = 2'b01;
		end
	end
	else if (ins0 == `SJMP) begin
		pc_branch = 2'b10; 
		pc_reladdr = ins1;
	end
	else if (ins0 == `JMP_D) begin
		pc_branch = 2'b10; 
		pc_reladdr = ins1;
	end
	else if (ins0 == `LJMP) begin
		pc_branch = 2'b11; 
		pc_absaddr = {ins1,ins2};
	end
end

always@(*)
begin
        casex (ins0) /* synopsys parallel_case */
          `ACALL  : op_length = 2'h2;
          `AJMP   : op_length = 2'h2;

        //op_code [7:3]
          `CJNE_R : op_length = 2'h3;
          `DJNZ_R : op_length = 2'h2;
          `MOV_DR : op_length = 2'h2;
          `MOV_CR : op_length = 2'h2;
          `MOV_RD : op_length = 2'h2;

        //op_code [7:1]
          `CJNE_I : op_length = 2'h3;
          `MOV_ID : op_length = 2'h2;
          `MOV_DI : op_length = 2'h2;
          `MOV_CI : op_length = 2'h2;

        //op_code [7:0]
          `ADD_D  : op_length = 2'h2;
          `ADD_C  : op_length = 2'h2;
          `ADDC_D : op_length = 2'h2;
          `ADDC_C : op_length = 2'h2;
          `ANL_D  : op_length = 2'h2;
          `ANL_C  : op_length = 2'h2;
          `ANL_AD : op_length = 2'h2;
          `ANL_DC : op_length = 2'h3;
          `ANL_B  : op_length = 2'h2;
          `ANL_NB : op_length = 2'h2;
          `CJNE_D : op_length = 2'h3;
          `CJNE_C : op_length = 2'h3;
          `CLR_B  : op_length = 2'h2;
          `CPL_B  : op_length = 2'h2;
          `DEC_D  : op_length = 2'h2;
          `DJNZ_D : op_length = 2'h3;
          `INC_D  : op_length = 2'h2;
          `JB     : op_length = 2'h3;
          `JBC    : op_length = 2'h3;
          `JC     : op_length = 2'h2;
          `JNB    : op_length = 2'h3;
          `JNC    : op_length = 2'h2;
          `JNZ    : op_length = 2'h2;
          `JZ     : op_length = 2'h2;
          `LCALL  : op_length = 2'h3;
          `LJMP   : op_length = 2'h3;
          `MOV_D  : op_length = 2'h2;
          `MOV_C  : op_length = 2'h2;
          `MOV_AD : op_length = 2'h2;
          `MOV_DD : op_length = 2'h3;
          `MOV_CD : op_length = 2'h3;
          `MOV_BC : op_length = 2'h2;
          `MOV_CB : op_length = 2'h2;
          `MOV_DP : op_length = 2'h3;
          `ORL_D  : op_length = 2'h2;
          `ORL_C  : op_length = 2'h2;
          `ORL_AD : op_length = 2'h2;
          `ORL_CD : op_length = 2'h3;
          `ORL_B  : op_length = 2'h2;
          `ORL_NB : op_length = 2'h2;
          `POP    : op_length = 2'h2;
          `PUSH   : op_length = 2'h2;
          `SETB_B : op_length = 2'h2;
          `SJMP   : op_length = 2'h2;
          `SUBB_D : op_length = 2'h2;
          `SUBB_C : op_length = 2'h2;
          `XCH_D  : op_length = 2'h2;
          `XRL_D  : op_length = 2'h2;
          `XRL_C  : op_length = 2'h2;
          `XRL_AD : op_length = 2'h2;
          `XRL_CD : op_length = 2'h3;
          default : op_length = 2'h1;
        endcase
end


always@(*) begin
	
casex(ins0)
	`ADD_C	  : alu = 6'b0;
	`ADD_D	  : alu = 6'b0;
	`ADD_I	  : alu = 6'b0;
	`ADD_R	  : alu = 6'b0;
  
	`ADDC_C	  : alu = 6'b1;
	`ADDC_D	  : alu = 6'b1;
	`ADDC_I	  : alu = 6'b1;
	`ADDC_R	  : alu = 6'b1;
  
	`SUBB_C	  : alu = 6'b10;
	`SUBB_D	  : alu = 6'b10;
	`SUBB_I	  : alu = 6'b10;
	`SUBB_R	  : alu = 6'b10;
  
	`INC_A	  : alu = 6'b11;
	`INC_D	  : alu = 6'b11;
	`INC_R	  : alu = 6'b11;
	`INC_I	  : alu = 6'b11;
  
	`DEC_A	  : alu = 6'b100;
	`DEC_D	  : alu = 6'b100;
	`DEC_R	  : alu = 6'b100;
	`DEC_I	  : alu = 6'b100;
  
	`MUL 	  : alu = 6'b101;
	`DIV	  : alu = 6'b110;
  
	`DA 	  : alu = 6'b111;
	//////////////////////
	`ANL_C	  : alu = 6'b10000;
	`ANL_D	  : alu = 6'b10000;
	`ANL_I	  : alu = 6'b10000;
	`ANL_R	  : alu = 6'b10000;
  
	`ANL_C	  : alu = 6'b10100;
	`ANL_AD	  : alu = 6'b10100;
  
	`ORL_C	  : alu = 6'b10001;
	`ORL_D	  : alu = 6'b10001;
	`ORL_I	  : alu = 6'b10001;
	`ORL_R	  : alu = 6'b10001;
  
	`ORL_C	  : alu = 6'b10101;
	`ORL_AD	  : alu = 6'b10101;
  
	`XRL_C	  : alu = 6'b10010;
	`XRL_D	  : alu = 6'b10010;
	`XRL_I	  : alu = 6'b10010;
	`XRL_R	  : alu = 6'b10010;
  
	`XRL_AD	  : alu = 6'b10110;
  
	`CLR_A	  : alu = 6'b10011;
  
	`CPL_A 	  : alu = 6'b10111;
  
	`RR 	  : alu = 6'b01001;
	`RL 	  : alu = 6'b01010;
	`RRC 	  : alu = 6'b01101;
	`RLC 	  : alu = 6'b01110;

	`MOV_R	  : alu = 6'b01000;
	`MOV_D	  : alu = 6'b01000;
	`MOV_I	  : alu = 6'b01000;
	`MOV_C	  : alu = 6'b01000;
	`MOV_AR	  : alu = 6'b01000;
	`MOV_DR	  : alu = 6'b01000;
	`MOV_CR	  : alu = 6'b01000;
	`MOV_AD	  : alu = 6'b01000;
	`MOV_RD	  : alu = 6'b01000;
	`MOV_DD	  : alu = 6'b01000;
	`MOV_ID	  : alu = 6'b01000;
	`MOV_CD	  : alu = 6'b01000;
	`MOV_AI	  : alu = 6'b01000;
	`MOV_DI	  : alu = 6'b01000;
	`MOV_CI	  : alu = 6'b01000;
	`MOV_I	  : alu = 6'b01000;
	`MOV_AI	  : alu = 6'b01000;

	`XCH_R	  : alu = 6'b01011;
	`XCH_D	  : alu = 6'b01011;
	`XCH_I	  : alu = 6'b01011;
	`XCH_D	  : alu = 6'b01011;

  	`SWAP     : alu = 6'b01111;
	
  	`CLR_B    : alu = 6'b11000;
  	`CLR_C    : alu = 6'b11000;
	
  	`SETB_C   : alu = 6'b11001; 
  	`SETB_B   : alu = 6'b11001; 
	
  	`CPL_B    : alu = 6'b11010; 
  	`CPL_C    : alu = 6'b11010; 
	
  	`ANL_B    : alu = 6'b11011;
	
  	`ANL_NB   : alu = 6'b11100;
  	
  	`ORL_B    : alu = 6'b11101;
	
  	`ORL_NB   : alu = 6'b11110;
	
  	`MOV_BC   : alu = 6'b11111;
  	`MOV_CB   : alu = 6'b11111;
	
  	`ACALL    : alu = 6'b100000;
  	`LCALL    : alu = 6'b100001;
  	`RET      : alu = 6'b100010;
  	`AJMP     : alu = 6'b100011;
  	`LJMP     : alu = 6'b100100;
  	`SJMP     : alu = 6'b100101;
  	`JMP_D    : alu = 6'b100110;
	
  	`CJNE_C   : alu = 6'b110000;
  	`CJNE_R   : alu = 6'b110001;
  	`CJNE_I   : alu = 6'b110010;
  	`CJNE_D   : alu = 6'b100111;
	
  	`DJNZ_R   : alu = 6'b101000;
  	`DJNZ_D   : alu = 6'b101000;
	
  	`JZ       : alu = 6'b101001;
  	`JNZ      : alu = 6'b101010;
  	`JC       : alu = 6'b101011;
  	`JNC      : alu = 6'b101100;
  	`JB       : alu = 6'b101101;
  	`JNB      : alu = 6'b101110;
  	`JBC      : alu = 6'b101111;
	
  	default   : alu = 6'b111111;
	///////////////////////
	

endcase

end

always@(*) begin
	
casex(ins0)

	///////////////////////////////////////
  	`CJNE_I   	: dest0 = {9'b0,ins1};
  	`CJNE_C   	: dest0 = {9'b0,ins1};

	`DJNZ_D		: dest0 = {3'b101,6'b0,ins1};
	`DJNZ_R		: dest0 = {3'b101,2'b10,9'b0,ins0[2:0]};

	`RR			: dest0 = {2'b11,7'b1,8'b0};
	`RRC		: dest0 = {2'b11,7'b1,8'b0};
	`RL			: dest0 = {2'b11,7'b1,8'b0};
	`RLC		: dest0 = {2'b11,7'b1,8'b0};
	//			3'b1
	`SWAP		: dest0 = {2'b11,7'b1,8'b0};	
	`DA			: dest0 = {2'b11,7'b1,8'b0};
	`CLR_A		: dest0 = {2'b11,7'b1,8'b0};	
	`CPL_A		: dest0 = {2'b11,7'b1,8'b0};	
	//			3'b1
	`INC_A		: dest0 = {2'b11,7'b1,8'b0};	
	`DEC_A		: dest0 = {2'b11,7'b1,8'b0};	
	`ADD_C		: dest0 = {2'b11,7'b1,8'b0};	
	`ADDC_C		: dest0 = {2'b11,7'b1,8'b0};	
	`ORL_C		: dest0 = {2'b11,7'b1,8'b0};	
	`ANL_C		: dest0 = {2'b11,7'b1,8'b0};	
	`XRL_C		: dest0 = {2'b11,7'b1,8'b0};	
	`MOV_C		: dest0 = {2'b11,7'b1,8'b0};	
	`SUBB_C		: dest0 = {2'b11,7'b1,8'b0};	
	//			3'b1
	`ADD_D		: dest0 = {2'b11,7'b1,8'b0};	
	`ADDC_D		: dest0 = {2'b11,7'b1,8'b0};	
	`ORL_D		: dest0 = {2'b11,7'b1,8'b0};	
	`ANL_D		: dest0 = {2'b11,7'b1,8'b0};	
	`XRL_D		: dest0 = {2'b11,7'b1,8'b0};	
	`SUBB_D		: dest0 = {2'b11,7'b1,8'b0};	
	`MOV_D		: dest0 = {2'b11,7'b1,8'b0};	
	//			3'b1
	`ADD_I		: dest0 = {2'b11,7'b1,8'b0};	
	`ADDC_I		: dest0 = {2'b11,7'b1,8'b0};	
	`ORL_I		: dest0 = {2'b11,7'b1,8'b0};	
	`ANL_I		: dest0 = {2'b11,7'b1,8'b0};	
	`XRL_I		: dest0 = {2'b11,7'b1,8'b0};	
	`SUBB_I		: dest0 = {2'b11,7'b1,8'b0};	
	`MOV_I		: dest0 = {2'b11,7'b1,8'b0};	
	//			3'b1
	`ADD_R		: dest0 = {2'b11,7'b1,8'b0};	
	`ADDC_R		: dest0 = {2'b11,7'b1,8'b0};	
	`ORL_R		: dest0 = {2'b11,7'b1,8'b0};	
	`ANL_R		: dest0 = {2'b11,7'b1,8'b0};	
	`XRL_R		: dest0 = {2'b11,7'b1,8'b0};	
	`SUBB_R		: dest0 = {2'b11,7'b1,8'b0};	
	`MOV_R		: dest0 = {2'b11,7'b1,8'b0};	
	///////////////////////////////////////

	`INC_D		: dest0 = {3'b101,6'b0,ins1};
	`DEC_D		: dest0 = {3'b101,6'b0,ins1};
	`MOV_CD		: dest0 = {3'b101,6'b0,ins1};
	`MOV_DD		: dest0 = {3'b101,6'b0,ins1};
	`MOV_AD		: dest0 = {3'b101,6'b0,ins1};
	`MOV_ID		: dest0 = {3'b101,6'b0,ins1};
	`MOV_RD		: dest0 = {3'b101,6'b0,ins1};

	`MOV_CI		: dest0 = {3'b101,2'b01,11'b0,ins0[0]};
	`MOV_AI		: dest0 = {3'b101,2'b01,11'b0,ins0[0]};
	`MOV_DI		: dest0 = {3'b101,2'b01,11'b0,ins0[0]};

	`XCH_D		: dest0 = {3'b101,6'b1,ins1};

	`DIV		: dest0 = {2'b11,7'b1,3'b0,2'b1,3'b0};
	`MUL		: dest0 = {2'b11,7'b1,3'b0,2'b1,3'b0};

	`XCH_I		: dest0 = {3'b101,2'b01,4'b1,7'b0,ins0[0]};
	`XCHD		: dest0 = {3'b101,2'b01,4'b1,7'b0,ins0[0]};

	`INC_R		: dest0 = {3'b101,2'b10,9'b0,ins0[2:0]};
	`DEC_R		: dest0 = {3'b101,2'b10,9'b0,ins0[2:0]};
	`MOV_CR		: dest0 = {3'b101,2'b10,9'b0,ins0[2:0]};
	`MOV_DR		: dest0 = {3'b101,2'b10,9'b0,ins0[2:0]};
	`MOV_AR		: dest0 = {3'b101,2'b10,9'b0,ins0[2:0]};

	`XCH_R		: dest0 = {3'b101,2'b10,4'b1,5'b0,ins0[2:0]};

	`ORL_B		: dest0 = {3'b110,6'b0,3'd7,2'b11,3'b0};
	`ANL_B		: dest0 = {3'b110,6'b0,3'd7,2'b11,3'b0};
	`MOV_BC		: dest0 = {3'b110,6'b0,3'd7,2'b11,3'b0};
	`ORL_NB		: dest0 = {3'b110,6'b0,3'd7,2'b11,3'b0};
	`ANL_NB		: dest0 = {3'b110,6'b0,3'd7,2'b11,3'b0};
	`CPL_C		: dest0 = {3'b110,6'b0,3'd7,2'b11,3'b0};
	`CLR_C		: dest0 = {3'b110,6'b0,3'd7,2'b11,3'b0};
	`SETB_C		: dest0 = {3'b110,6'b0,3'd7,2'b11,3'b0};
		
	`CPL_B		: dest0 = {3'b101,2'b11,4'b0,ins1};
	`CLR_B		: dest0 = {3'b101,2'b11,4'b0,ins1};
	`SETB_B		: dest0 = {3'b101,2'b11,4'b0,ins1};
	`MOV_CB		: dest0 = {3'b101,2'b11,4'b0,ins1};

	`INC_I		: dest0 = {3'b100,2'b01,11'b0,ins0[0]};		
	`DEC_I		: dest0 = {3'b100,2'b01,11'b0,ins0[0]};		
				
	`ORL_AD		: dest0 = {3'b101,6'b0,ins1};
	`ANL_AD		: dest0 = {3'b101,6'b0,ins1};
	`XRL_AD		: dest0 = {3'b101,6'b0,ins1};

	default		: dest0 = 17'b0;

endcase

casex(ins0)

	`CJNE_C		: source0 = {3'b101,7'b0,ins1};			
	`CJNE_D		: source0 = {3'b100,7'b0,ins1};			
	`CJNE_I		: source0 = {3'b100,2'b01,12'b0,ins0[0]};		
	`CJNE_R		: source0 = {3'b100,2'b10,10'b0,ins0[2:0]};		
	`DJNZ_D		: source0 = {3'b100,7'b0,ins1};			
	`DJNZ_R		: source0 = {3'b100,2'b10,10'b0,ins0[2:0]};		
	
	`SWAP   	: source0 = {3'b101,15'b0};
	`DA     	: source0 = {3'b101,15'b0};
	`CLR_A  	: source0 = {3'b101,15'b0};
	`CPL_A  	: source0 = {3'b101,15'b0};
	//      	: source0 = {3'b101,15'b0};
	`RR     	: source0 = {3'b101,15'b0};
	`RRC    	: source0 = {3'b101,15'b0};
	`RL     	: source0 = {3'b101,15'b0};
	`RLC    	: source0 = {3'b101,15'b0};
	//      	: source0 = {3'b101,15'b0};
	`INC_A  	: source0 = {3'b110,2'b0,2'b10,11'b0};
	`DEC_A  	: source0 = {3'b110,2'b0,2'b10,11'b0};
	`DIV    	: source0 = {3'b110,2'b0,2'b10,11'b0};
	`MUL    	: source0 = {3'b110,2'b0,2'b10,11'b0};
	`MOV_AD 	: source0 = {3'b110,2'b0,2'b10,11'b0};
	`MOV_AI 	: source0 = {3'b110,2'b0,2'b10,11'b0};
	`MOV_AR 	: source0 = {3'b110,2'b0,2'b10,11'b0};
	/////////////////
	`ADD_C		: source0 = {3'b101,7'b0,ins1};			
	`ADDC_C		: source0 = {3'b101,7'b0,ins1};		
	`ORL_C		: source0 = {3'b101,7'b0,ins1};		
	`ANL_C		: source0 = {3'b101,7'b0,ins1};		
	`XRL_C		: source0 = {3'b101,7'b0,ins1};		
	`MOV_C		: source0 = {3'b101,7'b0,ins1};		
	`SUBB_C		: source0 = {3'b101,7'b0,ins1};		
				
	`MOV_CD		: source0 = {3'b101,7'b0,ins2};	
	`MOV_CI		: source0 = {3'b101,7'b0,ins1};	
	`MOV_CR		: source0 = {3'b101,7'b0,ins1};	
	////////////////////
	`INC_D		: source0 = {3'b100,7'b0,ins1};		
	`DEC_D		: source0 = {3'b100,7'b0,ins1};		
				
	`ADD_D		: source0 = {3'b100,7'b0,ins1};			
	`ADDC_D		: source0 = {3'b100,7'b0,ins1};		
	`ORL_D		: source0 = {3'b100,7'b0,ins1};			
	`ANL_D		: source0 = {3'b100,7'b0,ins1};			
	`XRL_D		: source0 = {3'b100,7'b0,ins1};			
	`SUBB_D		: source0 = {3'b100,7'b0,ins1};		
	`MOV_D		: source0 = {3'b100,7'b0,ins1};			
				
	`XCH_D		: source0 = {3'b100,7'b0,ins1};		
	`MOV_DD		: source0 = {3'b100,7'b0,ins1};		
	`MOV_DI		: source0 = {3'b100,7'b0,ins1};		
	`MOV_DR		: source0 = {3'b100,7'b0,ins1};	

	`ORL_AD		: source0 = {3'b100,7'b0,ins1};
	`ANL_AD		: source0 = {3'b100,7'b0,ins1};
	`XRL_AD		: source0 = {3'b100,7'b0,ins1};
	////////////////////
	`INC_I		: source0 = {3'b100,2'b01,12'b0,ins0[0]};		
	`DEC_I		: source0 = {3'b100,2'b01,12'b0,ins0[0]};		
				
	`ADD_I		: source0 = {3'b100,2'b01,12'b0,ins0[0]};			
	`ADDC_I		: source0 = {3'b100,2'b01,12'b0,ins0[0]};			
	`ORL_I		: source0 = {3'b100,2'b01,12'b0,ins0[0]};			
	`ANL_I		: source0 = {3'b100,2'b01,12'b0,ins0[0]};			
	`XRL_I		: source0 = {3'b100,2'b01,12'b0,ins0[0]};			
	`SUBB_I		: source0 = {3'b100,2'b01,12'b0,ins0[0]};			
	`MOV_I		: source0 = {3'b100,2'b01,12'b0,ins0[0]};			
				
	`MOV_ID		: source0 = {3'b100,2'b01,12'b0,ins0[0]};		
				
	`XCH_I		: source0 = {3'b100,2'b01,12'b0,ins0[0]};		
	`XCHD		: source0 = {3'b100,2'b01,12'b0,ins0[0]};		
	//////////////////
	`INC_R		: source0 = {3'b100,2'b10,10'b0,ins0[2:0]};		
	`DEC_R		: source0 = {3'b100,2'b10,10'b0,ins0[2:0]};		
	`ADD_R		: source0 = {3'b100,2'b10,10'b0,ins0[2:0]};			
				
	`ADDC_R		: source0 = {3'b100,2'b10,10'b0,ins0[2:0]};			
	`ORL_R		: source0 = {3'b100,2'b10,10'b0,ins0[2:0]};			
	`ANL_R		: source0 = {3'b100,2'b10,10'b0,ins0[2:0]};			
	`XRL_R		: source0 = {3'b100,2'b10,10'b0,ins0[2:0]};			
	`SUBB_R		: source0 = {3'b100,2'b10,10'b0,ins0[2:0]};			
	`MOV_R		: source0 = {3'b100,2'b10,10'b0,ins0[2:0]};			
				
	`MOV_RD		: source0 = {3'b100,2'b10,10'b0,ins0[2:0]};		
	`XCH_R		: source0 = {3'b100,2'b10,10'b0,ins0[2:0]};		
	/////////////////
	`ORL_B		: source0 = {3'b100,2'b11,2'b0,ins1[2:0],ins1};		
	`ANL_B		: source0 = {3'b100,2'b11,2'b0,ins1[2:0],ins1};		
	`MOV_BC		: source0 = {3'b100,2'b11,2'b0,ins1[2:0],ins1};		
	`ORL_NB		: source0 = {3'b100,2'b11,2'b0,ins1[2:0],ins1};		
	`ANL_NB		: source0 = {3'b100,2'b11,2'b0,ins1[2:0],ins1};		
	`CPL_B		: source0 = {3'b100,2'b11,2'b0,ins1[2:0],ins1};		
	`CLR_B		: source0 = {3'b100,2'b11,2'b0,ins1[2:0],ins1};		
	`SETB_B		: source0 = {3'b100,2'b11,2'b0,ins1[2:0],ins1};		
	`JB			: source0 = {3'b100,2'b11,2'b0,ins1[2:0],ins1};		
	`JNB		: source0 = {3'b100,2'b11,2'b0,ins1[2:0],ins1};		
	`JBC		: source0 = {3'b100,2'b11,2'b0,ins1[2:0],ins1};		
				
	`CPL_C	  	: source0 = {3'b110,2'b0,2'b11,3'b0,8'd7};			
	`CLR_C    	: source0 = {3'b110,2'b0,2'b11,3'b0,8'd7};						
	`SETB_C   	: source0 = {3'b110,2'b0,2'b11,3'b0,8'd7};			
	`MOV_CB   	: source0 = {3'b110,2'b0,2'b11,3'b0,8'd7};					  

	default 	: source0 = 18'b0;

endcase

end

endmodule


