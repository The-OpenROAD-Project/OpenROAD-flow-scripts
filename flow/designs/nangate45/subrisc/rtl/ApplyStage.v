/*module ApplyStage
#(
   parameter MEMORY_HALFADDRESS_BITS = 10,
   parameter INSTRUCTION_HALFADDRESS_BITS = 32
)
(
	input wire CLK,
	input wire RST_X,
	output wire MemoryStallRequest,

	input wire MemOp, //Whether to access memory
	input wire MemRw, //Whether to read (0) or write (1) memory
	input wire[31:0] AluRes, //Alu result
	input wire[31:0] RegRdataC, //Readed data of Register C operand
	input wire[3:0] RegNoC, //Destination register number specified by instruction
	input wire ValidAS,
		
	//Memory interface
	output wire MemEn,
	output wire[MEMORY_HALFADDRESS_BITS-2:0] MemAddr,
	input wire[31:0] MemRdata,
	output wire MemWen,
	output wire[31:0] MemWdata,
	
	//Register write to CS
	output wire RegWen,
	output wire[31:0] RegWdata,
	output wire [3:0] RegWno
);

//Pipeline stage will stall by all memory read / write instructions
reg memReaded = 1'b0;
always @(posedge CLK) begin
	if (ValidAS && MemOp && !memReaded && RST_X)
		memReaded <= 1'b1;
	else
		memReaded <= 1'b0;
end
assign MemoryStallRequest = ValidAS && !memReaded && MemOp;

//Perfom memory access
assign MemEn = !memReaded;
assign MemAddr = { 2'b0, AluRes[31:2] }; //AluRes[1]: half address
assign MemWen = !memReaded & MemRw;
assign MemWdata = RegRdataC;

//Perfom register writing when not-memory access or memory reading
assign RegWen = ValidAS && (!MemOp || (!MemRw && !memReaded));
assign RegWdata = MemOp ? MemRdata : AluRes;
assign RegWno = RegNoC;

endmodule
*/
/*
FetchStageの改良
・今アクセスするためのアドレス計算
・次のサイクルのためのアドレス計算
2つの計算が同時に存在していて無駄．
・3オペランド加算が必要になっていてこれも無駄．

ApplyStageの動作
＜通常の命令の場合＞
(1) CSにsng命令が供給される
 瞬間的にメモリ命令ではないとわかる
  -> レジスタにはこのサイクルで書き込みが発生するとわかる
 演算が実行されレジスタに反映され次のサイクルに進む
＜メモリロード命令の場合＞
(1) CSにメモリロード命令が供給される
 供給された瞬間にメモリアクセス命令かは分かる
  -> レジスタにはこのサイクルに書き込む必要はない
     もう1サイクルかかるためストール要求を送る必要がある
	  このストール要求は命令が供給されたサイクルだけ送ればよい
      
 アドレスが計算される

 ！なぜかApplyStageの代入がブロッキング代入になっていた！

*/
