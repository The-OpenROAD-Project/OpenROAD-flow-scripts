module ComputeStage
#(
   parameter MEMORY_HALFADDRESS_BITS = 10,
   parameter INSTRUCTION_HALFADDRESS_BITS = 32
)
(
	input wire CLK,
	input wire RST_X,
	input wire[INSTRUCTION_HALFADDRESS_BITS-1:0] PC,
	//input wire Stall,
	output wire BranchRequest, //On branch taken
	output wire BranchPCRelMode, //1: Relative, 0: Direct
	output wire[INSTRUCTION_HALFADDRESS_BITS-1:0] BranchPC,

	//Input from Fetch Stage
	input wire[31:0] Instruction,
	input wire ValidCS,

	//Transferation to Apply Stage
	//output wire MemOp, //Whether to access memory
	//output wire MemRw, //Whether to read (0) or write (1) memory
	//output wire[31:0] AluRes, //Alu result
	//output wire[31:0] RegRdataC, //Readed data of Register C operand
	//output reg[3:0] RegNoC, //Destination register number specified by instruction
	//output reg ValidAS,
	//Memory read value from Apply Stage (when Stall)
	//input wire[31:0] MemReadedData
	//Memory interface
	output wire MemEn,
	output wire[MEMORY_HALFADDRESS_BITS-2:0] MemAddr,
	input wire[31:0] MemRdata,
	output wire MemWen,
	output wire[31:0] MemWdata,
	output wire FetchStallRequest
);

//Decode instruction code
wire[1:0] instrOpcode = Instruction[31:30];
wire instrJumpFlag = Instruction[29];
wire[3:0] instrOperandA = Instruction[28:25];
wire[4:0] instrOperandB = Instruction[24:20];
wire[3:0] instrOperandD = Instruction[19:16];
wire instrJumpByRegister = Instruction[15];
wire[2:0] instrJumpCondition = Instruction[14:12];
wire[11:0] instrJumpAddress = Instruction[11:0];
wire instrIsMemoryOperation = instrOpcode[1] && !instrOpcode[0]; //4ISC Ver. ("instrOpcode[1];" for 3ISC)
wire instrIsShift = instrOpcode[1] && instrOpcode[0];
wire instrMemoryOperationRW = instrJumpFlag;

//Register
wire[3:0] reg_read0_no, reg_read1_no, reg_write0_no;
wire reg_read0_en, reg_read1_en, reg_write0_en;
wire[31:0] reg_read0_rdata, reg_read1_rdata, reg_write0_wdata;
RegisterFile registerFile
(
	.CLK(CLK),
	.RST_X(RST_X),
	//Read port.0
	.NO_R0(reg_read0_no),
	.EN_R0(reg_read0_en),
	.RDATA_R0(reg_read0_rdata),
	//Read port.1
	.NO_R1(reg_read1_no),
	.EN_R1(reg_read1_en),
	.RDATA_R1(reg_read1_rdata),
	//Write port.0
	.NO_W0(reg_write0_no),
	.EN_W0(reg_write0_en),
	.WDATA_W0(reg_write0_wdata)
);
//Alu
wire[31:0] alu_a, alu_b, alu_opres;
wire alu_opflag;
wire alu_condres;
wire[2:0] alu_condflag;
Alu alu
(
	.A(alu_a),
	.B(alu_b),
	.OPFLAG(alu_opflag),
	.CONDFLAG(alu_condflag),
	.OPRES(alu_opres),
	.CONDRES(alu_condres)
);
//Shifter
wire shft_en;
wire[31:0] shft_v, shft_res;
wire[4:0] shft_args;
Shifter shifter
(
	.EN(shft_en),
	.V(shft_v),
	.ARGS(shft_args),
	.RES(shft_res)
);

//Constants
wire[31:0] const_zero = 32'b0;
wire[31:0] const_inc = 32'hFFFFFFFF;
wire[31:0] const_dec = 32'b1;
wire[31:0] const_nfour = 32'hFFFFFFFC;
wire[31:0] const_width = 32'd32;

//Memory access
reg MemAccessState = 1'b0; //0: Address Computing, 1: Accessing
reg MemRWMode;
reg[MEMORY_HALFADDRESS_BITS-2:0] MemAddress; //Word address range
reg[3:0] MemAccessRegNo; //Written register or register having written value
wire IsMemoryAddressComputing = /*ValidCS &&*/ !MemAccessState && instrIsMemoryOperation; //ここのValidCSは必要ないかも
assign FetchStallRequest = /*ValidCS &&*/ MemAccessState; //ここのValidCSは必要ないかも
always @(posedge CLK) begin
	if (!RST_X) begin
		MemAccessState <= 1'b0;
	end
	else begin
		MemAccessState <= IsMemoryAddressComputing;
	end
end
always @(posedge CLK) begin
	if (IsMemoryAddressComputing) begin
		MemAddress <= alu_opres[MEMORY_HALFADDRESS_BITS:2];
		MemAccessRegNo <= instrOperandD;
		MemRWMode <= instrMemoryOperationRW;
	end
end
assign MemEn = MemAccessState;
assign MemAddr = MemAddress;
assign MemWen = MemRWMode; //instrJumpFlag;
assign MemWdata = reg_read0_rdata; //Including register read delay

//Control
//Flow instruction to register
assign reg_read0_en = MemAccessState ? MemRWMode
                                     : ((reg_read0_no[3:2] != 2'b0) || instrIsShift); //Enable on shift instruction cycle
                      //instrIsMemoryOperation ? instrMemoryOperationRW
                      //                       : (reg_read0_no[3:2] != 2'b0);
assign reg_read0_no = MemAccessState ? MemAccessRegNo
                                     : instrOperandA;
                      //instrIsMemoryOperation ? instrOperandD
                      //                       : instrOperandA;
assign reg_read1_en = !instrOperandB[4];
assign reg_read1_no = instrOperandB[3:0];
//Flow register to alu
assign alu_a = instrIsMemoryOperation     ? {{28{instrOperandA[3]}}, instrOperandA[2:0], 1'b0 } :
               reg_read0_en               ? reg_read0_rdata :
               instrOperandA[1:0] == 2'd0 ? const_zero :
               instrOperandA[1:0] == 2'd1 ? const_inc :
               instrOperandA[1:0] == 2'd2 ? const_dec
                                          : const_nfour;
assign alu_b = reg_read1_en     ? reg_read1_rdata :
               instrOperandB[0] ? const_inc :
               instrOperandB[1] ? const_dec :
               instrOperandB[2] ? { {(32-INSTRUCTION_HALFADDRESS_BITS){1'b0}}, PC[INSTRUCTION_HALFADDRESS_BITS-1:0], 1'b0} :
			   instrOperandB[3] ? const_width
			                    : const_zero;
assign alu_opflag = instrOpcode[0]; //[opcode[1][0]] 00:Sub 01:Xan 10:Sub(MEM) 11:Shift //opflag[1]:sub [0]:and [other]:shift  
assign alu_condflag = instrJumpCondition;
//Flow register to alu
assign shft_en = instrIsShift;
assign shft_v = reg_read0_rdata; //On shift instruction cycle, read-enable is asserted even if operand-A specifying constant
//**We have free 6 bits for shift argument: jumpFlag, operandB[4:0]**
//assign shft_dir = instrJumpFlag;
//assign shft_amt = !instrOperandB[4] ? reg_read1_rdata[3:0] :
//                                      instrOperandB[3:0];
assign shft_args = instrOperandB[4:0];

//Flow ApplyStage to register
assign reg_write0_en = MemAccessState ? !MemRWMode
                                      : !instrIsMemoryOperation; //Solved Bug 20180603 [Old="MemAccessState && !MemRWMode || !instrIsMemoryOperation", this may enable writing to RF in case of a stalling cycle for mem-write instruction whose next instruction is sng.]
assign reg_write0_no = MemAccessState ? MemAccessRegNo :
                                        instrOperandD;
assign reg_write0_wdata = MemAccessState ? MemRdata :
                          instrIsShift   ? shft_res :
						                   alu_opres;
//Flow alu to ApplyStage or Stalling
assign BranchRequest = ValidCS && !instrOpcode[1] && instrJumpFlag && alu_condres; //Only when OPCODE==00(sng) or ==01(xan)
assign BranchPCRelMode = 1'b1;
assign BranchPC = { {21{ instrJumpAddress[11] }}, instrJumpAddress[10:0] };


wire ASSERT = MemEn && MemWen && MemAddr <= 'h11D;

/*
always @(posedge CLK) begin
    if (!RST_X) begin
		//MemOp <= 1'b0;
		//MemRw <= 1'b0;
		//AluRes <= 32'b0;
		//RegRdataC <= 32'b0;
		//RegNoC <= 4'b0;
		ValidAS <= 1'b0;
    end else
    
	if (!Stall) begin
		//Normal behaviour
		//MemOp <= instrOpcode[1];
		//MemRw <= instrJumpFlag;
		//AluRes <= alu_opres;
		//RegRdataC <= reg_read0_rdata;
		//RegNoC <= instrOperandD;
		ValidAS <= ValidCS;
	end
	else begin
		//Stall behaviour
		//Do nothing (OK?)
	end
end
*/
endmodule
