`timescale 1ns / 1ps

module alu(
     input clk,
     input reset,
     input [5:0] opcode_in,
     input [7:0] src_data_in,
	 input [17:0] src_info_in,
	 input [16:0] des_info_in,
	 input nop_alu_in,
     
	 output reg branch_valid_out,	 
	 output reg branch_out,
	 output reg stall_alu_out,
	 output nop_alu_out,
	 output reg [7:0] des_data_out,
	 
	 output reg [7:0] A,
	 output reg [7:0] B,
	 output reg [7:0] PSW,
	 output reg [15:0] PC,
	 output reg [15:0] SP,
	 output reg [15:0] DPTR
    );
	`include "labels.v"
	integer i;	
	always@(posedge clk)stall_alu_out<=1'b0;
	
	wire [2:0] unit_select;
	wire [3:0] operation_select;

	wire c_in,ac_in,f0_in,ov_in,p_in;
	wire [1:0] rs_in;

	assign c_in  = PSW[7];
	assign ac_in = PSW[6];
	assign f0_in = PSW[5];
	assign rs_in = PSW[4:3];
	assign ov_in = PSW[2];
	assign p_in  = PSW[0];
	
	assign unit_select      = opcode_in[5:3];
	assign operation_select = opcode_in[2:0];
	
	wire[16:0] mulitplier_out;
	
	assign mulitplier_out = {8'b0, A} * {8'b0, B};

	assign nop_alu_out = (des_info_in[16:15]==2'b11);
	
	reg [7:0] SFR_src_one;

	reg [7:0] des_data_out_C;
	reg [7:0] des_data_out_branch;
	reg c_branch;
	reg [7:0] A_C;
	reg [7:0] B_C;
	reg [7:0] PSW_C;
	reg [15:0] DPTR_C;
	reg [15:0] PC_C;
	reg [15:0] SP_C;

	reg [4:0] tmp; 	
	always@(*)begin
		case(src_info_in[12:8])
				5'b10000:SFR_src_one = A;
				5'b01000:SFR_src_one = B;
				5'b11000:SFR_src_one = PSW;
				5'b00010:SFR_src_one = DPTR[7:0]; 
				5'b00011:SFR_src_one = DPTR[15:8]; 
				5'b00100:SFR_src_one = PC[7:0]; 
				5'b00101:SFR_src_one = PC[15:8]; 
				5'b00110:SFR_src_one = SP[7:0]; 
				5'b00111:SFR_src_one = SP[15:8];
			   default:SFR_src_one = 8'b0;
	   endcase	   

	end

	always@(*)
			if(reset)begin
					branch_valid_out=1'b0;
					branch_out=1'b0;
			end
			else begin
				if(~nop_alu_in)begin
					case(opcode_in)
							`ALU_JZ:begin
								if(~(|A))begin branch_valid_out=1'b1;branch_out=1'b1;end
								else begin branch_valid_out=1'b1;branch_out=1'b0;end
								des_data_out_branch = 8'b0;
							end
							`ALU_JNZ:begin
								if(|A)begin branch_valid_out=1'b1;branch_out=1'b1;end
								else begin branch_valid_out=1'b1;branch_out=1'b0;end
								des_data_out_branch = 8'b0;
							end
							`ALU_JC:begin
								if(PSW[7])begin branch_valid_out=1'b1;branch_out=1'b1;end
								else begin branch_valid_out=1'b1;branch_out=1'b0;end
								des_data_out_branch = 8'b0;
							end
							`ALU_JNC:begin
								if(~PSW[7])begin branch_valid_out=1'b1;branch_out=1'b1;end
								else begin branch_valid_out=1'b1;branch_out=1'b0;end
								des_data_out_branch = 8'b0;
							end
							`ALU_JB:begin
									if(src_info_in[17]&&src_info_in[16])begin
											if(|(SFR_src_one&(8'b1<<src_info_in[2:0])))begin
													branch_valid_out=1'b1;branch_out=1'b1;					
											end
											else begin
													branch_valid_out=1'b1;branch_out=1'b0;
											end
									end
									else begin
											if(|(src_data_in&(8'b1<<src_info_in[10:8])))begin
													branch_valid_out=1'b1;branch_out=1'b1;					
											end
											else begin
													branch_valid_out=1'b1;branch_out=1'b0;
											end
									end
									des_data_out_branch = 8'b0;
							end
							`ALU_JNB:begin
									if(src_info_in[17]&&src_info_in[16])begin
											if(~|(SFR_src_one&(8'b1<<src_info_in[2:0])))begin
													branch_valid_out=1'b1;branch_out=1'b1;					
											end
											else begin
													branch_valid_out=1'b1;branch_out=1'b0;
											end
									end
									else begin
											if(~|(src_data_in&(8'b1<<src_info_in[10:8])))begin
													branch_valid_out=1'b1;branch_out=1'b1;					
											end
											else begin
													branch_valid_out=1'b1;branch_out=1'b0;
											end
									end
									des_data_out_branch = 8'b0;
							end
							`ALU_JBC:begin
									if(src_info_in[17]&&src_info_in[16])begin
											if(|(SFR_src_one&(8'b1<<src_info_in[2:0])))begin
													branch_valid_out=1'b1;branch_out=1'b1;
													des_data_out_branch = SFR_src_one&~(8'b1<<src_info_in[2:0]);					
											end
											else begin
													branch_valid_out=1'b1;branch_out=1'b0;
													des_data_out_branch = 8'b0;
											end
									end
									else begin
											if(|(src_data_in&(8'b1<<src_info_in[10:8])))begin
													branch_valid_out=1'b1;branch_out=1'b1;					
													des_data_out_branch = src_data_in&~(8'b1<<src_info_in[10:8]);					
											end
											else begin
													branch_valid_out=1'b1;branch_out=1'b0;
													des_data_out_branch = 8'b0;
											end
									end
							end
							`ALU_CJNE_AD:begin
									if(src_info_in[17:16]==2'b11)begin
											if(A!=SFR_src_one)begin
													branch_valid_out=1'b1;branch_out=1'b1;if(A<SFR_src_one)c_branch=1'b1;else c_branch=1'b0;
											end
											else begin branch_valid_out=1'b1;branch_out=1'b0;end
									end
									else begin
											if(A!=src_data_in)begin
													branch_valid_out=1'b1;branch_out=1'b1;if(A<src_data_in)c_branch=1'b1;else c_branch=1'b0;
											end
											else begin branch_valid_out=1'b1;branch_out=1'b0;end
									end
							end
							`ALU_CJNE_ADATA:begin
									if(A!=src_info_in[7:0])begin
											branch_valid_out=1'b1;branch_out=1'b1;if(A<src_info_in[7:0])c_branch=1'b1;else c_branch=1'b0;
									end
									else begin branch_valid_out=1'b1;branch_out=1'b0;end
							end
							`ALU_CJNE_RDATA:begin
									if(src_data_in!=des_info_in[7:0])begin
											branch_valid_out=1'b1;branch_out=1'b1;if(src_data_in<des_info_in[7:0])c_branch=1'b1;else c_branch=1'b0;
									end
									else begin branch_valid_out=1'b1;branch_out=1'b0;end
							end
							`ALU_CJNE_ATRDATA:begin
									if(src_data_in!=des_info_in[7:0])begin
											branch_valid_out=1'b1;branch_out=1'b1;if(src_data_in<des_info_in[7:0])c_branch=1'b1;else c_branch=1'b0;
									end
									else begin branch_valid_out=1'b1;branch_out=1'b0;end
							end
							`ALU_DJNZ:begin
									if(src_info_in[17:16]==2'b11)begin
											des_data_out_branch=SFR_src_one-8'b1;
											if(|des_data_out_branch)begin
													branch_valid_out=1'b1;branch_out=1'b1;
											end
											else begin branch_valid_out=1'b1;branch_out=1'b0;end
									end
									else begin
											des_data_out_branch=src_data_in-8'b1;
											if(|des_data_out_branch)begin
													branch_valid_out=1'b1;branch_out=1'b1;
											end
											else begin branch_valid_out=1'b1;branch_out=1'b0;end
									end
							end
							default:begin branch_valid_out=1'b0;branch_out=1'b0;des_data_out_branch=8'b0;end
					endcase
				end
				else begin branch_valid_out=1'b0;branch_out=1'b0;des_data_out_branch=8'b0;c_branch=PSW[7];end
			end
	always@(posedge clk)
			if (reset)begin
					des_data_out <= 8'b0;
					A <= 8'b0;
					B <= 8'b0;
					PSW <= 8'b0;
					DPTR <= 16'b0;
					PC <= 16'b0;
					SP <= 16'b0;
			end
			else begin
					if(opcode_in==`ALU_JBC||opcode_in==`ALU_DJNZ)des_data_out <= des_data_out_branch;else des_data_out<=des_data_out_C;	
					A <= A_C;
					B <= B_C;
					if(opcode_in==`ALU_CJNE_AD||opcode_in==`ALU_CJNE_ADATA||opcode_in==`ALU_CJNE_RDATA||opcode_in==`ALU_CJNE_ATRDATA)
					PSW <= {c_branch,PSW_C[6:0]};
					else PSW<= PSW_C;
					DPTR <= DPTR_C;
					PC <= PC_C;
					SP <= SP_C;
			end


	always@(*) 
		if (reset) begin
			des_data_out_C = 8'b0;
			A_C = 8'b0;
			B_C = 8'b0;
			PSW_C = 8'b0;
			PC_C = 16'b0;
			SP_C = 16'b0;
			DPTR_C = 16'b0;
		end
		else begin
				des_data_out_C = des_data_out;
				A_C = A;
				B_C = B;
				PSW_C = PSW;
				PC_C = PC;
				SP_C = SP;
				DPTR_C = DPTR;
			if(~nop_alu_in)begin
			case (unit_select)
				`ALU_ARITHMATIC_UNIT:
					case (operation_select)
						`ALU_ADD: begin
							if(src_info_in[17]&&src_info_in[16]) begin 
						    		{PSW_C[7],A_C} = {1'b0,A} + {1'b0,SFR_src_one};
									tmp = {1'b0,A[3:0]}+{1'b0,SFR_src_one[3:0]};
							end
							else if (src_info_in[17]&&src_info_in[15])begin
									{PSW_C[7],A_C} = {1'b0,A} + {1'b0,src_info_in[7:0]};
									tmp = {1'b0,A[3:0]}+{1'b0,src_info_in[3:0]};
							end
							else begin
									{PSW_C[7],A_C} = {1'b0,A} + {1'b0,src_data_in};
									tmp = {1'b0,A[3:0]}+{1'b0,src_data_in[3:0]};
							end
							PSW_C[2] = PSW_C[7] ^ A_C[7];
							PSW_C[6] = tmp[4];
							
						end
						
						`ALU_ADDC: begin
							if (src_info_in[17]&&src_info_in[16]) begin 
						    		{PSW_C[7],A_C} = {1'b0,A} + {1'b0,SFR_src_one} + {8'b0,c_in};
									tmp = {1'b0,A[3:0]}+{1'b0,SFR_src_one[3:0]}+{4'b0,c_in};
							end
							else if (src_info_in[17]&&src_info_in[15])begin
									{PSW_C[7],A_C} = {1'b0,A} + {1'b0,src_info_in[7:0]} + {8'b0,c_in};
									tmp = {1'b0,A[3:0]}+{1'b0,src_info_in[3:0]}+{4'b0,c_in};
							end
							else begin
									{PSW_C[7],A_C} = {1'b0,A} + {1'b0,src_data_in}+{8'b0,c_in};
									tmp = {1'b0,A[3:0]}+{1'b0,src_data_in[3:0]}+{4'b0,c_in};
							end
							PSW_C[2] = PSW_C[7] ^ A_C[7];
							PSW_C[6] = tmp[4];
							
						end
						
						`ALU_SUBB: begin
							if (src_info_in[17]&&src_info_in[16]) begin 
						    		{PSW_C[7],A_C} = {1'b0,A} - {1'b0,SFR_src_one} - {8'b0,c_in};
									tmp = {1'b0,A[3:0]}-{1'b0,SFR_src_one[3:0]}-{4'b0,c_in};
						    end
							else if (src_info_in[17]&&src_info_in[15])begin
									{PSW_C[7],A_C} = {1'b0,A} - {1'b0,src_info_in[7:0]}-{8'b0,c_in};
									tmp = {1'b0,A[3:0]}-{1'b0,src_info_in[3:0]}-{4'b0,c_in};
							end
							else begin
									{PSW_C[7],A_C} = {1'b0,A} - {1'b0,src_data_in}-{8'b0,c_in};
									tmp = {1'b0,A[3:0]}-{1'b0,src_data_in[3:0]}-{4'b0,c_in};
							end
							PSW_C[2] = PSW_C[7] ^ A_C[7];
							PSW_C[6] = tmp[4];
							
						end
						
						`ALU_INC: begin
							if (src_info_in[17]&&src_info_in[16]) begin 
									if (src_info_in[12:11]==2'b10)
										A_C = A + 8'b1;
									else if (src_info_in[12:11]==2'b01)
									    B_C = B + 8'b1;
									else if (src_info_in[12:11]==2'b11)
										PSW_C = PSW + 8'b1;
									else if (src_info_in[10:8]==3'b010)
										DPTR_C ={DPTR[15:8], DPTR[7:0] + 8'b1};
									else if (src_info_in[10:8]==3'b011)
										DPTR_C = {DPTR[15:8] + 8'b1,DPTR[7:0]};
									else if (src_info_in[10:8]==3'b100)
										PC_C = {PC[15:8],PC[7:0] + 8'b1};
									else if (src_info_in[10:8]==3'b101)
										PC_C = {PC[15:8] + 8'b1,PC[7:0]};
									else if (src_info_in[10:8]==3'b110)
										SP_C = {SP[15:8],SP[7:0] + 8'b1};
									else if (src_info_in[10:8]==3'b111)
										SP_C = {SP[15:8] + 8'b1,SP[7:0]};
									
						    end
							else
                                    des_data_out_C = src_data_in + 8'b1;
							PSW_C = {1'b0,PSW[6:0]};
						end
						
						`ALU_DEC:begin
							if (src_info_in[17]&&src_info_in[16]) begin 
									if (src_info_in[12:11]==2'b10)
										A_C = A - 8'b1;
									else if (src_info_in[12:11]==2'b01)
									    B_C = B - 8'b1;
									else if (src_info_in[12:11]==2'b11)
										PSW_C = PSW - 8'b1;
									else if (src_info_in[10:8]==3'b010)
										DPTR_C ={DPTR[15:8], DPTR[7:0] - 8'b1};
									else if (src_info_in[10:8]==3'b011)
										DPTR_C = {DPTR[15:8] - 8'b1,DPTR[7:0]};
									else if (src_info_in[10:8]==3'b100)
										PC_C = {PC[15:8],PC[7:0] - 8'b1};
									else if (src_info_in[10:8]==3'b101)
										PC_C = {PC[15:8] - 8'b1,PC[7:0]};
									else if (src_info_in[10:8]==3'b110)
										SP_C = {SP[15:8],SP[7:0] - 8'b1};
									else if (src_info_in[10:8]==3'b111)
										SP_C = {SP[15:8] - 8'b1,SP[7:0]};
									
						    end
							else
                                    des_data_out_C = src_data_in - 8'b1;
							PSW_C = {1'b0,PSW[6:0]};
						end		
						
						`ALU_MUL: begin
							A_C      = mulitplier_out[7:0];
							B_C      = mulitplier_out[15:8];
							PSW_C    = {1'b0,PSW[6:3],|B,PSW[1:0]};
							
						end
						
						`ALU_DIV: begin
							if (|B)begin
								A_C       = A / B;		
								B_C       = A % B;
							end
							
							PSW_C = {1'b0,PSW[6:3],~(&B),PSW[1:0]};
							
						end
						
						`ALU_DA: begin
							A_C[3:0] = (A[3] & (A[2] | A[1]) & ac_in) ?  (A[3:0] + 4'b0110) : A[3:0];
							A_C[7:4] = (A[7] & (A[6] | A[5]) & c_in ) ?  (A[7:4] + 4'b0110) : A[7:4];
							PSW_C = {A[7] | (A[6] & ( A[2] | A[3] | A[4])),PSW[6:0]};
							
						end
						
					endcase
					
				`ALU_LOGICAL_UNIT:
					case (operation_select)
						`ALU_AND_A:begin 
							if (src_info_in[17]&&src_info_in[16]) begin 
						    		A_C = A & SFR_src_one;
							end
							else if (src_info_in[17]&&src_info_in[15])
									A_C = A & src_info_in[7:0];
							else
									A_C = A & src_data_in;
							
						end

						`ALU_AND_direct:begin
								if(src_info_in[17]&&src_info_in[15])begin 
										if(des_info_in[16]&&des_info_in[15])begin
												if (des_info_in[4:3]==2'b10|des_info_in[8])
													A_C = A & src_info_in[7:0];
												else if (des_info_in[4:3]==2'b01)
												    B_C = B & src_info_in[7:0];
												else if (des_info_in[4:3]==2'b11)
													PSW_C = PSW & src_info_in[7:0];
												else if (des_info_in[2:0]==3'b010)
													DPTR_C = {DPTR[15:8],DPTR[7:0] & src_info_in[7:0]};
												else if (des_info_in[2:0]==3'b011)
													DPTR_C = {DPTR[15:8] & src_info_in[7:0],DPTR[7:0]};
												else if (des_info_in[2:0]==3'b100)
													PC_C = {PC[15:8],PC[7:0] & src_info_in[7:0]};
												else if (des_info_in[2:0]==3'b101)
													PC_C = {PC[15:8] & src_info_in[7:0],PC[7:0]};
												else if (des_info_in[2:0]==3'b110)
													SP_C = {SP[15:8],SP[7:0] & src_info_in[7:0]};
												else if (des_info_in[2:0]==3'b111)
													SP_C = {SP[15:8] & src_info_in[7:0],SP[7:0]};
												
										end
										else
												des_data_out_C = src_data_in & src_info_in[7:0];
								end
								else begin
										if(des_info_in[16]&&des_info_in[15])begin
												if (des_info_in[4:3]==2'b10|des_info_in[8])
													A_C = A & A;
												else if (des_info_in[4:3]==2'b01)
												    B_C = B & A;
												else if (des_info_in[4:3]==2'b11)
													PSW_C = PSW & A;
												else if (des_info_in[2:0]==3'b010)
													DPTR_C = {DPTR[15:8],DPTR[7:0] & A};
												else if (des_info_in[2:0]==3'b011)
													DPTR_C = {DPTR[15:8] & A,DPTR[7:0]};
												else if (des_info_in[2:0]==3'b100)
													PC_C = {PC[15:8],PC[7:0] & A};
												else if (des_info_in[2:0]==3'b101)
													PC_C = {PC[15:8] & A,PC[7:0]};
												else if (des_info_in[2:0]==3'b110)
													SP_C = {SP[15:8],SP[7:0] & A};
												else if (des_info_in[2:0]==3'b111)
													SP_C = {SP[15:8] & A,SP[7:0]};
												
										end
										else
												des_data_out_C = src_data_in & A;
								end
						end

						`ALU_OR_A:begin
							if (src_info_in[17]&&src_info_in[16]) begin 
						    		A_C = A | SFR_src_one;
							end
							else if (src_info_in[17]&&src_info_in[15])
									A_C = A | src_info_in[7:0];
							else
									A_C = A | src_data_in;
							
						end
						
						`ALU_OR_direct:begin
								if(src_info_in[17]&&src_info_in[15])begin 
										if(des_info_in[16]&&des_info_in[15])begin
												if (des_info_in[4:3]==2'b10|des_info_in[8])
													A_C = A | src_info_in[7:0];
												else if (des_info_in[4:3]==2'b01)
												    B_C = B | src_info_in[7:0];
												else if (des_info_in[4:3]==2'b11)
													PSW_C = PSW | src_info_in[7:0];
												else if (des_info_in[2:0]==3'b010)
													DPTR_C = {DPTR[15:8],DPTR[7:0] | src_info_in[7:0]};
												else if (des_info_in[2:0]==3'b011)
													DPTR_C = {DPTR[15:8] | src_info_in[7:0],DPTR[7:0]};
												else if (des_info_in[2:0]==3'b100)
													PC_C = {PC[15:8],PC[7:0] | src_info_in[7:0]};
												else if (des_info_in[2:0]==3'b101)
													PC_C = {PC[15:8] | src_info_in[7:0],PC[7:0]};
												else if (des_info_in[2:0]==3'b110)
													SP_C = {SP[15:8],SP[7:0] | src_info_in[7:0]};
												else if (des_info_in[2:0]==3'b111)
													SP_C = {SP[15:8] | src_info_in[7:0],SP[7:0]};
												
										end
										else
												des_data_out_C = src_data_in | src_info_in[7:0];
								end
								else begin
										if(des_info_in[16]&&des_info_in[15])begin
												if (des_info_in[4:3]==2'b10|des_info_in[8])
													A_C = A | A;
												else if (des_info_in[4:3]==2'b01)
												    B_C = B | A;
												else if (des_info_in[4:3]==2'b11)
													PSW_C = PSW | A;
												else if (des_info_in[2:0]==3'b010)
													DPTR_C = {DPTR[15:8],DPTR[7:0] | A};
												else if (des_info_in[2:0]==3'b011)
													DPTR_C = {DPTR[15:8] | A,DPTR[7:0]};
												else if (des_info_in[2:0]==3'b100)
													PC_C = {PC[15:8],PC[7:0] | A};
												else if (des_info_in[2:0]==3'b101)
													PC_C = {PC[15:8] | A,PC[7:0]};
												else if (des_info_in[2:0]==3'b110)
													SP_C = {SP[15:8],SP[7:0] | A};
												else if (des_info_in[2:0]==3'b111)
													SP_C = {SP[15:8] | A,SP[7:0]};
												
										end
										else
												des_data_out_C = src_data_in | A;
								end
						end

						`ALU_XOR_A:begin 
							if (src_info_in[17]&&src_info_in[16]) begin 
						    		A_C = A ^ SFR_src_one;
							end
							else if (src_info_in[17]&&src_info_in[15])
									A_C = A ^ src_info_in[7:0];
							else
									A_C = A ^ src_data_in;
							
						end

						`ALU_XOR_direct:begin
								if(src_info_in[17]&&src_info_in[15])begin 
										if(des_info_in[16]&&des_info_in[15])begin
												if (des_info_in[4:3]==2'b10|des_info_in[8])
													A_C = A ^ src_info_in[7:0];
												else if (des_info_in[4:3]==2'b01)
												    B_C = B ^ src_info_in[7:0];
												else if (des_info_in[4:3]==2'b11)
													PSW_C = PSW ^ src_info_in[7:0];
												else if (des_info_in[2:0]==3'b010)
													DPTR_C = {DPTR[15:8],DPTR[7:0] ^ src_info_in[7:0]};
												else if (des_info_in[2:0]==3'b011)
													DPTR_C = {DPTR[15:8] ^ src_info_in[7:0],DPTR[7:0]};
												else if (des_info_in[2:0]==3'b100)
													PC_C = {PC[15:8],PC[7:0] ^ src_info_in[7:0]};
												else if (des_info_in[2:0]==3'b101)
													PC_C = {PC[15:8] ^ src_info_in[7:0],PC[7:0]};
												else if (des_info_in[2:0]==3'b110)
													SP_C = {SP[15:8],SP[7:0] ^ src_info_in[7:0]};
												else if (des_info_in[2:0]==3'b111)
													SP_C = {SP[15:8] ^ src_info_in[7:0],SP[7:0]};
												
										end
										else
												des_data_out_C = src_data_in ^ src_info_in[7:0];
								end
								else begin
										if(des_info_in[16]&&des_info_in[15])begin
												if (des_info_in[4:3]==2'b10|des_info_in[8])
													A_C = A ^ A;
												else if (des_info_in[4:3]==2'b01)
												    B_C = B ^ A;
												else if (des_info_in[4:3]==2'b11)
													PSW_C = PSW ^ A;
												else if (des_info_in[2:0]==3'b010)
													DPTR_C = {DPTR[15:8],DPTR[7:0] ^ A};
												else if (des_info_in[2:0]==3'b011)
													DPTR_C = {DPTR[15:8] ^ A,DPTR[7:0]};
												else if (des_info_in[2:0]==3'b100)
													PC_C = {PC[15:8],PC[7:0] ^ A};
												else if (des_info_in[2:0]==3'b101)
													PC_C = {PC[15:8] ^ A,PC[7:0]};
												else if (des_info_in[2:0]==3'b110)
													SP_C = {SP[15:8],SP[7:0] ^ A};
												else if (des_info_in[2:0]==3'b111)
													SP_C = {SP[15:8] ^ A,SP[7:0]};
												
										end
										else
												des_data_out_C = src_data_in ^ A;
								end
						end

						`ALU_CLR: begin A_C = 8'b0; end

						`ALU_NOT: begin A_C = ~A; end									
					endcase
					
			`ALU_TRANSFER_UNIT:
					case (operation_select)
							`ALU_RR          : begin A_C = {A[0],A[7:1]};end
							`ALU_RL          : begin A_C = {A[6:0],A[7]};end
							`ALU_RRC         : begin PSW_C = {A[0],PSW[6:0]};	A_C = {c_in,A[7:1]};	end
							`ALU_RLC         : begin PSW_C = {A[7],PSW[6:0]};	A_C = {A[6:0],c_in};	end
						`ALU_TRANSFER    : begin
							if(src_info_in[17]&&src_info_in[16])begin
										if(des_info_in[16]&&des_info_in[15])begin
												if(des_info_in[4:3]==2'b10|des_info_in[8])begin
														A_C = SFR_src_one;
												end
												else if(des_info_in[4:3]==2'b01)begin
														B_C = SFR_src_one;
												end
												else if(des_info_in[4:3]==2'b11)begin
														PSW_C = SFR_src_one;
												end
												else if(des_info_in[2:0]==3'b010)begin
														DPTR_C[7:0] = SFR_src_one;
												end
												else if(des_info_in[2:0]==3'b011)begin
														DPTR_C[15:8] = SFR_src_one;
												end
												else if(des_info_in[2:0]==3'b100)begin
														PC_C[7:0] = SFR_src_one;
												end
												else if(des_info_in[2:0]==3'b101)begin
														PC_C[15:8] = SFR_src_one;
												end
												else if(des_info_in[2:0]==3'b110)begin
														SP_C[7:0] = SFR_src_one;
												end
												else if(des_info_in[2:0]==3'b111)begin
														SP_C[15:8] = SFR_src_one;
												end
										end
										else begin
												des_data_out_C = SFR_src_one;
										end
							end
							else if(src_info_in[17]&&src_info_in[15])begin
								if(des_info_in[16]&&des_info_in[15])begin
										if(des_info_in[4:3]==2'b10|des_info_in[8])begin
												A_C = src_info_in[7:0];
										end
										else if(des_info_in[4:3]==2'b01)begin
												B_C = src_info_in[7:0];
										end
										else if(des_info_in[4:3]==2'b11)begin
												PSW_C = src_info_in[7:0];
										end
										else if(des_info_in[2:0]==3'b010)begin
												DPTR_C[7:0] = src_info_in[7:0];
										end
										else if(des_info_in[2:0]==3'b011)begin
												DPTR_C[15:8] = src_info_in[7:0];
										end
										else if(des_info_in[2:0]==3'b100)begin
												PC_C[7:0] = src_info_in[7:0];
										end
										else if(des_info_in[2:0]==3'b101)begin
												PC_C[15:8] = src_info_in[7:0];
										end
										else if(des_info_in[2:0]==3'b110)begin
												SP_C[7:0] = src_info_in[7:0];
										end
										else if(des_info_in[2:0]==3'b111)begin
												SP_C[15:8] = src_info_in[7:0];
										end
								
								end
								else begin
										des_data_out_C = src_info_in[7:0];
										
								end
							end
							else begin
								if(des_info_in[16]&&des_info_in[15])begin
										if(des_info_in[4:3]==2'b10|des_info_in[8])begin
												A_C = src_data_in;
										end
										else if(des_info_in[4:3]==2'b01)begin
												B_C = src_data_in;
										end
										else if(des_info_in[4:3]==2'b11)begin
												PSW_C = src_data_in;
										end
										else if(des_info_in[2:0]==3'b010)begin
												DPTR_C[7:0] = src_data_in;
										end
										else if(des_info_in[2:0]==3'b011)begin
												DPTR_C[15:8] = src_data_in;
										end
										else if(des_info_in[2:0]==3'b100)begin
												PC_C[7:0] = src_data_in;
										end
										else if(des_info_in[2:0]==3'b101)begin
												PC_C[15:8] = src_data_in;
										end
										else if(des_info_in[2:0]==3'b110)begin
												SP_C[7:0] = src_data_in;
										end
										else if(des_info_in[2:0]==3'b111)begin
												SP_C[15:8] = src_data_in;
										end
								
								end
								else begin
										des_data_out_C = src_data_in;
								end	
							end
						end
						`ALU_SWAP        : begin
							if (src_info_in[17]&&src_info_in[16]) begin 
									if (src_info_in[12:11]==2'b10)begin
											A_C = A;end
									else if (src_info_in[12:11]==2'b01)begin
											A_C = B;B_C = A;end
									else if (src_info_in[12:11]==2'b11)begin
											A_C = PSW;PSW_C = A;end
									else if (src_info_in[10:8]==3'b010)begin
											A_C = DPTR[7:0];DPTR_C[7:0] = A;end
									else if (src_info_in[10:8]==3'b011)begin
											A_C = DPTR[15:8];DPTR_C[15:8] = A;end
									else if (src_info_in[10:8]==3'b100)begin
											A_C = PC[7:0];PC_C[7:0] = A;end
									else if (src_info_in[10:8]==3'b101)begin
											A_C = PC[15:8];PC_C[15:8] = A;end
									else if (src_info_in[10:8]==3'b110)begin
											A_C = SP[7:0];SP_C[7:0] = A;end
									else if (src_info_in[10:8]==3'b111)begin
											A_C = SP[15:8];SP_C[15:8] = A;end
						    end
							else begin
									A_C = src_data_in;des_data_out_C = A;end
							
						end
						`ALU_SWAP_NIBBLE : begin A_C = {A[3:0],A[7:4]};end
					endcase
					
				`ALU_BOOLEAN_UNIT:
					case (operation_select)
							`ALU_CLR_BIT : begin
									if(src_info_in[17]&&src_info_in[16])begin
											if (src_info_in[12:11]==2'b10)begin
													A_C=A&~(8'b1<<src_info_in[2:0]);end
											else if (src_info_in[12:11]==2'b01)begin
													B_C=B&~(8'b1<<src_info_in[2:0]);end
											else if (src_info_in[12:11]==2'b11)begin
													PSW_C=PSW&~(8'b1<<src_info_in[2:0]);end
											else if (src_info_in[10:8]==3'b010)begin
													DPTR_C=DPTR&~(16'b1<<src_info_in[2:0]);end
											else if (src_info_in[10:8]==3'b011)begin
													DPTR_C=DPTR&~((16'b1<<src_info_in[2:0])<<8);end
											else if (src_info_in[10:8]==3'b100)begin
													PC_C=PC&~(16'b1<<src_info_in[2:0]);end
											else if (src_info_in[10:8]==3'b101)begin
													PC_C=PC&~((16'b1<<src_info_in[2:0])<<8);end
											else if (src_info_in[10:8]==3'b110)begin
													SP_C=SP&~(16'b1<<src_info_in[2:0]);end
											else if (src_info_in[10:8]==3'b111)begin
													SP_C=SP&~((16'b1<<src_info_in[2:0])<<8);end
									end
									else begin
											des_data_out_C=src_data_in &~(8'b1<<src_info_in[10:8]);
									end
							end
							
							`ALU_SET_BIT : begin
									if(src_info_in[17]&&src_info_in[16])begin
											if (src_info_in[12:11]==2'b10)begin
													A_C=A|(8'b1<<src_info_in[2:0]);end
											else if (src_info_in[12:11]==2'b01)begin
													B_C=B|(8'b1<<src_info_in[2:0]);end
											else if (src_info_in[12:11]==2'b11)begin
													PSW_C=PSW|(8'b1<<src_info_in[2:0]);end
											else if (src_info_in[10:8]==3'b010)begin
													DPTR_C=DPTR|(16'b1<<src_info_in[2:0]);end
											else if (src_info_in[10:8]==3'b011)begin
													DPTR_C=DPTR|((16'b1<<src_info_in[2:0])<<8);end
											else if (src_info_in[10:8]==3'b100)begin
													PC_C=PC|(16'b1<<src_info_in[2:0]);end
											else if (src_info_in[10:8]==3'b101)begin
													PC_C=PC|((16'b1<<src_info_in[2:0])<<8);end
											else if (src_info_in[10:8]==3'b110)begin
													SP_C=SP|(16'b1<<src_info_in[2:0]);end
											else if (src_info_in[10:8]==3'b111)begin
													SP_C=SP|((16'b1<<src_info_in[2:0])<<8);end
											
									end
									else begin
											des_data_out_C=src_data_in |(8'b1<<src_info_in[10:8]);
									end
							end

							`ALU_NOT_BIT : begin
									if(src_info_in[17]&&src_info_in[16])begin
											if (src_info_in[12:11]==2'b10)begin
													A_C=A^(8'b1<<src_info_in[2:0]);end
											else if (src_info_in[12:11]==2'b01)begin
													B_C=B^(8'b1<<src_info_in[2:0]);end
											else if (src_info_in[12:11]==2'b11)begin
													PSW_C=PSW^(8'b1<<src_info_in[2:0]);end
											else if (src_info_in[10:8]==3'b010)begin
													DPTR_C=DPTR^(16'b1<<src_info_in[2:0]);end
											else if (src_info_in[10:8]==3'b011)begin
													DPTR_C=DPTR^((16'b1<<src_info_in[2:0])<<8);end
											else if (src_info_in[10:8]==3'b100)begin
													PC_C=PC^(16'b1<<src_info_in[2:0]);end
											else if (src_info_in[10:8]==3'b101)begin
													PC_C=PC^((16'b1<<src_info_in[2:0])<<8);end
											else if (src_info_in[10:8]==3'b110)begin
													SP_C=SP^(16'b1<<src_info_in[2:0]);end
											else if (src_info_in[10:8]==3'b111)begin
													SP_C=SP^((16'b1<<src_info_in[2:0])<<8);end
											
									end
									else begin
											des_data_out_C=src_data_in ^(8'b1<<src_info_in[10:8]);
									end
							end

							`ALU_AND_BIT : begin
									if(src_info_in[17]&&src_info_in[16])begin
											PSW_C[7] = PSW[7] & SFR_src_one[src_info_in[2:0]];
									end
									else begin
											PSW_C[7] = PSW[7] & src_data_in[src_info_in[10:8]];
									end
									
							end

							`ALU_NOT_AND_BIT : begin
									if(src_info_in[17]&&src_info_in[16])begin
											PSW_C[7] = PSW[7] & ~SFR_src_one[src_info_in[2:0]];
									end
									else begin
											PSW_C[7] = PSW[7] & ~src_data_in[src_info_in[10:8]];
									end
									
							end

							`ALU_OR_BIT       : begin
									if(src_info_in[17]&&src_info_in[16])begin
											PSW_C[7] = PSW[7] | SFR_src_one[src_info_in[2:0]];
									end
									else begin
											PSW_C[7] = PSW[7] | src_data_in[src_info_in[10:8]];
									end
									
							end

							`ALU_NOT_OR_BIT   : begin
									if(src_info_in[17]&&src_info_in[16])begin
											PSW_C[7] = PSW[7] | ~SFR_src_one[src_info_in[2:0]];
									end
									else begin
											PSW_C[7] = PSW[7] | ~src_data_in[src_info_in[10:8]];
									end
									
							end

							`ALU_TRANSFER_BIT : begin
									if(des_info_in[16:15]==2'b11 && des_info_in[4:3]==2'b11 &&des_info_in[7:5]==3'b111)begin
											if(src_info_in[17:16]==2'b11)begin
													PSW_C[7] = SFR_src_one[src_info_in[2:0]];
											end
									        else begin
									        		PSW_C[7] = src_data_in[src_info_in[2:0]];
									        end
											
									end	
								    else begin
											if(des_info_in[16]&&des_info_in[15])begin
												if (des_info_in[4:3]==2'b10|des_info_in[8])begin
														A_C[des_info_in[7:5]]=PSW[7];end
												else if (des_info_in[4:3]==2'b01)begin
														B_C[des_info_in[7:5]]=PSW[7];end
												else if (des_info_in[4:3]==2'b11)begin
														PSW_C[des_info_in[7:5]]=PSW[7];end
												else if (des_info_in[2:0]==3'b010)begin
														DPTR_C[des_info_in[7:5]]=PSW[7];end
												else if (des_info_in[2:0]==3'b011)begin
														DPTR_C[{1'b1,des_info_in[2:0]}]=PSW[7];end
												else if (des_info_in[2:0]==3'b100)begin
														PC_C[des_info_in[7:5]]=PSW[7];end
												else if (des_info_in[2:0]==3'b101)begin
														PC_C[{1'b1,des_info_in[2:0]}]=PSW[7];end
												else if (des_info_in[2:0]==3'b110)begin
														SP_C[des_info_in[7:5]]=PSW[7];end
												else if (des_info_in[2:0]==3'b111)begin
														SP_C[{1'b1,des_info_in[2:0]}]=PSW[7];end
												
											end
											else begin
												for(i = 0;i < 8;i=i+1)
														if (i==src_info_in[2:0])
																des_data_out_C[i] = PSW[7];
														else
																des_data_out_C[i] = src_data_in[i];
											end
									end
							end

					endcase
			endcase
		end	
	end

	endmodule
