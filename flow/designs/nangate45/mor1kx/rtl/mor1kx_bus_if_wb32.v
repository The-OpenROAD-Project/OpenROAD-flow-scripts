/* ****************************************************************************
  SPDX-License-Identifier: CERN-OHL-W-2.0

  Description: mor1kx processor Wishbone bus bridge

  For now, very simple, not registering,  assumes 32-bit data, addressing

  Copyright (C) 2012 Authors

  Author(s): Julius Baxter <juliusbaxter@gmail.com>

***************************************************************************** */

`include "mor1kx-defines.v"

module mor1kx_bus_if_wb32
  #(
    parameter BUS_IF_TYPE = "CLASSIC",
    parameter BURST_LENGTH = 8
    )
   (
    input         clk,
    input         rst,

    output        cpu_err_o,
    output        cpu_ack_o,
    output [31:0] cpu_dat_o,
    input [31:0]  cpu_adr_i,
    input [31:0]  cpu_dat_i,
    input         cpu_req_i,
    input [3:0]   cpu_bsel_i,
    input         cpu_we_i,
    input         cpu_burst_i,

    output [31:0] wbm_adr_o,
    output        wbm_stb_o,
    output        wbm_cyc_o,
    output [3:0]  wbm_sel_o,
    output        wbm_we_o,
    output [2:0]  wbm_cti_o,
    output [1:0]  wbm_bte_o,
    output [31:0] wbm_dat_o,
    input         wbm_err_i,
    input         wbm_ack_i,
    input [31:0]  wbm_dat_i,
    input         wbm_rty_i
    );

   localparam  BADDR_WITH = (BURST_LENGTH==4) ? 2 :
                            (BURST_LENGTH==8) ? 3 :
                            (BURST_LENGTH==16)? 4 : 30;

   generate
      /* verilator lint_off WIDTH */
      if (BUS_IF_TYPE=="B3_READ_BURSTING") begin : b3_read_bursting
	 /* verilator lint_on WIDTH */

	 // Burst until the incoming address is not what it should be
	 wire 			      finish_burst;
	 reg 			      finish_burst_r;
	 reg 			      bursting;
	 reg [31:2] 		      burst_address;
	 reg [BADDR_WITH-1:0]	      burst_wrap_start;
	 wire [BADDR_WITH-1:0]	      burst_wrap_finish;
	 wire 			      address_differs;

	 always @(posedge clk `OR_ASYNC_RST)
	   if (rst)
	     bursting <= 0;
	   else if (wbm_err_i)
	     bursting <= 0;
	   else if (bursting & finish_burst & wbm_ack_i)
	     bursting <= 0;
	   else if (cpu_req_i & !bursting & !cpu_we_i)
	     bursting <= 1;

	 always @(posedge clk `OR_ASYNC_RST)
	   if (rst)
	     begin
		burst_address <= 0;
		burst_wrap_start <= 0;
	     end
	   else if (cpu_req_i & !bursting)
	     begin
		burst_address <= cpu_adr_i[31:2];
		burst_wrap_start <= cpu_adr_i[BADDR_WITH+2-1:2];
	     end
	   else if (wbm_ack_i)
	     burst_address[BADDR_WITH+2-1:2] <= burst_address[BADDR_WITH+2-1:2]
		  + 1;


	 assign address_differs = (burst_address!=cpu_adr_i[31:2]);
	 assign burst_wrap_finish = burst_wrap_start - 1;
	 assign finish_burst = (bursting & (
		      (BURST_LENGTH!=0 &&
		       burst_address[BADDR_WITH+2-1:2]==(burst_wrap_finish))
					    | address_differs
					    | !cpu_req_i
					    )
				)
	   ;
	 always @(posedge clk `OR_ASYNC_RST)
	   if (rst)
	     finish_burst_r <= 0;
	   else if (wbm_ack_i)
	     finish_burst_r <= finish_burst;
	   else
	     finish_burst_r <= 0;

	 assign wbm_adr_o = bursting ? {burst_address,2'b00} : cpu_adr_i;
	 assign wbm_stb_o = bursting & !finish_burst_r;
	 assign wbm_cyc_o = bursting & !finish_burst_r;
	 assign wbm_sel_o = cpu_bsel_i;
	 assign wbm_we_o = cpu_we_i;
	 assign wbm_cti_o = bursting ? (finish_burst ? 3'b111 : 3'b010) :
			    3'b000;
	 assign wbm_bte_o = BURST_LENGTH==4  ? 2'b01 :
			    BURST_LENGTH==8  ? 2'b10 :
			    BURST_LENGTH==16 ? 2'b11 :
			    2'b00; // Linear burst

	 assign wbm_dat_o = cpu_dat_i;

	 assign cpu_err_o = wbm_err_i;
	 assign cpu_ack_o = (wbm_ack_i) &
			    !(bursting & address_differs) & cpu_req_i;
	 assign cpu_dat_o = wbm_err_i ? 0 :  wbm_dat_i;

      /* verilator lint_off WIDTH */
      end else if (BUS_IF_TYPE=="B3_REGISTERED_FEEDBACK") begin : b3_registered_feedback
	 /* verilator lint_on WIDTH */

	 assign wbm_adr_o = cpu_adr_i;
	 assign wbm_stb_o = cpu_req_i;
	 assign wbm_cyc_o = cpu_req_i;
	 assign wbm_sel_o = cpu_bsel_i;
	 assign wbm_we_o = cpu_we_i;
	 assign wbm_cti_o = cpu_burst_i ? 3'b010 : 3'b111;
	 assign wbm_bte_o = BURST_LENGTH==4  ? 2'b01 :
			    BURST_LENGTH==8  ? 2'b10 :
			    BURST_LENGTH==16 ? 2'b11 :
			    2'b00; // Linear burst

	 assign wbm_dat_o = cpu_dat_i;
	 assign cpu_err_o = wbm_err_i;
	 assign cpu_ack_o = wbm_ack_i;
	 assign cpu_dat_o = wbm_dat_i;

      end else begin : classic // CLASSIC only

	 // Only classic, single cycle accesses

	 // A register to force de-assertion of access request signals after
	 // each ack
	 reg 				      cycle_end;

	 always @(posedge clk `OR_ASYNC_RST)
	   if (rst)
	     cycle_end <= 1;
	   else
	     cycle_end <= wbm_ack_i | wbm_err_i;

	 assign cpu_err_o = wbm_err_i;
	 assign cpu_ack_o = wbm_ack_i;
	 assign cpu_dat_o = wbm_dat_i;

	 assign wbm_adr_o = cpu_adr_i;
	 assign wbm_stb_o = cpu_req_i & !cycle_end;
	 assign wbm_cyc_o = cpu_req_i;
	 assign wbm_sel_o = cpu_bsel_i;
	 assign wbm_we_o = cpu_we_i;
	 assign wbm_cti_o = 0;
	 assign wbm_bte_o = 0;
	 assign wbm_dat_o = cpu_dat_i;

      end // else: !if(BUS_IF_TYPE=="READ_B3_BURSTING")
   endgenerate

/*------------------Formal Checking----------------*/

`ifdef FORMAL


   reg f_past_valid = 0;
   initial f_past_valid = 0;
   initial assume(rst);
   always @(posedge clk)
      f_past_valid <= 1;
   always @(*)
      if (!f_past_valid)
         assume (rst);
      else
         assume (!rst);

   always @(posedge clk) begin
      if (BUS_IF_TYPE != "B3_REGISTERED_FEEDBACK" &
          BUS_IF_TYPE != "B3_READ_BURSTING") begin
         if (f_past_valid & $past(rst))
            assert (!wbm_stb_o);
         // On getting ack, strobe signal goes low.
         if (f_past_valid & !$past(rst) & ($past(cpu_ack_o) | $past(cpu_err_o)))
            assert (!wbm_stb_o);
         // CPU req should keep wbm_stb_o high till we get wb ack.
         // If there is no ack but cpu req is seen, then strobe should
         // stay high.
         if (f_past_valid & !$past(rst) & (!$past(cpu_ack_o) &
             !$past(cpu_err_o)) & cpu_req_i)
            assert (wbm_stb_o);
      end
   end

   always @*
      if (BUS_IF_TYPE != "B3_REGISTERED_FEEDBACK" &
          BUS_IF_TYPE != "B3_READ_BURSTING") begin
         assert (!wbm_cti_o);
         assert (!wbm_bte_o);
      end

   always @(posedge clk)
      if (f_past_valid & ($past(rst) | $past(wbm_err_i)))
         assert (wbm_adr_o == cpu_adr_i);

   // wbm_cti_o should remain in either of these three states:
   //  111- end of burst
   //  010- incrementing
   //  000- classic
   always @*
      assert (wbm_cti_o == 3'b111 | wbm_cti_o == 3'b010 | wbm_cti_o == 3'b000);

   // If cycle type identifier is incrementing and wb ack arrives,
   // then burst should be ended.
   always @(posedge clk)
      if (f_past_valid & !$past(rst) & $past(wbm_ack_i) & (!wbm_ack_i &
          !cpu_burst_i) & !$past(wbm_err_i) & $past(wbm_cti_o) == 2'b010
          & !cpu_req_i)
         assert (wbm_cti_o == 3'b111);
`endif
endmodule // mor1kx_bus_if_wb
