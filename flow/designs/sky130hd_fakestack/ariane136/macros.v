module SyncSpRamBeNx64_00000008_00000100_0_2
  (
   Clk_CI,
   Rst_RBI,
   CSel_SI,
   WrEn_SI,
   BEn_SI,
   WrData_DI,
   Addr_DI,
   RdData_DO
   );

   input [7:0]   BEn_SI; // byte-enable: ignore or use as needed
   input [63:0]  WrData_DI;
   input [7:0] 	 Addr_DI;
   output [63:0] RdData_DO;
   input 	 Clk_CI;
   input 	 Rst_RBI; // reset: ignore or use as needed
   input 	 CSel_SI;
   input 	 WrEn_SI;
   wire [63:0] 	 RdData_DO;
   wire 	 csel_b,wren_b;
   wire [15:0] WMaskIn, NotWMaskIn;

   assign NotWMaskIn = 16'b0;
   assign WMaskIn = ~NotWMaskIn;
   assign wren_b = ~WrEn_SI; // active-low global-write-enable
   assign csel_b = ~CSel_SI; // active-low chip-select-enable

   fakeram130_256x16 macro_mem_0 (.clk(Clk_CI),.rd_out(RdData_DO[15:0]), .ce_in(csel_b),.we_in(wren_b),.addr_in(Addr_DI),.w_mask_in(WMaskIn),.wd_in(WrData_DI[15:0]));
   fakeram130_256x16 macro_mem_1 (.clk(Clk_CI),.rd_out(RdData_DO[31:16]),.ce_in(csel_b),.we_in(wren_b),.addr_in(Addr_DI),.w_mask_in(WMaskIn),.wd_in(WrData_DI[31:16]));
   fakeram130_256x16 macro_mem_2 (.clk(Clk_CI),.rd_out(RdData_DO[47:32]),.ce_in(csel_b),.we_in(wren_b),.addr_in(Addr_DI),.w_mask_in(WMaskIn),.wd_in(WrData_DI[47:32]));
   fakeram130_256x16 macro_mem_3 (.clk(Clk_CI),.rd_out(RdData_DO[63:48]),.ce_in(csel_b),.we_in(wren_b),.addr_in(Addr_DI),.w_mask_in(WMaskIn),.wd_in(WrData_DI[63:48]));

endmodule // SyncSpRamBeNx64_00000008_00000100_0_2

// Google made a mistake in their ariane experiment.
// The valid_dirty_sram should be 4 macros, each 256x16. Instead, they only instantiated 1 256x16 macro
module limping_SyncSpRamBeNx64_00000008_00000100_0_2
  (
   Clk_CI,
   Rst_RBI,
   CSel_SI,
   WrEn_SI,
   BEn_SI,
   WrData_DI,
   Addr_DI,
   RdData_DO
   );

   input [7:0]   BEn_SI; // byte-enable: ignore or use as needed
   input [63:0]  WrData_DI;
   input [7:0] 	 Addr_DI;
   output [63:0] RdData_DO;
   input 	 Clk_CI;
   input 	 Rst_RBI; // reset: ignore or use as needed
   input 	 CSel_SI;
   input 	 WrEn_SI;
   wire [63:0] 	 RdData_DO;
   wire 	 csel_b,wren_b;
   wire [15:0] WMaskIn, NotWMaskIn;

   assign NotWMaskIn = 16'b0;
   assign WMaskIn = ~NotWMaskIn;
   assign wren_b = ~WrEn_SI; // active-low global-write-enable
   assign csel_b = ~CSel_SI; // active-low chip-select-enable

   fakeram130_256x16 macro_mem_0 (.clk(Clk_CI),.rd_out(RdData_DO[15:0]), .ce_in(csel_b),.we_in(wren_b),.addr_in(Addr_DI),.w_mask_in(WMaskIn),.wd_in(WrData_DI[15:0]));
   fakeram130_256x16 macro_mem_1 (.clk(Clk_CI),.rd_out(RdData_DO[31:16]),.ce_in(csel_b),.we_in(wren_b),.addr_in(Addr_DI),.w_mask_in(WMaskIn),.wd_in(WrData_DI[31:16]));
   fakeram130_256x16 macro_mem_2 (.clk(Clk_CI),.rd_out(RdData_DO[47:32]),.ce_in(csel_b),.we_in(wren_b),.addr_in(Addr_DI),.w_mask_in(WMaskIn),.wd_in(WrData_DI[47:32]));
   fakeram130_256x16 macro_mem_3 (.clk(Clk_CI),.rd_out(RdData_DO[63:48]),.ce_in(csel_b),.we_in(wren_b),.addr_in(Addr_DI),.w_mask_in(WMaskIn),.wd_in(WrData_DI[63:48]));

endmodule // limping_SyncSpRamBeNx64_00000008_00000100_0_2

module SyncSpRamBeNx64_00000008_00000100_0_2_d45
  (
   Clk_CI,
   Rst_RBI,
   CSel_SI,
   WrEn_SI,
   BEn_SI,
   WrData_DI,
   Addr_DI,
   RdData_DO
   );

   input [7:0]   BEn_SI; // byte-enable: ignore or use as needed
   input [44:0]  WrData_DI;
   input [7:0] 	 Addr_DI;
   output [44:0] RdData_DO;
   input 	 Clk_CI;
   input 	 Rst_RBI; // reset: ignore or use as needed
   input 	 CSel_SI;
   input 	 WrEn_SI;
   wire [47:0] 	 RdData_DO_wire;
   wire 	 csel_b,wren_b;
   wire [15:0] WMaskIn, NotWMaskIn;

   assign NotWMaskIn = 16'b0;
   assign WMaskIn = ~NotWMaskIn;
   assign wren_b = ~WrEn_SI; // active-low global-write-enable
   assign csel_b = ~CSel_SI; // active-low chip-select-enable
   assign RdData_DO = RdData_DO_wire[44:0];

   fakeram130_256x16 macro_mem_0 (.clk(Clk_CI),.rd_out(RdData_DO_wire[15:0]), .ce_in(csel_b),.we_in(wren_b),.addr_in(Addr_DI),.w_mask_in(WMaskIn),.wd_in(WrData_DI[15:0]));
   fakeram130_256x16 macro_mem_1 (.clk(Clk_CI),.rd_out(RdData_DO_wire[31:16]),.ce_in(csel_b),.we_in(wren_b),.addr_in(Addr_DI),.w_mask_in(WMaskIn),.wd_in(WrData_DI[31:16]));
   fakeram130_256x16 macro_mem_2 (.clk(Clk_CI),.rd_out(RdData_DO_wire[47:32]),.ce_in(csel_b),.we_in(wren_b),.addr_in(Addr_DI),.w_mask_in(WMaskIn),.wd_in({3'b000, WrData_DI[44:32]}));

endmodule // SyncSpRamBeNx64_00000008_00000100_0_2_d45

module SyncSpRamBeNx64_00000008_00000100_0_2_d44
  (
   Clk_CI,
   Rst_RBI,
   CSel_SI,
   WrEn_SI,
   BEn_SI,
   WrData_DI,
   Addr_DI,
   RdData_DO
   );

   input [7:0]   BEn_SI; // byte-enable: ignore or use as needed
   input [43:0]  WrData_DI;
   input [7:0] 	 Addr_DI;
   output [43:0] RdData_DO;
   input 	 Clk_CI;
   input 	 Rst_RBI; // reset: ignore or use as needed
   input 	 CSel_SI;
   input 	 WrEn_SI;
   wire [47:0] 	 RdData_DO_wire;
   wire 	 csel_b,wren_b;
   wire [15:0] WMaskIn, NotWMaskIn;

   assign NotWMaskIn = 16'b0;
   assign WMaskIn = ~NotWMaskIn;
   assign wren_b = ~WrEn_SI; // active-low global-write-enable
   assign csel_b = ~CSel_SI; // active-low chip-select-enable
   assign RdData_DO = RdData_DO_wire[43:0];

   fakeram130_256x16 macro_mem_0 (.clk(Clk_CI),.rd_out(RdData_DO_wire[15:0]), .ce_in(csel_b),.we_in(wren_b),.addr_in(Addr_DI),.w_mask_in(WMaskIn),.wd_in(WrData_DI[15:0]));
   fakeram130_256x16 macro_mem_1 (.clk(Clk_CI),.rd_out(RdData_DO_wire[31:16]),.ce_in(csel_b),.we_in(wren_b),.addr_in(Addr_DI),.w_mask_in(WMaskIn),.wd_in(WrData_DI[31:16]));
   fakeram130_256x16 macro_mem_2 (.clk(Clk_CI),.rd_out(RdData_DO_wire[47:32]),.ce_in(csel_b),.we_in(wren_b),.addr_in(Addr_DI),.w_mask_in(WMaskIn),.wd_in({4'b0000, WrData_DI[43:32]}));

endmodule // SyncSpRamBeNx64_00000008_00000100_0_2_d44

