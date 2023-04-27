// Dummy dual port memory using two single port memories
module fakeram_32x32_dp
(
  QA, 
  CLKA, 
  CENA, 
  AA, 
  CLKB,
  CENB, 
  AB, 
  DB, 
  STOV, 
  EMAA, 
  EMASA, 
  EMAB, 
  RET1N
);

input CLKA;
input CLKB;

input CENA;
input [4:0]  AA;
output [31:0] QA;

input CENB;
input [4:0]  AB;
input [31:0] DB;

input STOV;
input [2:0] EMAA; 
input EMASA;
input [2:0] EMAB;
input RET1N;

assign STOV = 1'b0;
assign EMASA = 1'b0;	
assign EMAA = 3'b010;	// Extra margin adjustment A: Default for 0.8V
assign EMAB = 3'b010;	// Extra margin adjustment B: Default for 0.8V
assign RET1N = 1'b1;	
wire [31:0] QB;
wire [31:0] QA1;

fakeram45_32x32 rmod_a
(
   .rd_out(QA1),
   .addr_in(AA),
   .we_in(~CENA),
   .wd_in(DB), //dummy
   .w_mask_in(DB), //dummy
   .clk(CLKA),
   .ce_in(CENA)
);

fakeram45_32x32 rmod_b
(
   .rd_out(QB), //dummy
   .addr_in(AB),
   .we_in(CENB),
   .wd_in(DB), 
   .w_mask_in(DB),
   .clk(CLKB),
   .ce_in(CENB)
);

genvar k;
generate
    for (k = 0; k < 32; k=k+1) begin
        assign QA[k] = (~CENB & QB[k]) | (CENB & QA1[k]);
    end
endgenerate

endmodule

