/* ****************************************************************************
  SPDX-License-Identifier: CERN-OHL-W-2.0

  Description: Instruction MMU implementation

  Copyright (C) 2013 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>

 ******************************************************************************/

`include "mor1kx-defines.v"

module mor1kx_immu
  #(
    parameter FEATURE_IMMU_HW_TLB_RELOAD = "NONE",
    parameter OPTION_OPERAND_WIDTH = 32,
    parameter OPTION_IMMU_SET_WIDTH = 6,
    parameter OPTION_IMMU_WAYS = 1
    )
   (
    input 				  clk,
    input 				  rst,

    input 				  enable_i,

    output 				  busy_o,

    input [OPTION_OPERAND_WIDTH-1:0] 	  virt_addr_i,
    input [OPTION_OPERAND_WIDTH-1:0] 	  virt_addr_match_i,
    output reg [OPTION_OPERAND_WIDTH-1:0] phys_addr_o,
    output reg                            cache_inhibit_o,

    input 				  supervisor_mode_i,

    output reg                            tlb_miss_o,
    output                                pagefault_o,

    output reg 				  tlb_reload_req_o,
    input 				  tlb_reload_ack_i,
    output reg [OPTION_OPERAND_WIDTH-1:0] tlb_reload_addr_o,
    input [OPTION_OPERAND_WIDTH-1:0] 	  tlb_reload_data_i,
    output 				  tlb_reload_pagefault_o,
    input 				  tlb_reload_pagefault_clear_i,
    output 				  tlb_reload_busy_o,

    // SPR interface
    input [15:0] 			  spr_bus_addr_i,
    input 				  spr_bus_we_i,
    input 				  spr_bus_stb_i,
    input [OPTION_OPERAND_WIDTH-1:0] 	  spr_bus_dat_i,

    output [OPTION_OPERAND_WIDTH-1:0] 	  spr_bus_dat_o,
    output 				  spr_bus_ack_o
    );

   localparam WAYS_WIDTH = (OPTION_IMMU_WAYS < 2) ? 1 : 2;

   wire [OPTION_OPERAND_WIDTH-1:0]    itlb_match_dout[OPTION_IMMU_WAYS-1:0];
   wire [OPTION_IMMU_SET_WIDTH-1:0]   itlb_match_addr;
   reg [OPTION_IMMU_WAYS-1:0]         itlb_match_we;
   wire [OPTION_OPERAND_WIDTH-1:0]    itlb_match_din;

   wire [OPTION_OPERAND_WIDTH-1:0]    itlb_match_huge_dout[OPTION_IMMU_WAYS-1:0];
   wire [OPTION_IMMU_SET_WIDTH-1:0]   itlb_match_huge_addr;
   wire				      itlb_match_huge_we;

   wire [OPTION_OPERAND_WIDTH-1:0]    itlb_trans_dout[OPTION_IMMU_WAYS-1:0];
   wire [OPTION_IMMU_SET_WIDTH-1:0]   itlb_trans_addr;
   reg [OPTION_IMMU_WAYS-1:0]         itlb_trans_we;
   wire [OPTION_OPERAND_WIDTH-1:0]    itlb_trans_din;

   wire [OPTION_OPERAND_WIDTH-1:0]    itlb_trans_huge_dout[OPTION_IMMU_WAYS-1:0];
   wire [OPTION_IMMU_SET_WIDTH-1:0]   itlb_trans_huge_addr;
   wire				      itlb_trans_huge_we;

   reg 				      itlb_match_reload_we;
   reg [OPTION_OPERAND_WIDTH-1:0]     itlb_match_reload_din;

   reg 				      itlb_trans_reload_we;
   reg [OPTION_OPERAND_WIDTH-1:0]     itlb_trans_reload_din;

   wire 			      itlb_match_spr_cs;
   reg 				      itlb_match_spr_cs_r;
   wire 			      itlb_trans_spr_cs;
   reg 				      itlb_trans_spr_cs_r;

   wire				      itlb_match_spr_tx;
   reg				      itlb_match_spr_tx_r;
   wire				      itlb_match_spr_tx_busy;
   wire				      itlb_trans_spr_tx;
   reg				      itlb_trans_spr_tx_r;
   wire				      itlb_trans_spr_tx_busy;

   wire 			      immucr_spr_cs;
   reg 				      immucr_spr_cs_r;
   reg [OPTION_OPERAND_WIDTH-1:0]     immucr;

   wire [1:0] 			      spr_way_idx_full;
   wire [WAYS_WIDTH-1:0] 	      spr_way_idx;
   reg [WAYS_WIDTH-1:0] 	      spr_way_idx_r;

   wire [OPTION_IMMU_WAYS-1:0]        way_huge;

   wire [OPTION_IMMU_WAYS-1:0]        way_hit;
   wire [OPTION_IMMU_WAYS-1:0]        way_huge_hit;

   reg 				      tlb_reload_pagefault;
   reg 				      tlb_reload_huge;

   // sxe: supervisor execute enable
   // uxe: user exexute enable
   reg                                sxe;
   reg                                uxe;

   reg 				      spr_bus_ack;
   reg 				      spr_bus_ack_r;
   wire [OPTION_OPERAND_WIDTH-1:0]    spr_bus_dat;
   reg [OPTION_OPERAND_WIDTH-1:0]     spr_bus_dat_r;

   genvar                             i;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       spr_bus_ack <= 0;
     else if (spr_bus_stb_i & spr_bus_addr_i[15:11] == 5'd2)
       spr_bus_ack <= 1;
     else
       spr_bus_ack <= 0;

   always @(posedge clk)
     spr_bus_ack_r <= spr_bus_ack;

   always @(posedge clk)
     if (spr_bus_ack & !spr_bus_ack_r)
       spr_bus_dat_r <= spr_bus_dat;

   assign spr_bus_ack_o = spr_bus_ack & spr_bus_stb_i &
			  spr_bus_addr_i[15:11] == 5'd2;

generate
for (i = 0; i < OPTION_IMMU_WAYS; i=i+1) begin : ways
   assign way_huge[i] = &itlb_match_huge_dout[i][1:0]; // huge & valid

   assign way_hit[i] = (itlb_match_dout[i][31:13] == virt_addr_match_i[31:13]) &
                       itlb_match_dout[i][0];  // valid bit

   assign way_huge_hit[i] = (itlb_match_huge_dout[i][31:24] ==
                             virt_addr_match_i[31:24]) &
                            itlb_match_huge_dout[i][0];
end
endgenerate

   integer j;
   always @(*) begin
      tlb_miss_o = !tlb_reload_pagefault & !busy_o;
      phys_addr_o = {OPTION_OPERAND_WIDTH{1'b0}};
      phys_addr_o[23:0] = virt_addr_match_i[23:0];
      sxe = 0;
      uxe = 0;
      cache_inhibit_o = 0;

      for (j = 0; j < OPTION_IMMU_WAYS; j=j+1) begin
         if (way_huge[j] & way_huge_hit[j] | !way_huge[j] & way_hit[j])
            tlb_miss_o = 0;

         if (way_huge[j] & way_huge_hit[j]) begin
            phys_addr_o = {itlb_trans_huge_dout[j][31:24], virt_addr_match_i[23:0]};
            sxe = itlb_trans_huge_dout[j][6];
            uxe = itlb_trans_huge_dout[j][7];
            cache_inhibit_o = itlb_trans_huge_dout[j][1];
         end else if (!way_huge[j] & way_hit[j])begin
            phys_addr_o = {itlb_trans_dout[j][31:13], virt_addr_match_i[12:0]};
            sxe = itlb_trans_dout[j][6];
            uxe = itlb_trans_dout[j][7];
            cache_inhibit_o = itlb_trans_dout[j][1];
         end

         itlb_match_we[j] = 0;
         if (itlb_match_reload_we & !tlb_reload_huge)
           itlb_match_we[j] = 1;
         if (j[WAYS_WIDTH-1:0] == spr_way_idx)
           itlb_match_we[j] = itlb_match_spr_tx & spr_bus_we_i;

         itlb_trans_we[j] = 0;
         if (itlb_trans_reload_we & !tlb_reload_huge)
           itlb_trans_we[j] = 1;
         if (j[WAYS_WIDTH-1:0] == spr_way_idx)
           itlb_trans_we[j] = itlb_trans_spr_tx & spr_bus_we_i;
      end
   end

   assign pagefault_o = (supervisor_mode_i ? !sxe : !uxe) &
			!tlb_reload_busy_o & !busy_o;

   // itlb_*_spr_tx - signals to indicate the start of a read/write
   //                 transaction
   // itlb_*_spr_cs_r is registered 1 clock cycle delay of itlb_*_spr_cs
   assign itlb_match_spr_tx = itlb_match_spr_cs & !itlb_match_spr_cs_r;
   assign itlb_trans_spr_tx = itlb_trans_spr_cs & !itlb_trans_spr_cs_r;

   // When we have SPR writes they cause the immu to output bad data for
   // 2 clock cycles.  For 2 clocks we signal busy so fetch does not proceed.
   always @(posedge clk) begin
     itlb_match_spr_tx_r <= itlb_match_spr_tx;
     itlb_trans_spr_tx_r <= itlb_trans_spr_tx;
   end
   assign itlb_match_spr_tx_busy = itlb_match_spr_tx | itlb_match_spr_tx_r;
   assign itlb_trans_spr_tx_busy = itlb_trans_spr_tx | itlb_trans_spr_tx_r;

   assign busy_o = enable_i & (itlb_match_spr_tx_busy | itlb_trans_spr_tx_busy);

   assign spr_way_idx_full = {spr_bus_addr_i[10], spr_bus_addr_i[8]};
   assign spr_way_idx = spr_way_idx_full[WAYS_WIDTH-1:0];

   always @(posedge clk `OR_ASYNC_RST)
     if (rst) begin
	itlb_match_spr_cs_r <= 0;
	itlb_trans_spr_cs_r <= 0;
	immucr_spr_cs_r <= 0;
        spr_way_idx_r <= 0;
     end else begin
	itlb_match_spr_cs_r <= itlb_match_spr_cs;
	itlb_trans_spr_cs_r <= itlb_trans_spr_cs;
	immucr_spr_cs_r <= immucr_spr_cs;
        spr_way_idx_r <= spr_way_idx;
     end

generate /* verilator lint_off WIDTH */
if (FEATURE_IMMU_HW_TLB_RELOAD == "ENABLED") begin
/* verilator lint_on WIDTH */
   assign immucr_spr_cs = spr_bus_stb_i &
			  spr_bus_addr_i == `OR1K_SPR_IMMUCR_ADDR;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       immucr <= 0;
     else if (immucr_spr_cs & spr_bus_we_i)
       immucr <= spr_bus_dat_i;

end else begin
   assign immucr_spr_cs = 0;
   always @(posedge clk)
     immucr <= 0;
end
endgenerate

   assign itlb_match_spr_cs = spr_bus_stb_i & (spr_bus_addr_i[15:11] == 5'd2) &
                              |spr_bus_addr_i[10:9] & !spr_bus_addr_i[7];
   assign itlb_trans_spr_cs = spr_bus_stb_i & (spr_bus_addr_i[15:11] == 5'd2) &
                              |spr_bus_addr_i[10:9] & spr_bus_addr_i[7];

   assign itlb_match_addr = itlb_match_spr_tx ?
			    spr_bus_addr_i[OPTION_IMMU_SET_WIDTH-1:0] :
			    virt_addr_i[13+(OPTION_IMMU_SET_WIDTH-1):13];
   assign itlb_trans_addr = itlb_trans_spr_tx ?
			    spr_bus_addr_i[OPTION_IMMU_SET_WIDTH-1:0] :
			    virt_addr_i[13+(OPTION_IMMU_SET_WIDTH-1):13];

   assign itlb_match_din = itlb_match_spr_tx & spr_bus_we_i ?
			   spr_bus_dat_i : itlb_match_reload_din;
   assign itlb_trans_din = itlb_trans_spr_tx & spr_bus_we_i ?
			   spr_bus_dat_i : itlb_trans_reload_din;

   assign itlb_match_huge_addr = virt_addr_i[24+(OPTION_IMMU_SET_WIDTH-1):24];
   assign itlb_trans_huge_addr = virt_addr_i[24+(OPTION_IMMU_SET_WIDTH-1):24];

   assign itlb_match_huge_we = itlb_match_reload_we & tlb_reload_huge;
   assign itlb_trans_huge_we = itlb_trans_reload_we & tlb_reload_huge;

   assign spr_bus_dat = itlb_match_spr_cs_r ? itlb_match_dout[spr_way_idx_r] :
			itlb_trans_spr_cs_r ? itlb_trans_dout[spr_way_idx_r] :
			immucr_spr_cs_r ? immucr : 0;

   // Use registered value on all but the first cycle spr_bus_ack is asserted
   assign spr_bus_dat_o = spr_bus_ack & !spr_bus_ack_r ? spr_bus_dat :
			  spr_bus_dat_r;

   localparam TLB_IDLE		 	= 2'd0;
   localparam TLB_GET_PTE_POINTER	= 2'd1;
   localparam TLB_GET_PTE		= 2'd2;
   localparam TLB_READ			= 2'd3;

generate /* verilator lint_off WIDTH */
if (FEATURE_IMMU_HW_TLB_RELOAD == "ENABLED") begin
   /* verilator lint_on WIDTH */

   // Hardware TLB reload
   // Compliant with the suggestions outlined in this thread:
   // http://lists.openrisc.net/pipermail/openrisc/2013-July/001806.html
   //
   // PTE layout:
   // | 31 ... 13 | 12 |  11 |   10  | 9 | 8 | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
   // |    PPN    | Reserved |PRESENT| L | X | W | U | D | A |WOM|WBC|CI |CC |
   //
   // Where X/W/U maps into SXE/UXE like this:
   // X | W | U   SXE | UXE
   // ---------   ---------
   // 0 | x | 0 =  0  |  0
   // 0 | x | 1 =  0  |  0
   //    ...
   // 1 | x | 0 =  1  |  0
   // 1 | x | 1 =  1  |  1



   reg [1:0] tlb_reload_state = TLB_IDLE;
   wire      do_reload;

   assign do_reload = enable_i & tlb_miss_o & (immucr[31:10] != 0);
   assign tlb_reload_busy_o = (tlb_reload_state != TLB_IDLE) | do_reload;
   assign tlb_reload_pagefault_o = tlb_reload_pagefault &
				    !tlb_reload_pagefault_clear_i;

   always @(posedge clk `OR_ASYNC_RST) begin
      if (rst)
        tlb_reload_pagefault <= 0;
      else if(tlb_reload_pagefault_clear_i)
        tlb_reload_pagefault <= 0;
      itlb_trans_reload_we <= 0;
      itlb_trans_reload_din <= 0;
      itlb_match_reload_we <= 0;
      itlb_match_reload_din <= 0;

      case (tlb_reload_state)
	TLB_IDLE: begin
	   tlb_reload_huge <= 0;
	   tlb_reload_req_o <= 0;
	   if (do_reload) begin
	      tlb_reload_req_o <= 1;
	      tlb_reload_addr_o <= {immucr[31:10],
				    virt_addr_match_i[31:24], 2'b00};
	      tlb_reload_state <= TLB_GET_PTE_POINTER;
	   end
	end

	//
	// Here we get the pointer to the PTE table, next is to fetch
	// the actual pte from the offset in the table.
	// The offset is calculated by:
	// ((virt_addr_match >> PAGE_BITS) & (PTE_CNT-1)) << 2
	// Where PAGE_BITS is 13 (8 kb page) and PTE_CNT is 2048
	// (number of PTEs in the PTE table)
	//
	TLB_GET_PTE_POINTER: begin
	   tlb_reload_huge <= 0;
	   if (tlb_reload_ack_i) begin
	      if (tlb_reload_data_i[31:13] == 0) begin
		 tlb_reload_pagefault <= 1;
		 tlb_reload_req_o <= 0;
		 tlb_reload_state <= TLB_IDLE;
	      end else if (tlb_reload_data_i[9]) begin
		 tlb_reload_huge <= 1;
		 tlb_reload_req_o <= 0;
		 tlb_reload_state <= TLB_GET_PTE;
	      end else begin
		 tlb_reload_addr_o <= {tlb_reload_data_i[31:13],
				       virt_addr_match_i[23:13], 2'b00};
		 tlb_reload_state <= TLB_GET_PTE;
	      end
	   end
	end

	//
	// Here we get the actual PTE, left to do is to translate the
	// PTE data into our translate and match registers.
	//
	TLB_GET_PTE: begin
	   if (tlb_reload_ack_i) begin
	      tlb_reload_req_o <= 0;
	      // Check PRESENT bit
	      if (!tlb_reload_data_i[10]) begin
		 tlb_reload_pagefault <= 1;
		 tlb_reload_state <= TLB_IDLE;
	      end else begin
		 // Translate register generation.
		 // PPN
		 itlb_trans_reload_din[31:13] <= tlb_reload_data_i[31:13];
		 // UXE = X & U
		 itlb_trans_reload_din[7] <= tlb_reload_data_i[8] &
					      tlb_reload_data_i[6];
		 // SXE = X
		 itlb_trans_reload_din[6] <= tlb_reload_data_i[8];
		 // Dirty, Accessed, Weakly-Ordered-Memory, Writeback cache,
		 // Cache inhibit, Cache coherent
		 itlb_trans_reload_din[5:0] <= tlb_reload_data_i[5:0];
		 itlb_trans_reload_we <= 1;

		 // Match register generation.
		 // VPN
		 itlb_match_reload_din[31:13] <= virt_addr_match_i[31:13];
		 // PL1
		 itlb_match_reload_din[1] <= tlb_reload_huge;
		 // Valid
		 itlb_match_reload_din[0] <= 1;
		 itlb_match_reload_we <= 1;

		 tlb_reload_state <= TLB_READ;
	      end
	   end
	end

	// Let the just written values propagate out on the read ports
	TLB_READ: begin
	   tlb_reload_state <= TLB_IDLE;
	end

	default:
	  tlb_reload_state <= TLB_IDLE;

      endcase
   end
end else begin // if (FEATURE_IMMU_HW_TLB_RELOAD == "ENABLED")
   assign tlb_reload_pagefault_o = 0;
   assign tlb_reload_busy_o = 0;
   always @(posedge clk) begin
      tlb_reload_req_o <= 0;
      tlb_reload_addr_o <= 0;
      tlb_reload_huge <= 1'b0;
      tlb_reload_pagefault <= 0;
      itlb_trans_reload_we <= 0;
      itlb_trans_reload_din <= 0;
      itlb_match_reload_we <= 0;
      itlb_match_reload_din <= 0;
   end
end
endgenerate

generate
for (i = 0; i < OPTION_IMMU_WAYS; i=i+1) begin : itlb
   // ITLB match registers
   mor1kx_true_dpram_sclk
     #(
       .ADDR_WIDTH(OPTION_IMMU_SET_WIDTH),
       .DATA_WIDTH(OPTION_OPERAND_WIDTH)
       )
   itlb_match_regs
      (
       // Outputs
       .dout_a (itlb_match_dout[i]),
       .dout_b (itlb_match_huge_dout[i]),
       // Inputs
       .clk_a  (clk),
       .addr_a (itlb_match_addr),
       .we_a   (itlb_match_we[i]),
       .din_a  (itlb_match_din),
       .clk_b  (clk),
       .addr_b (itlb_match_huge_addr),
       .we_b   (itlb_match_huge_we),
       .din_b  (itlb_match_reload_din)
       );


   // ITLB translate registers
   mor1kx_true_dpram_sclk
     #(
       .ADDR_WIDTH(OPTION_IMMU_SET_WIDTH),
       .DATA_WIDTH(OPTION_OPERAND_WIDTH)
       )
   itlb_translate_regs
     (
      // Outputs
      .dout_a (itlb_trans_dout[i]),
      .dout_b (itlb_trans_huge_dout[i]),
      // Inputs
      .clk_a  (clk),
      .addr_a (itlb_trans_addr),
      .we_a   (itlb_trans_we[i]),
      .din_a  (itlb_trans_din),
      .clk_b  (clk),
      .addr_b (itlb_trans_huge_addr),
      .we_b   (itlb_trans_huge_we),
      .din_b  (itlb_trans_reload_din)
      );
end
endgenerate

/*-----------------Formal Checking------------------*/

`ifdef FORMAL

   reg f_past_valid;

   initial f_past_valid = 1'b0;
   initial assume (rst);

   always @(posedge clk)
      f_past_valid <= 1'b1;

   always @(*)
      if (!f_past_valid)
         assume (rst);

//---------------IMMU PROPERTIES----------------

   (* anyconst *) wire [OPTION_OPERAND_WIDTH-1:0] f_vaddr;

   //Physical Address of f_vaddr virtual address is asserted to verify expected PPN.
   //Case 1: Page bits = 13 bits
   always @(posedge clk) begin
      if ((virt_addr_match_i == f_vaddr) && way_hit[0]
          && !way_huge[0] && !pagefault_o && f_past_valid)
         assert ((phys_addr_o[12:0] == f_vaddr[12:0]) &&
                 phys_addr_o[31:13] == itlb_trans_dout[0][31:13]);
   end

   //Case 2: Page bits = 24 bits (huge)
   always @(posedge clk) begin
      if ((virt_addr_match_i == f_vaddr) && way_huge_hit[0] &&
          way_huge[0] && !pagefault_o && f_past_valid)
         assert ((phys_addr_o[23:0] == f_vaddr[23:0]) &&
                  phys_addr_o[31:24] == itlb_trans_huge_dout[0][31:24]);
   end

   //On TLB miss, cache should not be inhibited.
   always @(*)
      if (tlb_miss_o)
      assert (!cache_inhibit_o);

   //Way hits are one hot encoded.
   always @(*) begin
      assert ($onehot0(way_hit));
      assert ($onehot0(way_huge_hit));
   end

   //On TLB hit, tlb_miss_o should be 0.
   always @(*)
      if (way_huge[0] & way_huge_hit[0] || !way_huge[0] & way_hit[0])
         assert (!tlb_miss_o);

   //IMMU SPR registers are accessible if the last 5 bits
   // of spr_bus_addr_i corresponds to group 2.
   always @(*)
      if ($onehot(itlb_match_spr_cs) || $onehot(itlb_trans_spr_cs))
         assert (spr_bus_addr_i[15:11] == 5'd2);

   always @(posedge clk)
      if (f_past_valid && spr_bus_ack_o && |spr_bus_addr_i[10:9])
         assert (itlb_match_spr_cs != itlb_trans_spr_cs);

   //Spr can't access both Match TLB and Translation TLB at the same time.
   always @(posedge clk)
      if (itlb_match_spr_cs)
         assert (!itlb_trans_spr_cs);

   //On spr read request, spr write signals shouldn't be generated,
   always @(*)
      if (spr_bus_stb_i && !spr_bus_we_i && spr_bus_addr_i[15:11] == 5'd2)
         assert (!itlb_trans_we & !itlb_match_we);

   //SPR transmit signals are set high at the posedge of spr chip select signalS
   always @(posedge clk)
      if (($rose(itlb_trans_spr_cs) | $rose(itlb_match_spr_cs)) && f_past_valid)
         assert (itlb_trans_spr_tx | itlb_match_spr_tx);

   //When translation transmit pulse rises, match transmit pulse shouldn't rise
   always @(posedge clk)
      if (f_past_valid && $rose(itlb_trans_spr_tx))
         assert (!itlb_match_spr_tx);

   reg f_busy_valid;
   //Busy should be set high for every spr read/write transactions
   always @(posedge clk)
      if (f_past_valid && spr_bus_stb_i && ($rose(itlb_match_spr_cs)
          | $rose(itlb_trans_spr_cs)) && !$past(rst) && enable_i) begin
         assert (busy_o);
         f_busy_valid <= 1;
      end

   //SPR read/write should keep busy high for two clocks
   always @(posedge clk)
      if (f_past_valid && $rose(f_busy_valid) && !$past(rst) & enable_i)
         assert (busy_o);

   fspr_slave #(
       .OPTION_OPERAND_WIDTH(OPTION_OPERAND_WIDTH),
       .SLAVE("IMMU")
       )
       u_f_immu_slave (
        .clk(clk),
        .rst(rst),
         // SPR interface
        .spr_bus_addr_i(spr_bus_addr_i),
        .spr_bus_we_i(spr_bus_we_i),
        .spr_bus_stb_i(spr_bus_stb_i),
        .spr_bus_dat_i(spr_bus_dat_i),
        .spr_bus_dat_o(spr_bus_dat_o),
        .spr_bus_ack_o(spr_bus_ack_o),
        .f_past_valid(f_past_valid)
       );


//--------------Cover-----------------

`ifdef IMMU

   always @(posedge clk)
      if (f_past_valid && !$past(rst)) begin
         //TLB HIT-------------Trace 0
         cover (!tlb_miss_o && phys_addr_o != 0);
         //Match write---------Trace 2
         cover (itlb_match_spr_cs && $past(itlb_match_we)
                && $rose(spr_bus_ack_o));
         //Trans write---------Trace 1
         cover (itlb_trans_spr_cs && $past(itlb_trans_we)
                && $rose(spr_bus_ack_o));
         //SPR Write-----------Trace 4
         cover ($rose(f_busy_valid) && busy_o && $past(spr_bus_we_i) && spr_bus_we_i);
         //SPR READ------------Trace 3
         cover ($rose(f_busy_valid) && busy_o && $past(spr_bus_we_i) && !spr_bus_we_i);
      end

`endif

`endif

endmodule
