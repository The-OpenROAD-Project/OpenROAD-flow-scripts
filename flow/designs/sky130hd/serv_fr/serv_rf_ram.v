module serv_rf_ram
  #(parameter width=0,
    parameter csr_regs=4,
    parameter depth=32*(32+csr_regs)/width)
   (
`ifdef USE_POWER_PINS
	inout vccd1,
	inout vssd1,
`endif	
    input wire i_clk,
    input wire [$clog2(depth)-1:0] i_waddr,
    input wire [width-1:0] 	   i_wdata,
    input wire 			   i_wen,
    input wire [$clog2(depth)-1:0] i_raddr,
    output reg [width-1:0] 	   o_rdata);
 
    wire ce_in;
    wire [1:0] w_mask_in;
    assign ce_in = 1'b1;
    assign w_mask_in = 2'b11;
  fakeram130_2x576 mem(
   `ifdef USE_POWER_PINS
	   .vccd1(vccd1),
           .vssd1(vssd1),
   `endif
   .rd_out(o_rdata),
   .addr_in(i_raddr),
   .we_in(i_wen),
   .wd_in(i_wdata),
   .w_mask_in(w_mask_in),
   .clk(i_clk),
   .ce_in(ce_in));
 

endmodule
