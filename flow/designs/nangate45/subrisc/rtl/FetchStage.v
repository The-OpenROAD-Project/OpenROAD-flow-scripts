module FetchStage
#(
   parameter MEMORY_HALFADDRESS_BITS = 10,
   parameter INSTRUCTION_HALFADDRESS_BITS = 32
)
(
	input wire CLK,
	input wire RST_X,
	input wire Stall,
	output wire[INSTRUCTION_HALFADDRESS_BITS-1:0] PCOut,

	//Memory interface
	output wire LMemEn,
	output wire[MEMORY_HALFADDRESS_BITS-2:0] LMemAddr,
	input wire[15:0] LMemRdata,
	output wire HMemEn,
	output wire[MEMORY_HALFADDRESS_BITS-2:0] HMemAddr,
	input wire[15:0] HMemRdata,

	//Transferation to Compute Stage
	output reg[31:0] Instruction, //If we can assume sync ram, we can replace reg to wire
	output reg ValidCS,

	//Branch signal from Compute Stage
	input wire BranchRequestFromCS,
	input wire BranchPCRelModeFromCS,
	input wire[INSTRUCTION_HALFADDRESS_BITS-1:0] BranchPCFromCS
);

reg branched;
reg[INSTRUCTION_HALFADDRESS_BITS-1:0] PC; //By half-word address
wire isMemInstruction = Instruction[31] & !Instruction[30];
wire isPCRelMemInstruction = isMemInstruction & Instruction[24] & Instruction[22]; //!(sng || xan) && opb=='PC'
wire isJumpableInstruction = !Instruction[31] & Instruction[29]; //(sng || xan) && jflag
assign PCOut = PC;

//wire[31:0] PCFetching = isJumpableInstruction ? (PC[INSTRUCTION_HALFADDRESS_BITS-1:0] + 32'd1) :
//                        isPCRelMemInstruction ? (PC[0] ? {PC[INSTRUCTION_HALFADDRESS_BITS-1:1] + 31'd2, 1'b0} 
//                                                       : {PC[INSTRUCTION_HALFADDRESS_BITS-1:1] + 31'd1, 1'b0})
//                                               : PC[INSTRUCTION_HALFADDRESS_BITS-1:0];

//Instruction fetch logic
assign LMemEn = !Stall; //Don't touch Memory while pipeline is stalling
assign HMemEn = !Stall;
assign LMemAddr = { 1'b0, PC[INSTRUCTION_HALFADDRESS_BITS-1:1] + (branched ? 'd0 :
                                                                 (isPCRelMemInstruction && PC[0]) ? 'd2 :
                                      (isPCRelMemInstruction || (isJumpableInstruction && PC[0])) ? 'b1 :
                                                                                                    'b0) };
assign HMemAddr = { 1'b0, PC[INSTRUCTION_HALFADDRESS_BITS-1:1] + (branched ? {1'b0, PC[0]} :
                                                             (isPCRelMemInstruction && PC[0]) ? 'd2 :
                                    (isPCRelMemInstruction || isJumpableInstruction || PC[0]) ? 'b1 :
                                                                                                'b0) };
/*
assign LMemAddr = isPCRelMemInstruction            ? (PC[0] ? { 1'b0, PC[31:1] + 31'd2 } 
                                                            : { 1'b0, PC[31:1] + 31'd1 }) :
                  (isJumpableInstruction && PC[0]) ? { 1'b0, PC[31:1] + 31'b1 }
                                                   : { 1'b0, PC[31:1] };
assign HMemAddr = isPCRelMemInstruction           ? (PC[0] ? { 1'b0, PC[31:1] + 31'd2 } 
                                                           : { 1'b0, PC[31:1] + 31'd1 }) :
                  (isJumpableInstruction || PC[0]) ? { 1'b0, PC[31:1] + 31'b1 }
                                                   : { 1'b0, PC[31:1] };
*/
always @(posedge CLK) begin
    if (!RST_X) begin
        Instruction <= 32'b0;
    end else
                                            
	if (!Stall)	begin
		//Normal behaviour
		if (isPCRelMemInstruction) begin
			Instruction <= { HMemRdata, LMemRdata };
		end
		else begin
			Instruction <= PC[0] ^ (isJumpableInstruction & !branched) ? { LMemRdata, HMemRdata }
			                                                           : { HMemRdata, LMemRdata };
		end
	end
	else begin
		//Stall behaviour
		//Do nothing (Maybe ok)
	end
end

//Branch logic
//Branch by two ways: PCRelativeMemInstruction or BranchRequestFromCS
always @(posedge CLK) begin
    if (!RST_X) begin
        PC <= {(INSTRUCTION_HALFADDRESS_BITS-1){1'b0}};
        ValidCS <= 1'b0;
        branched <= 1'b1;
    end else
    
    if (!Stall) begin
	//Normal behaviour
	if (branched) begin
	    PC <= PC + 'd1;
	    ValidCS <= 1'b1;
	    branched <= 1'b0;
	end
	else if (isPCRelMemInstruction) begin
		PC <= PC[0] ? { PC[INSTRUCTION_HALFADDRESS_BITS-1:1] + 'd2, 1'b1 }  //Same as L/HMemAddr
		            : { PC[INSTRUCTION_HALFADDRESS_BITS-1:1] + 'd1, 1'b1 }; //Same as L/HMemAddr
		ValidCS <= 1'b1;
		branched <= 1'b0;
	end
	else if (BranchRequestFromCS) begin
		PC <= BranchPCRelModeFromCS ? { PC + BranchPCFromCS }
		                            : BranchPCFromCS;
		ValidCS <= 1'b1; //Enable delayed branch slot
		branched <= 1'b1;
	end
        else if (isJumpableInstruction) begin
            PC <= PC + 'd2;
            ValidCS <= 1'b1;
	     branched <= 1'b0;
        end
	 else begin
	     PC <= PC[0] ? { PC[INSTRUCTION_HALFADDRESS_BITS-1:1] + 'b1, 1'b0 } 
		          : { PC[INSTRUCTION_HALFADDRESS_BITS-1:1]      , 1'b1 };
	     ValidCS <= 1'b1;
	     branched <= 1'b0;
	 end
    end
end


endmodule
