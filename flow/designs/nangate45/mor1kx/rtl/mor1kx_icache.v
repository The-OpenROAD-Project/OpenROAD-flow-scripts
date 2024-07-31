/* ****************************************************************************
  SPDX-License-Identifier: CERN-OHL-W-2.0

  Description: Instruction cache implementation

  Copyright (C) 2012-2013
     Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
     Stefan Wallentowitz <stefan.wallentowitz@tum.de>

 ******************************************************************************/

`include "mor1kx-defines.v"

module mor1kx_icache
  #(
    parameter OPTION_OPERAND_WIDTH = 32,
    parameter OPTION_ICACHE_BLOCK_WIDTH = 5,
    parameter OPTION_ICACHE_SET_WIDTH = 9,
    parameter OPTION_ICACHE_WAYS = 2,
    parameter OPTION_ICACHE_LIMIT_WIDTH = 32
    )
   (
    input 			      clk,
    input 			      rst,

    input 			      ic_imem_err_i,
    input 			      ic_access_i,
    output 			      refill_o,
    output 			      refill_req_o,
    output 			      refill_done_o,
    output 			      invalidate_o,
    output 			      cache_hit_o,

    // CPU Interface
    output 			      cpu_ack_o,
    output reg [`OR1K_INSN_WIDTH-1:0] cpu_dat_o,
    input [OPTION_OPERAND_WIDTH-1:0]  cpu_adr_i,
    input [OPTION_OPERAND_WIDTH-1:0]  cpu_adr_match_i,
    input 			      cpu_req_i,

    input [OPTION_OPERAND_WIDTH-1:0]  wradr_i,
    input [`OR1K_INSN_WIDTH-1:0]      wrdat_i,
    input 			      we_i,

    // SPR interface
    input [15:0] 		      spr_bus_addr_i,
    input 			      spr_bus_we_i,
    input 			      spr_bus_stb_i,
    input [OPTION_OPERAND_WIDTH-1:0]  spr_bus_dat_i,

    output [OPTION_OPERAND_WIDTH-1:0] spr_bus_dat_o,
    output reg 			      spr_bus_ack_o
    );

   // States
   localparam IDLE		= 4'b0001;
   localparam READ		= 4'b0010;
   localparam REFILL		= 4'b0100;
   localparam INVALIDATE	= 4'b1000;

   // Address space in bytes for a way
   localparam WAY_WIDTH = OPTION_ICACHE_BLOCK_WIDTH + OPTION_ICACHE_SET_WIDTH;
   /*
    * Tag memory layout
    *            +---------------------------------------------------------+
    * (index) -> | LRU | wayN valid | wayN tag |...| way0 valid | way0 tag |
    *            +---------------------------------------------------------+
    */

   // The tag is the part left of the index
   localparam TAG_WIDTH = (OPTION_ICACHE_LIMIT_WIDTH - WAY_WIDTH);

   // The tag memory contains entries with OPTION_ICACHE_WAYS parts of
   // each TAGMEM_WAY_WIDTH. Each of those is tag and a valid flag.
   localparam TAGMEM_WAY_WIDTH = TAG_WIDTH + 1;
   localparam TAGMEM_WAY_VALID = TAGMEM_WAY_WIDTH - 1;

   // Additionally, the tag memory entry contains an LRU value. The
   // width of this is actually 0 for OPTION_ICACHE_LIMIT_WIDTH==1
   localparam TAG_LRU_WIDTH = OPTION_ICACHE_WAYS*(OPTION_ICACHE_WAYS-1) >> 1;

   // We have signals for the LRU which are not used for one way
   // caches. To avoid signal width [-1:0] this generates [0:0]
   // vectors for them, which are removed automatically then.
   localparam TAG_LRU_WIDTH_BITS = (OPTION_ICACHE_WAYS >= 2) ? TAG_LRU_WIDTH : 1;

   // Compute the total sum of the entry elements
   localparam TAGMEM_WIDTH = TAGMEM_WAY_WIDTH * OPTION_ICACHE_WAYS + TAG_LRU_WIDTH;

   // For convenience we define the position of the LRU in the tag
   // memory entries
   localparam TAG_LRU_MSB = TAGMEM_WIDTH - 1;
   localparam TAG_LRU_LSB = TAG_LRU_MSB - TAG_LRU_WIDTH + 1;

   // FSM state signals
   reg [3:0] 			      state;
   wire				      read;
   wire				      refill;
   wire				      invalidate;

   reg [WAY_WIDTH-1:OPTION_ICACHE_BLOCK_WIDTH] invalidate_adr;
   wire [31:0] 			      next_refill_adr;
   wire 			      refill_done;
   wire 			      refill_hit;
   reg [(1<<(OPTION_ICACHE_BLOCK_WIDTH-2))-1:0] refill_valid;
   reg [(1<<(OPTION_ICACHE_BLOCK_WIDTH-2))-1:0] refill_valid_r;

   // The index we read and write from tag memory
   wire [OPTION_ICACHE_SET_WIDTH-1:0] tag_rindex;
   wire [OPTION_ICACHE_SET_WIDTH-1:0] tag_windex;

   // The data from the tag memory
   wire [TAGMEM_WIDTH-1:0] 	      tag_dout;
   wire [TAG_LRU_WIDTH_BITS-1:0]      tag_lru_out;
   wire [TAGMEM_WAY_WIDTH-1:0] 	      tag_way_out [OPTION_ICACHE_WAYS-1:0];

   // The data to the tag memory
   wire [TAGMEM_WIDTH-1:0] 	      tag_din;
   reg [TAG_LRU_WIDTH_BITS-1:0]       tag_lru_in;
   reg [TAGMEM_WAY_WIDTH-1:0] 	      tag_way_in [OPTION_ICACHE_WAYS-1:0];

   reg [TAGMEM_WAY_WIDTH-1:0] 	      tag_way_save [OPTION_ICACHE_WAYS-1:0];

   // Whether to write to the tag memory in this cycle
   reg 				      tag_we;

   // This is the tag we need to write to the tag memory during refill
   wire [TAG_WIDTH-1:0] 	      tag_wtag;

   // This is the tag we check against
   wire [TAG_WIDTH-1:0] 	      tag_tag;

   // Access to the way memories
   wire [WAY_WIDTH-3:0] 	      way_raddr[OPTION_ICACHE_WAYS-1:0];
   wire [WAY_WIDTH-3:0] 	      way_waddr[OPTION_ICACHE_WAYS-1:0];
   wire [OPTION_OPERAND_WIDTH-1:0]    way_din[OPTION_ICACHE_WAYS-1:0];
   wire [OPTION_OPERAND_WIDTH-1:0]    way_dout[OPTION_ICACHE_WAYS-1:0];
   reg [OPTION_ICACHE_WAYS-1:0]       way_we;

   // Does any way hit?
   wire 			      hit;
   wire [OPTION_ICACHE_WAYS-1:0]      way_hit;

   // This is the least recently used value before access the memory.
   // Those are one hot encoded.
   wire [OPTION_ICACHE_WAYS-1:0]      lru;

   // Register that stores the LRU value from lru
   reg [OPTION_ICACHE_WAYS-1:0]       tag_save_lru;

   // The access vector to update the LRU history is the way that has
   // a hit or is refilled. It is also one-hot encoded.
   reg [OPTION_ICACHE_WAYS-1:0]       access;

   // The current LRU history as read from tag memory and the update
   // value after we accessed it to write back to tag memory.
   wire [TAG_LRU_WIDTH_BITS-1:0]      current_lru_history;
   wire [TAG_LRU_WIDTH_BITS-1:0]      next_lru_history;

   // Intermediate signals to ease debugging
   wire [TAG_WIDTH-1:0]               check_way_tag [OPTION_ICACHE_WAYS-1:0];
   wire                               check_way_match [OPTION_ICACHE_WAYS-1:0];
   wire                               check_way_valid [OPTION_ICACHE_WAYS-1:0];

   genvar 			      i;

   // Allowing (out of the cache line being refilled) accesses during refill
   // exposes a bug somewhere, causing the Linux kernel to end up with a
   // bus error UNHANDLED EXCEPTION.
   // Until that is sorted out, disable it.
   assign cpu_ack_o = (read /*| refill & ic_access_i*/) & hit |
		      refill_hit & ic_access_i;

   assign tag_rindex = cpu_adr_i[WAY_WIDTH-1:OPTION_ICACHE_BLOCK_WIDTH];
   /*
    * The tag mem is written during reads to write the lru info and during
    * refill and invalidate
    */
   assign tag_windex = read ?
		       cpu_adr_match_i[WAY_WIDTH-1:OPTION_ICACHE_BLOCK_WIDTH] :
		       invalidate ? invalidate_adr :
		       wradr_i[WAY_WIDTH-1:OPTION_ICACHE_BLOCK_WIDTH];
   assign tag_tag = cpu_adr_match_i[OPTION_ICACHE_LIMIT_WIDTH-1:WAY_WIDTH];
   assign tag_wtag = wradr_i[OPTION_ICACHE_LIMIT_WIDTH-1:WAY_WIDTH];

   generate
      if (OPTION_ICACHE_WAYS >= 2) begin
         // Multiplex the LRU history from and to tag memory
         assign current_lru_history = tag_dout[TAG_LRU_MSB:TAG_LRU_LSB];
         assign tag_din[TAG_LRU_MSB:TAG_LRU_LSB] = tag_lru_in;
         assign tag_lru_out = tag_dout[TAG_LRU_MSB:TAG_LRU_LSB];
      end

      for (i = 0; i < OPTION_ICACHE_WAYS; i=i+1) begin : ways
	 assign way_raddr[i] = cpu_adr_i[WAY_WIDTH-1:2];
	 assign way_waddr[i] = wradr_i[WAY_WIDTH-1:2];
	 assign way_din[i] = wrdat_i;

	 // compare stored tag with incoming tag and check valid bit
         assign check_way_tag[i] = tag_way_out[i][TAG_WIDTH-1:0];
         assign check_way_match[i] = (check_way_tag[i] == tag_tag);
         assign check_way_valid[i] = tag_way_out[i][TAGMEM_WAY_VALID];

         assign way_hit[i] = check_way_valid[i] & check_way_match[i];

         // Multiplex the way entries in the tag memory
         assign tag_din[(i+1)*TAGMEM_WAY_WIDTH-1:i*TAGMEM_WAY_WIDTH] = tag_way_in[i];
         assign tag_way_out[i] = tag_dout[(i+1)*TAGMEM_WAY_WIDTH-1:i*TAGMEM_WAY_WIDTH];
      end
   endgenerate

   assign hit = |way_hit;
   assign cache_hit_o = hit;

   integer w0;
   always @(*) begin
      cpu_dat_o = {OPTION_OPERAND_WIDTH{1'bx}};

      // Put correct way on the data port
      for (w0 = 0; w0 < OPTION_ICACHE_WAYS; w0 = w0 + 1) begin
         if (way_hit[w0] | (refill_hit & tag_save_lru[w0])) begin
            cpu_dat_o = way_dout[w0];
         end
      end
   end

   assign next_refill_adr = (OPTION_ICACHE_BLOCK_WIDTH == 5) ?
			    {wradr_i[31:5], wradr_i[4:0] + 5'd4} : // 32 byte
			    {wradr_i[31:4], wradr_i[3:0] + 4'd4};  // 16 byte

   assign refill_done_o = refill_done;
   assign refill_done = refill_valid[next_refill_adr[OPTION_ICACHE_BLOCK_WIDTH-1:2]];
   assign refill_hit = refill_valid_r[cpu_adr_match_i[OPTION_ICACHE_BLOCK_WIDTH-1:2]] &
		       cpu_adr_match_i[OPTION_ICACHE_LIMIT_WIDTH-1:
				       OPTION_ICACHE_BLOCK_WIDTH] ==
		       wradr_i[OPTION_ICACHE_LIMIT_WIDTH-1:
			       OPTION_ICACHE_BLOCK_WIDTH] &
		       refill;

   assign refill = (state == REFILL);
   assign read = (state == READ);
   assign invalidate = (state == INVALIDATE);

   assign refill_o = refill;

   assign refill_req_o = read & cpu_req_i & !hit | refill;

   /*
    * SPR bus interface
    */
   assign invalidate_o = spr_bus_stb_i & spr_bus_we_i &
			 (spr_bus_addr_i == `OR1K_SPR_ICBIR_ADDR);
   assign spr_bus_dat_o = 32'b0;

   /*
    * Cache FSM
    */
   integer w1;
   always @(posedge clk `OR_ASYNC_RST) begin
      refill_valid_r <= refill_valid;
      spr_bus_ack_o <= 0;
      case (state)
	IDLE: begin
	   if (cpu_req_i)
	     state <= READ;
	end

	READ: begin
	   if (ic_access_i) begin
	      if (hit) begin
		 state <= READ;
	      end else if (cpu_req_i) begin
		 refill_valid <= 0;
		 refill_valid_r <= 0;

		 // Store the LRU information for correct replacement
                 // on refill. Always one when only one way.
                 tag_save_lru <= (OPTION_ICACHE_WAYS==1) | lru;

		 for (w1 = 0; w1 < OPTION_ICACHE_WAYS; w1 = w1 + 1) begin
		    tag_way_save[w1] <= tag_way_out[w1];
		 end

		 state <= REFILL;
	      end
	   end else begin
	      state <= IDLE;
	   end
	end

	REFILL: begin
	   if (we_i) begin
	      refill_valid[wradr_i[OPTION_ICACHE_BLOCK_WIDTH-1:2]] <= 1;

	      if (refill_done)
		state <= IDLE;
	   end
	end

	INVALIDATE: begin
	   if (!invalidate_o)
	     state <= IDLE;
	   spr_bus_ack_o <= 1;
	end

	default:
	  state <= IDLE;
      endcase

      if (rst) begin
	 state <= IDLE;
	 spr_bus_ack_o <= 0;
      end else if (ic_imem_err_i)
	 state <= IDLE;
      else if (invalidate_o & !refill) begin
	 invalidate_adr <= spr_bus_dat_i[WAY_WIDTH-1:OPTION_ICACHE_BLOCK_WIDTH];
	 spr_bus_ack_o <= 1;
	 state <= INVALIDATE;
      end

   end

   integer w2;
   always @(*) begin
      // Default is to keep data, don't write and don't access
      tag_lru_in = tag_lru_out;
      for (w2 = 0; w2 < OPTION_ICACHE_WAYS; w2 = w2 + 1) begin
         tag_way_in[w2] = tag_way_out[w2];
      end

      tag_we = 1'b0;
      way_we = {(OPTION_ICACHE_WAYS){1'b0}};

      access = {(OPTION_ICACHE_WAYS){1'b0}};

      case (state)
	READ: begin
	   if (hit) begin
	      // We got a hit. The LRU module gets the access
              // information. Depending on this we update the LRU
              // history in the tag.
              access = way_hit;

              // This is the updated LRU history after hit
              tag_lru_in = next_lru_history;

	      tag_we = 1'b1;
	   end
	end

	REFILL: begin
	   if (we_i) begin
              // Write the data to the way that is replaced (which is
              // the LRU)
              way_we = tag_save_lru;

	      // Access pattern
	      access = tag_save_lru;

	      /* Invalidate the way on the first write */
	      if (refill_valid == 0) begin
		 for (w2 = 0; w2 < OPTION_ICACHE_WAYS; w2 = w2 + 1) begin
                    if (tag_save_lru[w2]) begin
                       tag_way_in[w2][TAGMEM_WAY_VALID] = 1'b0;
                    end
                 end

		 tag_we = 1'b1;
	      end

              // After refill update the tag memory entry of the
              // filled way with the LRU history, the tag and set
              // valid to 1.
	      if (refill_done) begin
		 for (w2 = 0; w2 < OPTION_ICACHE_WAYS; w2 = w2 + 1) begin
		    tag_way_in[w2] = tag_way_save[w2];
                    if (tag_save_lru[w2]) begin
                       tag_way_in[w2] = { 1'b1, tag_wtag };
                    end
                 end
                 tag_lru_in = next_lru_history;

		 tag_we = 1'b1;
	      end
	   end
	end

	INVALIDATE: begin
	   // Lazy invalidation, invalidate everything that matches tag address
           tag_lru_in = 0;
           for (w2 = 0; w2 < OPTION_ICACHE_WAYS; w2 = w2 + 1) begin
              tag_way_in[w2] = 0;
           end

	   tag_we = 1'b1;
	end

	default: begin
	end
      endcase
   end

   /* mor1kx_simple_dpram_sclk AUTO_TEMPLATE (
      // Outputs
      .dout			(way_dout[i][OPTION_OPERAND_WIDTH-1:0]),
      // Inputs
      .raddr			(way_raddr[i][WAY_WIDTH-3:0]),
      .re			(1'b1),
      .waddr			(way_waddr[i][WAY_WIDTH-3:0]),
      .we			(way_we[i]),
      .din			(way_din[i][31:0]));
    */
   generate
      for (i = 0; i < OPTION_ICACHE_WAYS; i=i+1) begin : way_memories
	 mor1kx_simple_dpram_sclk
	       #(
		 .ADDR_WIDTH(WAY_WIDTH-2),
		 .DATA_WIDTH(OPTION_OPERAND_WIDTH),
		 .ENABLE_BYPASS(0)
		 )
	 way_data_ram
	       (/*AUTOINST*/
		// Outputs
		.dout			(way_dout[i][OPTION_OPERAND_WIDTH-1:0]), // Templated
		// Inputs
		.clk			(clk),
		.raddr			(way_raddr[i][WAY_WIDTH-3:0]), // Templated
		.re			(1'b1),			 // Templated
		.waddr			(way_waddr[i][WAY_WIDTH-3:0]), // Templated
		.we			(way_we[i]),		 // Templated
		.din			(way_din[i][31:0]));	 // Templated

      end // block: way_memories

      if (OPTION_ICACHE_WAYS >= 2) begin : gen_u_lru
         /* mor1kx_cache_lru AUTO_TEMPLATE(
          .current  (current_lru_history),
          .update   (next_lru_history),
          .lru_pre  (lru),
          .lru_post (),
          .access   (access),
          ); */

         mor1kx_cache_lru
           #(.NUMWAYS(OPTION_ICACHE_WAYS))
         u_lru(/*AUTOINST*/
	       // Outputs
	       .update			(next_lru_history),	 // Templated
	       .lru_pre			(lru),			 // Templated
	       .lru_post		(),			 // Templated
	       // Inputs
	       .current			(current_lru_history),	 // Templated
	       .access			(access));		 // Templated
      end // if (OPTION_ICACHE_WAYS >= 2)
   endgenerate

   /* mor1kx_simple_dpram_sclk AUTO_TEMPLATE (
      // Outputs
      .dout			(tag_dout[TAGMEM_WIDTH-1:0]),
      // Inputs
      .raddr			(tag_rindex),
      .re			(1'b1),
      .waddr			(tag_windex),
      .we			(tag_we),
      .din			(tag_din));
    */
   mor1kx_simple_dpram_sclk
     #(
       .ADDR_WIDTH(OPTION_ICACHE_SET_WIDTH),
       .DATA_WIDTH(TAGMEM_WIDTH),
       .ENABLE_BYPASS(0)
     )
   tag_ram
     (/*AUTOINST*/
      // Outputs
      .dout				(tag_dout[TAGMEM_WIDTH-1:0]), // Templated
      // Inputs
      .clk				(clk),
      .raddr				(tag_rindex),		 // Templated
      .re				(1'b1),			 // Templated
      .waddr				(tag_windex),		 // Templated
      .we				(tag_we),		 // Templated
      .din				(tag_din));		 // Templated

/*----------------Formal Checking------------------*/

`ifdef FORMAL

   reg f_past_valid;
   initial f_past_valid = 1'b0;
   initial assume (rst);

   always @(posedge clk)
      f_past_valid <= 1'b1;

   always @(*)
      if (!f_past_valid)
         assume (rst);

`ifdef ICACHE
`define ASSUME assume
`else
`define ASSUME assert
`endif

   //CPU request should arrive only if fetch gives access to icache
   always @(posedge clk)
      if (cpu_req_i)
         `ASSUME(ic_access_i);

//-------------Assertions--------------------

//----------Verifying functionality---------
`ifdef ICACHE

   (* anyconst *) wire [OPTION_OPERAND_WIDTH-1:0] f_refill_addr;
   (* anyconst *) reg [OPTION_OPERAND_WIDTH-1:0] f_refill_data;
   wire f_this_refill;
   reg f_refilled;

   initial f_refilled = 1'b0;
   assign f_this_refill = (wradr_i == f_refill_addr) && refill_o;

   //Refilling
   always @(posedge clk) begin
      if ($past(f_this_refill) && (f_refill_data == wrdat_i) &&
          !$past(cache_hit_o)&& $past(cpu_req_i)
          && f_past_valid && !$past(rst) && $past(state) == READ) begin
         assert (refill);
         f_refilled <= 1'b1;
         assert ($onehot(way_we));
      end
   end

   //Read: f_refill_data has to be returned if cpu requests for same address f_refill_addr.
   always @(posedge clk) begin
      if ($rose(f_refilled) && (cpu_adr_match_i == f_refill_addr)
          && cache_hit_o && f_past_valid && !$past(rst)) begin
         assert (cpu_dat_o == f_refill_data);
         assert (read);
         assert (cpu_ack_o);
      end
   end

   reg f_after_invalidate;
   initial f_after_invalidate = 1'b0;

   //Invalidation: Checking if ways of set have invalid tag bit on set invalidation.
   always @(posedge clk) begin
      if ($past(invalidate_o) && !$past(refill) && f_past_valid
         && $past(spr_bus_dat_i) == f_refill_addr[WAY_WIDTH-1:OPTION_ICACHE_BLOCK_WIDTH]
         && $past(f_refilled) && !$past(f_refilled,2)) begin
         assert (spr_bus_ack_o);
         assert (invalidate);
         assert (!cpu_ack_o);
         assert (tag_we);
         assert (!tag_din[TAGMEM_WAY_VALID]);
         f_after_invalidate <= 1;
      end
   end

   //There shouldn't be any cache hit for f_refill_addr after invalidation.
   always @(posedge clk)
      if (cpu_adr_match_i == f_refill_addr && $rose(f_after_invalidate) && f_past_valid)
         assert (!cache_hit_o);

`endif

//-----------ICACHE PROPERTIES-------------

   // Cache hit in read state updates lru access variable
   // Checking every way might slow down the solver, so assuming some way hit.
   always @(posedge clk) begin
      if (f_past_valid && !$past(rst) && way_hit[0] && $onehot(way_hit) && read)
         assert (access == way_hit[0]);
   end

   //Way ram should be written only on refill request.
   always @(posedge clk)
      if (way_we == way_hit && $onehot(way_hit) && f_past_valid && !$past(rst))
         assert (we_i);

   //Tag ram and way ram are not updated in the IDLE state
   always @(*)
      if (state == IDLE)
         assert (!tag_we && !way_we);

   //Way ram cannot be written in the read state
   always @(*)
      if (read)
         assert (!way_we);

   //CPU acknowledgement in the refill state is valid only if read is set low.
   always @(*)
      if (refill_o && cpu_ack_o)
         assert (refill_hit && !read);

   //If instruction memory throws up an error then icache shouldn't proceed with its tasks
   always @(posedge clk)
      if (f_past_valid & !$past(rst) && $past(ic_imem_err_i))
         assert ((state == IDLE) & !(read | refill | invalidate));

   //CPU acknowledgement implies either cache_hit_o or refill hit is observed.
   always @(posedge clk)
      if (cpu_ack_o && f_past_valid && !$past(rst))
         assert (cache_hit_o || refill_hit);

   //Icache triggers to refill state only if there is cache miss
   always @(posedge clk)
      if (f_past_valid && !$past(rst) && $rose(refill_o))
         assert (!$past(cache_hit_o));

   //Refill hit shouldn't happen in any state other than refill
   always @(posedge clk)
      if (refill_hit && f_past_valid && !$past(rst))
         assert (state != READ && state != INVALIDATE && state != IDLE);

   //Refilling should always update way ram
   always @(*)
      if (refill_o && we_i && $onehot(tag_save_lru))
         assert ($onehot(way_we));

   //Refilling should replace the least recently used way in a set.
   always @(*)
      if (refill_o && we_i)
         assert (way_we == access);

   //Before refilling tag should be invalidated
   always @(*)
      if (refill_o && !refill_valid && we_i)
         assert (tag_we);

   //LRU access variable should be updated while refilling
   always @(*)
      if (refill_o && we_i)
         assert (access == tag_save_lru);

   //Icache invalidation is initiated only if spr address is ICBIR
   always @(posedge clk)
      if (invalidate_o)
         assert (spr_bus_addr_i == `OR1K_SPR_ICBIR_ADDR);

   //SPR ack is seen only if strobe and write signal rise in the previous clock cycle
   always @(posedge clk)
      if ($rose(spr_bus_ack_o) && f_past_valid && !$past(rst))
         assert ($past(spr_bus_stb_i) & $past(spr_bus_we_i)
                 & $past(spr_bus_addr_i) == `OR1K_SPR_ICBIR_ADDR
                 & !$past(refill_o));

   //SPR ack shouldn't be observed for spr read request in icache.
   always @(posedge clk)
      if (f_past_valid & !$past(rst) & $past(spr_bus_stb_i) & !$past(spr_bus_we_i)
           & $past(spr_bus_addr_i) == `OR1K_SPR_ICBIR_ADDR & !$past(invalidate))
         assert (!spr_bus_ack_o);

   fspr_slave #(
       .OPTION_OPERAND_WIDTH(OPTION_OPERAND_WIDTH),
       .SLAVE("ICACHE")
       )
       u_f_icache_slave (
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

//-------------Cover-------------

`ifdef ICACHE

   //Invalidation----------Trace 0
   always @(posedge clk)
      cover (tag_we && state == INVALIDATE && !$past(rst)
            && f_past_valid && spr_bus_ack_o);

   //Cache Read------------Trace 1
   always @(posedge clk)
      cover (state == READ && tag_we && cache_hit_o &&
            cpu_ack_o && !$past(rst) && f_past_valid);

   //Refilling-------------Trace 2
   always @(posedge clk)
      cover (refill_o && $onehot(way_we) && refill_done
             && tag_we && !$past(rst) && cpu_ack_o && f_past_valid);
`endif

`endif
endmodule
