module main(
    input CLK,
    input RST_X,
    output[31:0] PCout
    );
    parameter MEMORY_HALFADDRESS_BITS = 14;
    parameter INSTRUCTION_HALFADDRESS_BITS = 14;

//LMemory
wire[MEMORY_HALFADDRESS_BITS-2:0] lmemory_addr;
wire[15:0] lmemory_rdata, lmemory_wdata;
wire lmemory_wen;
LowMemory
#(
   .MEMORY_HALFADDRESS_BITS(MEMORY_HALFADDRESS_BITS),
   .INSTRUCTION_HALFADDRESS_BITS(INSTRUCTION_HALFADDRESS_BITS)
) lmemory(
    .CLK(CLK),
    .ADDR(lmemory_addr),
    .WEN(lmemory_wen),
    .RDATA(lmemory_rdata),
    .WDATA(lmemory_wdata)
);
//HMemory
wire[MEMORY_HALFADDRESS_BITS-2:0] hmemory_addr;
wire[15:0] hmemory_rdata, hmemory_wdata;
wire hmemory_wen;
HighMemory
#(
   .MEMORY_HALFADDRESS_BITS(MEMORY_HALFADDRESS_BITS),
   .INSTRUCTION_HALFADDRESS_BITS(INSTRUCTION_HALFADDRESS_BITS)
) hmemory(
    .CLK(CLK),
    .ADDR(hmemory_addr),
    .WEN(hmemory_wen),
    .RDATA(hmemory_rdata),
    .WDATA(hmemory_wdata)
);

//Pipeline stages
//Fetch Stage
wire[INSTRUCTION_HALFADDRESS_BITS-1:0] PC;
wire fsStalling;
wire[MEMORY_HALFADDRESS_BITS-2:0] fsLMem_addr;
wire[15:0] fsLMem_rdata;
wire fsLMem_en;
wire[MEMORY_HALFADDRESS_BITS-2:0] fsHMem_addr;
wire[15:0] fsHMem_rdata;
wire fsHMem_en;
wire[31:0] csInstruction;
wire csValid;
wire csBranchRequest;
wire[INSTRUCTION_HALFADDRESS_BITS-1:0] csBranchPC;
wire csBranchPCRelMode;
FetchStage 
#(
   .MEMORY_HALFADDRESS_BITS(MEMORY_HALFADDRESS_BITS),
   .INSTRUCTION_HALFADDRESS_BITS(INSTRUCTION_HALFADDRESS_BITS)
) fetch(
    .CLK(CLK),
    .RST_X(RST_X),
    .Stall(fsStalling),
    .PCOut(PC),
    //Memory interface
    .LMemEn(fsLMem_en),
    .LMemAddr(fsLMem_addr),
    .LMemRdata(fsLMem_rdata),
    .HMemEn(fsHMem_en),
    .HMemAddr(fsHMem_addr),
    .HMemRdata(fsHMem_rdata),
    //Transferation to Compute Stage
    .Instruction(csInstruction),
    .ValidCS(csValid),
    //Branch signal from Compute Stage
    .BranchRequestFromCS(csBranchRequest),
    .BranchPCRelModeFromCS(csBranchPCRelMode),
    .BranchPCFromCS(csBranchPC)
);
/*
//Compute Stage
wire csStalling;
wire asMemOp, asMemRw;
wire[31:0] asAluRes, asRegRdataC;
wire[3:0] asRegNoC;
wire asValid;
wire csRegWen;
wire[31:0] csRegWdata;
wire[3:0] csRegWno;
ComputeStage 
#(
   .MEMORY_HALFADDRESS_BITS(MEMORY_HALFADDRESS_BITS),
   .INSTRUCTION_HALFADDRESS_BITS(INSTRUCTION_HALFADDRESS_BITS)
) compute(
    .CLK(CLK),
    .RST_X(RST_X),
    .PC(PC),
    .Stall(csStalling),
    .BranchRequest(csBranchRequest),
    .BranchPCRelMode(csBranchPCRelMode),
    .BranchPC(csBranchPC),
    //Input from Fetch Stage
    .Instruction(csInstruction),
    .ValidCS(csValid),
    //Transferation to Apply Stage
    .MemOp(asMemOp),
    .MemRw(asMemRw),
    .AluRes(asAluRes),
    .RegRdataC(asRegRdataC),
    .RegNoC(asRegNoC),
    .ValidAS(asValid),
    //Register write from Apply Stage
    .RegWen(csRegWen),
    .RegWdata(csRegWdata),
    .RegWno(csRegWno)
);
*/
//Compute Stage
wire csFetchStallRequest;
wire[MEMORY_HALFADDRESS_BITS-2:0] csMem_addr;
wire[31:0] csMem_rdata, csMem_wdata;
wire csMem_en, csMem_wen;
ComputeStage 
#(
   .MEMORY_HALFADDRESS_BITS(MEMORY_HALFADDRESS_BITS),
   .INSTRUCTION_HALFADDRESS_BITS(INSTRUCTION_HALFADDRESS_BITS)
) compute(
    .CLK(CLK),
    .RST_X(RST_X),
    .PC(PC),
    .BranchRequest(csBranchRequest),
    .BranchPCRelMode(csBranchPCRelMode),
    .BranchPC(csBranchPC),
    //Input from Fetch Stage
    .Instruction(csInstruction),
    .ValidCS(csValid),
    //Memory interface
    .MemEn(csMem_en),
    .MemAddr(csMem_addr),
    .MemRdata(csMem_rdata),
    .MemWen(csMem_wen),
    .MemWdata(csMem_wdata),
	.FetchStallRequest(csFetchStallRequest)
);

/*
//Apply Stage
wire asMemoryStallRequest;
wire[MEMORY_HALFADDRESS_BITS-2:0] asMem_addr;
wire[31:0] asMem_rdata, asMem_wdata;
wire asMem_en, asMem_wen;
ApplyStage 
#(
   .MEMORY_HALFADDRESS_BITS(MEMORY_HALFADDRESS_BITS),
   .INSTRUCTION_HALFADDRESS_BITS(INSTRUCTION_HALFADDRESS_BITS)
) apply(
    .CLK(CLK),
    .RST_X(RST_X),
    .MemoryStallRequest(asMemoryStallRequest),
    //From Compute Stage
    .MemOp(asMemOp),
    .MemRw(asMemRw),
    .AluRes(asAluRes),
    .RegRdataC(asRegRdataC),
    .RegNoC(asRegNoC),
    .ValidAS(asValid),
    //Memory interface
    .MemEn(asMem_en),
    .MemAddr(asMem_addr),
    .MemRdata(asMem_rdata),
    .MemWen(asMem_wen),
    .MemWdata(asMem_wdata),
    //Register write to CS
    .RegWen(csRegWen),
    .RegWdata(csRegWdata),
    .RegWno(csRegWno)
);
*/

/*
//Memory acccess control
assign lmemory_addr = csFetchStallRequest ? asMem_addr : fsLMem_addr;
assign hmemory_addr = csFetchStallRequest ? asMem_addr : fsHMem_addr;
assign lmemory_wdata = asMem_wdata[15:0];
assign hmemory_wdata = asMem_wdata[31:16];
assign lmemory_wen = csFetchStallRequest && asMem_wen;
assign hmemory_wen = csFetchStallRequest && asMem_wen;
assign asMem_rdata = { hmemory_rdata, lmemory_rdata };
assign fsLMem_rdata = lmemory_rdata;
assign fsHMem_rdata = hmemory_rdata;

//Stall controll
assign fsStalling = csFetchStallRequest;
assign csStalling = asMemoryStallRequest;
*/
//Memory acccess control
assign lmemory_addr = csFetchStallRequest ? csMem_addr : fsLMem_addr;
assign hmemory_addr = csFetchStallRequest ? csMem_addr : fsHMem_addr;
assign lmemory_wdata = csMem_wdata[15:0];
assign hmemory_wdata = csMem_wdata[31:16];
assign lmemory_wen = csFetchStallRequest && csMem_wen;
assign hmemory_wen = csFetchStallRequest && csMem_wen;
assign csMem_rdata = { hmemory_rdata, lmemory_rdata };
assign fsLMem_rdata = lmemory_rdata;
assign fsHMem_rdata = hmemory_rdata;

//Stall controll
assign fsStalling = csFetchStallRequest;

assign PCout = {{(32-INSTRUCTION_HALFADDRESS_BITS){1'b0}},PC};
    
endmodule
