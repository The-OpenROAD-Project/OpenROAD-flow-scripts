/* ****************************************************************************
  SPDX-License-Identifier: CERN-OHL-W-2.0

  Description: Data cache implementation

  Copyright (C) 2012-2013
     Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
     Stefan Wallentowitz <stefan.wallentowitz@tum.de>

 ******************************************************************************/

// The mor1kx dcache is implemented as a write around cache with an
// optimization to populate cache line (write though) entries if a there is
// a valid entry in the dcache.

// Cases:

// 1. Write to cached memory entry
//    A data cache write operation will update cached way data if there is
//    a valid cache-line entry.  A write request must be guaranteed to finish in
//    2 clock cycles.  First clock cycle request, second clock cycle write.  The
//    LSU does not expect a response and will only present the write request to
//    the data cache for 2 clock cycles.  This will be extended only if there is
//    a snoop hit or in refill state.
//
//    A write starts by transitioning the data cache FSM into WRITE state.
//    While in the WRITE state the tag memory and way memory will be written to.
//
//    If already in WRITE state a write option can complete in one cycle.
//
// 2. Write to non-cached memory entry
//    A data cache write to a non-cached entry is similar to a cached write
//    however tag and way memory will not be updated.  The FSM will sill need to
//    transition to the WRITE state in order to check the cache-line.
//
// 3. Read from cached memory entry
//    A data cache read will first transition the data cache FSM to the READ
//    state.  When in the read state a valid entry in the way memory will be
//    represented as a hit.
//
//    The cache-line data be provided back to the LSU.  This is done by
//    asserting the cpu ack line.
//
//    If the data cache is already in the READ state valid read requests will
//    complete in 1 clock cycle.
//
// 4. Read from non-cached memory entry
//    A data cache read for a non-cached memory entry will first transition the
//    FSM to the READ state to check the cache-line.  If the cache-line does not
//    have a valid entry (miss) the data cache will transition to the REFILL
//    state.  During REFILL the data cache requests the LSU to operate the data
//    bus and provide cache REFILL data.  When a cache-line if filled the data
//    cache requests the LSU to stop.
//
//    During refill when the request cache-line entry is being filled it will be
//    provided back to the LSU.  This provides better performance as the pending
//    read does not need to wait for the refill to complete.  This is done by
//    asserting the cpu ack line.
//
// 5. SPR request to invalidate or flush entries
//    A data cache SPR request will first transition the FSM into the
//    INVALIDATE state.  Once in the invalidate state the requested cache-line
//    entries will be invalidated.  The completion of this operation is
//    represented as an SPR ack.
//
// 6. Snoop Operation
//    Snoop is a signal that comes when there has been a CPU external memory
//    write on bus.  The data cache must invalidate valid entries in tag
//    memory when this occurs.
//
//    Snoop operations are highest priority and like other operations take
//    a maximum of 2 clock cycles.  One cycle to register the request and one
//    cycle to perform the invalidation.
//
//    When there is a snoop hit the data cache indicates this to the LSU to
//    delay any pending writes.

`include "mor1kx-defines.v"

module mor1kx_dcache
  #(
    parameter OPTION_OPERAND_WIDTH = 32,
    parameter OPTION_DCACHE_BLOCK_WIDTH = 5,
    parameter OPTION_DCACHE_SET_WIDTH = 9,
    parameter OPTION_DCACHE_WAYS = 2,
    parameter OPTION_DCACHE_LIMIT_WIDTH = 32,
    parameter OPTION_DCACHE_SNOOP = "NONE"
    )
   (
    input 			      clk,
    input 			      rst,

    input 			      dc_dbus_err_i,
    // Indicates if data cache is enabled on the CPU
    input 			      dc_enable_i,
    // Indicates the data cache is being accessed for a read or write
    input 			      dc_access_i,

    // Refill Interface
    // Indicate to LSU that refill is in progress
    output 			      refill_o,
    // Request to the LSU to start and complete a refill transaction
    // at the current read address.
    output 			      refill_req_o,
    output 			      refill_done_o,
    // Refill inputs from the LSU
    input 			      refill_allowed_i,
    input [OPTION_OPERAND_WIDTH-1:0]  refill_adr_i,
    input [OPTION_OPERAND_WIDTH-1:0]  refill_dat_i,
    input 			      refill_we_i,

    output 			      cache_hit_o,

    // CPU Interface
    output 			      cpu_err_o,
    output 			      cpu_ack_o,
    output reg [OPTION_OPERAND_WIDTH-1:0] cpu_dat_o,
    input [OPTION_OPERAND_WIDTH-1:0]  cpu_dat_i,
    input [OPTION_OPERAND_WIDTH-1:0]  cpu_adr_i,
    input [OPTION_OPERAND_WIDTH-1:0]  cpu_adr_match_i,
    input 			      cpu_req_i,
    input 			      cpu_we_i,
    input [3:0] 		      cpu_bsel_i,

    // Snoop address
    input [31:0] 		      snoop_adr_i,
    // Snoop event in this cycle
    input 			      snoop_valid_i,
    // Whether the snoop hit. If so, there will be no tag memory write
    // this cycle. The LSU may need to stall the pipeline.
    output 			      snoop_hit_o,

    // SPR interface
    input [15:0] 		      spr_bus_addr_i,
    input 			      spr_bus_we_i,
    input 			      spr_bus_stb_i,
    input [OPTION_OPERAND_WIDTH-1:0]  spr_bus_dat_i,
    output [OPTION_OPERAND_WIDTH-1:0] spr_bus_dat_o,
    output 			      spr_bus_ack_o
    );

   // States
   localparam IDLE		= 5'b00001;
   localparam READ		= 5'b00010;
   localparam WRITE		= 5'b00100;
   localparam REFILL		= 5'b01000;
   localparam INVALIDATE	= 5'b10000;

   // Address space in bytes for a way
   localparam WAY_WIDTH = OPTION_DCACHE_BLOCK_WIDTH + OPTION_DCACHE_SET_WIDTH;
   /*
    * Tag memory layout
    *            +---------------------------------------------------------+
    * (index) -> | LRU | wayN valid | wayN tag |...| way0 valid | way0 tag |
    *            +---------------------------------------------------------+
    */

   // The tag is the part left of the index
   localparam TAG_WIDTH = (OPTION_DCACHE_LIMIT_WIDTH - WAY_WIDTH);

   // The tag memory contains entries with OPTION_DCACHE_WAYS parts of
   // each TAGMEM_WAY_WIDTH. Each of those is tag and a valid flag.
   localparam TAGMEM_WAY_WIDTH = TAG_WIDTH + 1;
   localparam TAGMEM_WAY_VALID = TAGMEM_WAY_WIDTH - 1;

   // Additionally, the tag memory entry contains an LRU value. The
   // width of this is 0 for OPTION_DCACHE_LIMIT_WIDTH==1
   localparam TAG_LRU_WIDTH = OPTION_DCACHE_WAYS*(OPTION_DCACHE_WAYS-1) >> 1;

   // We have signals for the LRU which are not used for one way
   // caches. To avoid signal width [-1:0] this generates [0:0]
   // vectors for them, which are removed automatically then.
   localparam TAG_LRU_WIDTH_BITS = (OPTION_DCACHE_WAYS >= 2) ? TAG_LRU_WIDTH : 1;

   // Compute the total sum of the entry elements
   localparam TAGMEM_WIDTH = TAGMEM_WAY_WIDTH * OPTION_DCACHE_WAYS + TAG_LRU_WIDTH;

   // For convenience we define the position of the LRU in the tag
   // memory entries
   localparam TAG_LRU_MSB = TAGMEM_WIDTH - 1;
   localparam TAG_LRU_LSB = TAG_LRU_MSB - TAG_LRU_WIDTH + 1;

   // FSM state signals
   reg [4:0] 			      state;
   wire				      read;
   wire				      write;
   wire				      refill;

   reg [WAY_WIDTH-1:OPTION_DCACHE_BLOCK_WIDTH] invalidate_adr;
   wire [31:0] 			      next_refill_adr;
   reg [31:0] 			      way_wr_dat;
   wire 			      refill_done;
   wire 			      refill_hit;
   reg [(1<<(OPTION_DCACHE_BLOCK_WIDTH-2))-1:0] refill_valid;
   reg [(1<<(OPTION_DCACHE_BLOCK_WIDTH-2))-1:0] refill_valid_r;
   wire				      invalidate;

   // The index we read and write from tag memory
   wire [OPTION_DCACHE_SET_WIDTH-1:0] tag_rindex;
   reg [OPTION_DCACHE_SET_WIDTH-1:0]  tag_windex;

   // The data from the tag memory
   wire [TAGMEM_WIDTH-1:0] 	      tag_dout;
   wire [TAG_LRU_WIDTH_BITS-1:0]      tag_lru_out;
   wire [TAGMEM_WAY_WIDTH-1:0] 	      tag_way_out [OPTION_DCACHE_WAYS-1:0];

   // The data to the tag memory
   wire [TAGMEM_WIDTH-1:0] 	      tag_din;
   reg [TAG_LRU_WIDTH_BITS-1:0]       tag_lru_in;
   reg [TAGMEM_WAY_WIDTH-1:0] 	      tag_way_in [OPTION_DCACHE_WAYS-1:0];

   reg [TAGMEM_WAY_WIDTH-1:0] 	      tag_way_save[OPTION_DCACHE_WAYS-1:0];

   // Whether to write to the tag memory in this cycle
   reg 				      tag_we;

   // This is the tag we need to write to the tag memory during refill
   wire [TAG_WIDTH-1:0] 	      tag_wtag;

   // This is the tag we check against
   wire [TAG_WIDTH-1:0] 	      tag_tag;

   // Access to the way memories
   wire [WAY_WIDTH-3:0] 	      way_raddr[OPTION_DCACHE_WAYS-1:0];
   wire [WAY_WIDTH-3:0] 	      way_waddr[OPTION_DCACHE_WAYS-1:0];
   wire [OPTION_OPERAND_WIDTH-1:0]    way_din[OPTION_DCACHE_WAYS-1:0];
   wire [OPTION_OPERAND_WIDTH-1:0]    way_dout[OPTION_DCACHE_WAYS-1:0];
   reg [OPTION_DCACHE_WAYS-1:0]       way_we;

   // Does any way hit?
   wire 			      hit;
   wire [OPTION_DCACHE_WAYS-1:0]      way_hit;

   // This is the least recently used value before access the memory.
   // It is the value of current_lru_history that is combinationally
   // one hot encoded.
   // Used to select which way to replace during refill.
   wire [OPTION_DCACHE_WAYS-1:0]      current_lru;

   // Register that stores the LRU value from lru
   reg [OPTION_DCACHE_WAYS-1:0]       tag_save_lru;

   // The access vector to update the LRU history is the way that has
   // a hit or is refilled. It is also one-hot encoded.
   reg [OPTION_DCACHE_WAYS-1:0]       access;

   // The current encoded LRU history as read from tag memory.
   wire [TAG_LRU_WIDTH_BITS-1:0]      current_lru_history;
   // This is the encoded value of current LRU history after being combined
   // with the access vector.
   // This value is written back to tag memory if there is a hit or
   // refill.
   wire [TAG_LRU_WIDTH_BITS-1:0]      next_lru_history;

   // Intermediate signals to ease debugging
   wire [TAG_WIDTH-1:0]               check_way_tag [OPTION_DCACHE_WAYS-1:0];
   wire                               check_way_match [OPTION_DCACHE_WAYS-1:0];
   wire                               check_way_valid [OPTION_DCACHE_WAYS-1:0];

   reg 				      write_pending;

   // Extract index to read from snooped address
   wire [OPTION_DCACHE_SET_WIDTH-1:0] snoop_index;
   assign snoop_index = snoop_adr_i[WAY_WIDTH-1:OPTION_DCACHE_BLOCK_WIDTH];

   // Register that is high one cycle after the actual snoop event to
   // drive the comparison
   reg 				      snoop_check;
   // Register that stores the tag for one cycle
   reg [TAG_WIDTH-1:0] 		      snoop_tag;
   // Also store the index for one cycle, for the succeeding write access
   reg [OPTION_DCACHE_SET_WIDTH-1:0]  snoop_windex;

   // Snoop tag memory interface
   // Data out of tag memory
   wire [TAGMEM_WIDTH-1:0] 	      snoop_dout;
   // Each ways information in the tag memory
   wire [TAGMEM_WAY_WIDTH-1:0] 	      snoop_way_out [OPTION_DCACHE_WAYS-1:0];
   // Each ways tag in the tag memory
   wire [TAG_WIDTH-1:0] 	      snoop_check_way_tag [OPTION_DCACHE_WAYS-1:0];
   // Whether the tag matches the snoop tag
   wire                               snoop_check_way_match [OPTION_DCACHE_WAYS-1:0];
   // Whether the tag is valid
   wire                               snoop_check_way_valid [OPTION_DCACHE_WAYS-1:0];
   // Whether the way hits
   wire [OPTION_DCACHE_WAYS-1:0]      snoop_way_hit;
   // Whether any way hits
   wire 			      snoop_hit;

   assign snoop_hit_o = (OPTION_DCACHE_SNOOP != "NONE") ? snoop_hit : 0;

   genvar 			      i;

   // Ack the to LSU to indicate a Data Cache read is ready
   assign cpu_ack_o = ((read | refill) & hit & !write_pending |
		       refill_hit) & cpu_req_i & !snoop_hit;

   assign tag_rindex = cpu_adr_i[WAY_WIDTH-1:OPTION_DCACHE_BLOCK_WIDTH];

   assign tag_tag = cpu_adr_match_i[OPTION_DCACHE_LIMIT_WIDTH-1:WAY_WIDTH];
   assign tag_wtag = refill_adr_i[OPTION_DCACHE_LIMIT_WIDTH-1:WAY_WIDTH];

   assign cpu_err_o = 0;
   assign spr_bus_dat_o = 0;

   generate
      if (OPTION_DCACHE_WAYS >= 2) begin
         // Multiplex the LRU history from and to tag memory
         assign current_lru_history = tag_dout[TAG_LRU_MSB:TAG_LRU_LSB];
         assign tag_din[TAG_LRU_MSB:TAG_LRU_LSB] = tag_lru_in;
         assign tag_lru_out = tag_dout[TAG_LRU_MSB:TAG_LRU_LSB];
      end

      for (i = 0; i < OPTION_DCACHE_WAYS; i=i+1) begin : ways
	 assign way_raddr[i] = cpu_adr_i[WAY_WIDTH-1:2];
	 assign way_waddr[i] = write ? cpu_adr_match_i[WAY_WIDTH-1:2] :
			       refill_adr_i[WAY_WIDTH-1:2];
	 assign way_din[i] = way_wr_dat;

	 // compare stored tag with incoming tag and check valid bit
         assign check_way_tag[i] = tag_way_out[i][TAG_WIDTH-1:0];
         assign check_way_match[i] = (check_way_tag[i] == tag_tag);
         assign check_way_valid[i] = tag_way_out[i][TAGMEM_WAY_VALID];

         assign way_hit[i] = check_way_valid[i] & check_way_match[i];

         // Multiplex the way entries in the tag memory
         assign tag_din[(i+1)*TAGMEM_WAY_WIDTH-1:i*TAGMEM_WAY_WIDTH] = tag_way_in[i];
         assign tag_way_out[i] = tag_dout[(i+1)*TAGMEM_WAY_WIDTH-1:i*TAGMEM_WAY_WIDTH];

	 if (OPTION_DCACHE_SNOOP != "NONE") begin
	    // The same for the snoop tag memory
            assign snoop_way_out[i] = snoop_dout[(i+1)*TAGMEM_WAY_WIDTH-1:i*TAGMEM_WAY_WIDTH];

	    assign snoop_check_way_tag[i] = snoop_way_out[i][TAG_WIDTH-1:0];
	    assign snoop_check_way_match[i] = (snoop_check_way_tag[i] == snoop_tag);
	    assign snoop_check_way_valid[i] = snoop_way_out[i][TAGMEM_WAY_VALID];

	    assign snoop_way_hit[i] = snoop_check_way_valid[i] & snoop_check_way_match[i];
	 end
      end
   endgenerate

   assign hit = |way_hit;
   assign cache_hit_o = hit;

   assign snoop_hit = (OPTION_DCACHE_SNOOP != "NONE") &
		      |snoop_way_hit & snoop_check;

   integer w0;
   always @(*) begin
      cpu_dat_o = {OPTION_OPERAND_WIDTH{1'bx}};

      // Put correct way on the data port
      for (w0 = 0; w0 < OPTION_DCACHE_WAYS; w0 = w0 + 1) begin
         if (way_hit[w0] | (refill_hit & tag_save_lru[w0])) begin
            cpu_dat_o = way_dout[w0];
         end
      end
   end

   assign next_refill_adr = (OPTION_DCACHE_BLOCK_WIDTH == 5) ?
			    {refill_adr_i[31:5], refill_adr_i[4:0] + 5'd4} : // 32 byte
			    {refill_adr_i[31:4], refill_adr_i[3:0] + 4'd4};  // 16 byte

   assign refill_done_o = refill_done;
   assign refill_done = refill_valid[next_refill_adr[OPTION_DCACHE_BLOCK_WIDTH-1:2]];
   assign refill_hit = refill_valid_r[cpu_adr_match_i[OPTION_DCACHE_BLOCK_WIDTH-1:2]] &
		       cpu_adr_match_i[OPTION_DCACHE_LIMIT_WIDTH-1:
				       OPTION_DCACHE_BLOCK_WIDTH] ==
		       refill_adr_i[OPTION_DCACHE_LIMIT_WIDTH-1:
				    OPTION_DCACHE_BLOCK_WIDTH] &
		       refill & !write_pending;

   assign refill = (state == REFILL);
   assign read = (state == READ);
   assign write = (state == WRITE);

   assign refill_o = refill;

   assign refill_req_o = read & cpu_req_i & !hit & !write_pending & refill_allowed_i | refill;

   /*
    * SPR bus interface
    */

   // The SPR interface is used to invalidate the cache blocks. When
   // an invalidation is started, the respective entry in the tag
   // memory is cleared. When another transfer is in progress, the
   // handling is delayed until it is possible to serve it.
   //
   // The invalidation is acknowledged to the SPR bus, but the cycle
   // is terminated by the core. We therefore need to hold the
   // invalidate acknowledgement. Meanwhile we continuously write the
   // tag memory which is no problem.

   // Net that signals an acknowledgement
   reg invalidate_ack;

   // An invalidate request is either a block flush or a block invalidate
   assign invalidate = spr_bus_stb_i & spr_bus_we_i &
		       (spr_bus_addr_i == `OR1K_SPR_DCBFR_ADDR |
			spr_bus_addr_i == `OR1K_SPR_DCBIR_ADDR);

   // Acknowledge to the SPR bus.
   assign spr_bus_ack_o = invalidate_ack;

   /*
    * Cache FSM
    * Starts in IDLE.
    * State changes between READ and WRITE happens cpu_we_i is asserted or not.
    * cpu_we_i is in sync with cpu_adr_i, so that means that it's the
    * *upcoming* write that it is indicating. It only toggles for one cycle,
    * so if we are busy doing something else when this signal comes
    * (i.e. refilling) we assert the write_pending signal.
    * cpu_req_i is in sync with cpu_adr_match_i, so it can be used to
    * determined if a cache hit should cause a refill or if a write should
    * really be executed.
    */
   integer w1;
   always @(posedge clk `OR_ASYNC_RST) begin
      if (rst) begin
	 state <= IDLE;
	 write_pending <= 0;
      end else if(dc_dbus_err_i) begin
	 state <= IDLE;
	 write_pending <= 0;
      end else begin
	 if (cpu_we_i)
	   write_pending <= 1;
	 else if (!cpu_req_i)
	   write_pending <= 0;

	 refill_valid_r <= refill_valid;

	 if (snoop_valid_i) begin
	    //
	    // If there is a snoop event, we need to store this
	    // information. This happens independent of whether we
	    // have a snoop tag memory or not.
	    //
	    snoop_check <= 1;
	    snoop_windex <= snoop_index;
	    snoop_tag <= snoop_adr_i[OPTION_DCACHE_LIMIT_WIDTH-1:WAY_WIDTH];
	 end else begin
	    snoop_check <= 0;
	 end

	 case (state)
	   IDLE: begin
	      if (invalidate) begin
		 // If there is an invalidation request
		 //
		 // Store address in invalidate_adr that is muxed to the tag
		 // memory write address
		 invalidate_adr <= spr_bus_dat_i[WAY_WIDTH-1:OPTION_DCACHE_BLOCK_WIDTH];

		 // Change to invalidate state that actually accesses
		 // the tag memory
		 state <= INVALIDATE;
	      end else if (cpu_we_i | write_pending)
		state <= WRITE;
	      else if (cpu_req_i)
		state <= READ;
	   end

	   READ: begin
	      if (dc_access_i | cpu_we_i & dc_enable_i) begin
		 if (cpu_we_i | write_pending) begin
		    state <= WRITE;
		 end else if (!hit & cpu_req_i & refill_allowed_i) begin
		    refill_valid <= 0;
		    refill_valid_r <= 0;

		    // Store the LRU information for correct replacement
                    // on refill. Always one when only one way.
                    tag_save_lru <= (OPTION_DCACHE_WAYS==1) | current_lru;

		    for (w1 = 0; w1 < OPTION_DCACHE_WAYS; w1 = w1 + 1) begin
		       tag_way_save[w1] <= tag_way_out[w1];
		    end

		    state <= REFILL;
		 end else if (invalidate) begin
		    state <= IDLE;
		 end
	      end else if (!dc_enable_i | invalidate) begin
		 state <= IDLE;
	      end
	   end

	   REFILL: begin
	      if (refill_we_i) begin
		 refill_valid[refill_adr_i[OPTION_DCACHE_BLOCK_WIDTH-1:2]] <= 1;

		 if (refill_done)
		   state <= IDLE;
	      end
	      // Abort refill on snoop-hit
	      // TODO: only abort on snoop-hits to refill address
	      if (snoop_hit) begin
		 refill_valid <= 0;
		 refill_valid_r <= 0;
		 state <= IDLE;
	      end
	   end

	   WRITE: begin
	      if ((!dc_access_i | !cpu_req_i | !cpu_we_i) & !snoop_hit) begin
		 write_pending <= 0;
		 state <= IDLE;
	      end
	   end

	   INVALIDATE: begin
	      if (cpu_we_i) begin
		 // If we get a write while we are in invalidate its because
		 // We have already acked the invalidate and the control unit
		 // has moved on.  So start the write as if we were in READ
		 // or idle.
		 state <= WRITE;
	      end else if (invalidate) begin
		 // Store address in invalidate_adr that is muxed to the tag
		 // memory write address
		 invalidate_adr <= spr_bus_dat_i[WAY_WIDTH-1:OPTION_DCACHE_BLOCK_WIDTH];

		 state <= INVALIDATE;
	      end else begin
		 state <= IDLE;
	      end
	   end

	   default:
	     state <= IDLE;
	 endcase
      end
   end

   //
   // This is the combinational part of the state machine that
   // interfaces the tag and way memories.
   //
   integer w2;
   always @(*) begin
      // Default is to keep data, don't write and don't access
      tag_lru_in = tag_lru_out;
      for (w2 = 0; w2 < OPTION_DCACHE_WAYS; w2 = w2 + 1) begin
         tag_way_in[w2] = tag_way_out[w2];
      end

      tag_we = 1'b0;
      way_we = {(OPTION_DCACHE_WAYS){1'b0}};

      access = {(OPTION_DCACHE_WAYS){1'b0}};

      way_wr_dat = refill_dat_i;

      // The default is (of course) not to acknowledge the invalidate
      invalidate_ack = 1'b0;

      if (snoop_hit) begin
	 // This is the write access
	 tag_we = 1'b1;
	 tag_windex = snoop_windex;
	 for (w2 = 0; w2 < OPTION_DCACHE_WAYS; w2 = w2 + 1) begin
	    if (snoop_way_hit[w2]) begin
	       tag_way_in[w2] = 0;
	    end else begin
	       tag_way_in[w2] = snoop_way_out[w2];
	    end
	 end
      end else begin
	 //
	 // The tag mem is written during reads and writes to write
	 // the lru info and during refill and invalidate.
	 //
	 tag_windex = read | write ?
		      cpu_adr_match_i[WAY_WIDTH-1:OPTION_DCACHE_BLOCK_WIDTH] :
		      (state == INVALIDATE) ? invalidate_adr :
		      refill_adr_i[WAY_WIDTH-1:OPTION_DCACHE_BLOCK_WIDTH];

	 case (state)
	   READ: begin
	      if (hit & cpu_req_i) begin
		 //
		 // We got a hit. The LRU module gets the access
		 // information. Depending on this we update the LRU
		 // history in the tag.
		 //
		 access = way_hit;

		 // This is the updated LRU history after hit
		 tag_lru_in = next_lru_history;

		 tag_we = 1'b1;
	      end
	   end

	   WRITE: begin
	      way_wr_dat = cpu_dat_i;
	      if (hit & cpu_req_i) begin
		 /* Mux cache output with write data */
		 if (!cpu_bsel_i[3])
		   way_wr_dat[31:24] = cpu_dat_o[31:24];
		 if (!cpu_bsel_i[2])
		   way_wr_dat[23:16] = cpu_dat_o[23:16];
		 if (!cpu_bsel_i[1])
		   way_wr_dat[15:8] = cpu_dat_o[15:8];
		 if (!cpu_bsel_i[0])
		   way_wr_dat[7:0] = cpu_dat_o[7:0];

		 // Only write data to way ram if we have a valid cacheline
		 way_we = way_hit;

		 tag_lru_in = next_lru_history;

		 tag_we = 1'b1;
	      end
	   end

	   REFILL: begin
	      if (refill_we_i) begin
		 //
		 // Write the data to the way that is replaced (which is
		 // the LRU)
		 //
		 way_we = tag_save_lru;

		 // Access pattern
		 access = tag_save_lru;

		 /* Invalidate the way on the first write */
		 if (refill_valid == 0) begin
		    for (w2 = 0; w2 < OPTION_DCACHE_WAYS; w2 = w2 + 1) begin
                       if (tag_save_lru[w2]) begin
			  tag_way_in[w2][TAGMEM_WAY_VALID] = 1'b0;
                       end
                    end

		    tag_we = 1'b1;
		 end

		 //
		 // After refill update the tag memory entry of the
		 // filled way with the LRU history, the tag and set
		 // valid to 1.
		 //
		 if (refill_done) begin
		    for (w2 = 0; w2 < OPTION_DCACHE_WAYS; w2 = w2 + 1) begin
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
	      invalidate_ack = 1'b1;

	      // Lazy invalidation, invalidate everything that matches tag address
              tag_lru_in = 0;
              for (w2 = 0; w2 < OPTION_DCACHE_WAYS; w2 = w2 + 1) begin
		 tag_way_in[w2] = 0;
              end

	      tag_we = 1'b1;
	   end

	   default: begin
	   end
	 endcase
      end
   end

   generate
      for (i = 0; i < OPTION_DCACHE_WAYS; i=i+1) begin : way_memories
	 mor1kx_simple_dpram_sclk
	       #(
		 .ADDR_WIDTH(WAY_WIDTH-2),
		 .DATA_WIDTH(OPTION_OPERAND_WIDTH),
		 .ENABLE_BYPASS(1)
		 )
	 way_data_ram
	       (
		// Outputs
		.dout			(way_dout[i]),
		// Inputs
		.clk			(clk),
		.raddr			(way_raddr[i][WAY_WIDTH-3:0]),
		.re			(1'b1),
		.waddr			(way_waddr[i][WAY_WIDTH-3:0]),
		.we			(way_we[i]),
		.din			(way_din[i][31:0]));

      end

      if (OPTION_DCACHE_WAYS >= 2) begin : gen_u_lru
         mor1kx_cache_lru
           #(.NUMWAYS(OPTION_DCACHE_WAYS))
         u_lru(
	       // Outputs
	       .update			(next_lru_history),	 // Templated
	       .lru_pre			(current_lru),		 // Templated
	       .lru_post		(),			 // Templated
	       // Inputs
	       .current			(current_lru_history),	 // Templated
	       .access			(access));		 // Templated
      end // if (OPTION_DCACHE_WAYS >= 2)
   endgenerate

   mor1kx_simple_dpram_sclk
     #(
       .ADDR_WIDTH(OPTION_DCACHE_SET_WIDTH),
       .DATA_WIDTH(TAGMEM_WIDTH),
       .ENABLE_BYPASS(OPTION_DCACHE_SNOOP != "NONE")
     )
   tag_ram
     (
      // Outputs
      .dout				(tag_dout[TAGMEM_WIDTH-1:0]),
      // Inputs
      .clk				(clk),
      .raddr				(tag_rindex),
      .re				(1'b1),
      .waddr				(tag_windex),
      .we				(tag_we),
      .din				(tag_din));

generate
if (OPTION_DCACHE_SNOOP != "NONE") begin
   mor1kx_simple_dpram_sclk
     #(
       .ADDR_WIDTH(OPTION_DCACHE_SET_WIDTH),
       .DATA_WIDTH(TAGMEM_WIDTH),
       .ENABLE_BYPASS(1)
       )
   snoop_tag_ram
     (
      // Outputs
      .dout			(snoop_dout[TAGMEM_WIDTH-1:0]),
      // Inputs
      .clk			(clk),
      .raddr			(snoop_index),
      .re			(1'b1),
      .waddr			(tag_windex),
      .we			(tag_we),
      .din			(tag_din));
end
endgenerate


/*----------------Formal Checking-----------------*/

`ifdef FORMAL

`ifdef DCACHE
`define ASSUME assume
`else
`define ASSUME assert
`endif

   wire [WAY_WIDTH-OPTION_DCACHE_BLOCK_WIDTH-1:0] f_cpu_adr;
   reg f_past_valid;
   initial f_past_valid = 1'b0;
   initial assume (rst);

   assign f_cpu_adr = cpu_adr_i[WAY_WIDTH-1:OPTION_DCACHE_BLOCK_WIDTH];

   always @(posedge clk)
      f_past_valid <= 1'b1;
   always @(*)
      if (!f_past_valid)
	 assume (rst);

//-----------Assumptions on Inputs-----------

   always @(posedge clk) begin
      if (cpu_req_i)
	 `ASSUME (dc_access_i);

      if (spr_bus_we_i)
	 `ASSUME (spr_bus_stb_i);

      // We cannot overlap read/write with flushes
      `ASSUME ($onehot0({cpu_req_i, spr_bus_stb_i}));

      // Assert to ensure induction doesn't enter a state where
      // dout and memory register feedback loop doesn't start out
      // of sync.  This is kind of a bug, but dcache should only
      // be used if properly initialized by flushing all dcache entries
      // which will avoid this case.
      if (f_past_valid &&
	  state == READ && $stable(state) &&
	  $past(f_cpu_adr) == $past(f_cpu_adr,2))
	 a1_no_register_feedback: assert ($stable(tag_dout[TAG_LRU_LSB-1:0]));
   end

//---------Tests are only valid after setup

`ifdef DCACHE
   localparam F_COUNT_WIDTH	= 5;
   localparam F_COUNT_MSB	= F_COUNT_WIDTH-1;
   localparam F_COUNT_START	= {1'b0,{(F_COUNT_WIDTH-1){1'b1}}};
   localparam F_COUNT_RESET	= {F_COUNT_WIDTH{1'b1}};

   (* anyconst *) wire [OPTION_OPERAND_WIDTH-1:0] f_addr;
   wire [OPTION_DCACHE_BLOCK_WIDTH-3:0] f_cacheline_idx;
   wire				f_cpu_addr_here;
   wire				f_spr_addr_here;

   reg [F_COUNT_WIDTH-1:0]	f_op_count;
   reg				f_write_pending;
   reg				f_read_pending;
   reg				f_flush_pending;
   reg				f_write_complete;
   reg				f_read_complete;
   reg				f_flush_complete;
   wire [2:0]			f_pending;

   assign f_cacheline_idx = f_addr[OPTION_DCACHE_BLOCK_WIDTH-1:2];
   assign f_cpu_addr_here = f_addr[OPTION_OPERAND_WIDTH-1:OPTION_DCACHE_BLOCK_WIDTH] ==
			    cpu_adr_i[OPTION_OPERAND_WIDTH-1:OPTION_DCACHE_BLOCK_WIDTH];
   assign f_spr_addr_here = f_addr[OPTION_OPERAND_WIDTH-1:OPTION_DCACHE_BLOCK_WIDTH] ==
			    spr_bus_dat_i[OPTION_OPERAND_WIDTH-1:OPTION_DCACHE_BLOCK_WIDTH];

   assign f_pending = {f_write_pending, f_read_pending, f_flush_pending};

   // Basic cases we need to help simulate
   //   1. Cache invalidate
   //   2. Read
   //   3. Write
   //
   // 1, 2 and 3 cannot happen at the same time.
   // Read and Write are only possible after invalidation.
   // Read may trigger a refill.

   // Used to confirm invalidation/read/write complete
   initial f_op_count = {F_COUNT_WIDTH{1'b1}};

   initial f_flush_pending = 0;
   initial f_write_pending = 0;
   initial f_read_pending = 0;
   initial f_flush_complete = 0;
   initial f_write_complete = 0;
   initial f_read_complete = 0;

   always @(posedge clk) begin
      // Don't block out refill when testing DCACHE
      assume (refill_allowed_i);

      assume ($past(cpu_adr_i) == cpu_adr_match_i);

      // Request lags write by 1 clock cycle, not always true
      // might be more, but helps with testing DCACHE
      if ($past(cpu_we_i))
	 assume (cpu_req_i);

      if (|f_pending)
	 assume (!cpu_we_i);

      if (f_flush_pending) begin
	 assume ($stable(spr_bus_addr_i));
	 assume ($stable(spr_bus_we_i));
	 assume ($stable(spr_bus_stb_i));
	 assume ($stable(spr_bus_dat_i));
      end else if (f_read_pending) begin
	 assume ($stable(cpu_req_i));
	 assume ($stable(cpu_adr_match_i));
	 assume ($stable(cpu_bsel_i));
      end else if (f_write_pending) begin
	 assume ($stable(cpu_adr_i));
	 assume ($stable(cpu_bsel_i));
      end

      a0_one_op_pending: assert ($onehot0(f_pending));

      // If f_op_count has MSB set all bits are set in reset state
      if (f_op_count[F_COUNT_MSB])
	 assert (&f_op_count);

      // Induction helpers

      // If we have anything pending we must be counting
      if (|f_pending)
	 a1_count_if_pending: assert (f_op_count[F_COUNT_MSB] == 0);
      // And vice versa, if we are counting something should be pending
      if (f_op_count[F_COUNT_MSB] == 0)
	 a2_pending_if_counting: assert (|f_pending);
   end

   // Track pending operations
   always @(posedge clk) begin
      if (rst | dc_dbus_err_i) begin
	 f_write_pending <= 0;
	 f_flush_pending <= 0;
	 f_read_pending <= 0;
	 f_op_count <= F_COUNT_RESET;
      end else if (f_past_valid & f_op_count[F_COUNT_MSB]) begin
	 // If idle check if we can start a transaction
	 if (invalidate & !spr_bus_ack_o) begin
	    f_flush_pending <= 1;
	    f_op_count <= F_COUNT_START;
	 end else if (cpu_we_i | (write_pending & cpu_req_i)) begin
	    f_write_pending <= 1;
	    f_op_count <= F_COUNT_START;
	 end else if (cpu_req_i & !cpu_ack_o) begin
	    f_read_pending <= 1;
	    f_op_count <= F_COUNT_START;
	 end
      end else if (f_op_count == {F_COUNT_WIDTH{1'b0}}) begin
	 // If the counter expires check if we have anything pending
	 a1_flush_complete: assert (!f_flush_pending);
	 a2_write_complete: assert (!f_write_pending);
	 a3_read_complete: assert (!f_read_pending);

	 f_op_count <= F_COUNT_RESET;
      end else if (f_op_count <= F_COUNT_START)
	 // If we are in counding mode count
	 f_op_count <= f_op_count - 1;

      // Track completes
      if (f_past_valid & !f_op_count[F_COUNT_MSB] & f_op_count > 0) begin
	 // If we just get into write state assume complete
	 if (write) begin
	    f_write_pending <= 0;
	    f_op_count <= F_COUNT_RESET;
	    if (tag_we & f_cpu_addr_here)
	       f_write_complete <= 1;
	 end

	 if (f_flush_pending & spr_bus_ack_o) begin
	    f_flush_pending <= 0;
	    f_op_count <= F_COUNT_RESET;
	    if (f_spr_addr_here)
	       f_flush_complete <= 1;
	 end

	 if (cpu_ack_o) begin
	    f_read_pending <= 0;
	    f_op_count <= F_COUNT_RESET;
	    if (f_cpu_addr_here)
	       f_read_complete <= 1;
	 end
      end
   end

   // Simulate refill transactions when requested
   reg [OPTION_OPERAND_WIDTH-1:0]	f_refill_addr;
   reg					f_refill_we;

   initial f_refill_addr = 0;
   initial f_refill_we = 0;

   always @(posedge clk) begin
      assume (refill_we_i == f_refill_we);
      assume (refill_adr_i == f_refill_addr);

      if (f_refill_we & refill_req_o) begin
	 if (refill_done_o)
	    f_refill_we <= 0;
	 else
	    f_refill_addr <= f_refill_addr + 4;
      end else if (f_past_valid & refill_req_o) begin
	 f_refill_we <= 1;
	 f_refill_addr <= { cpu_adr_i[31:OPTION_DCACHE_BLOCK_WIDTH], {OPTION_DCACHE_BLOCK_WIDTH{1'b0}} };
      end else begin
	 f_refill_we <= 0;
	 f_refill_addr <= 0;
      end
   end

   always @(posedge clk) begin
      c0_cache_invalidate: cover(f_past_valid & f_flush_complete);
      c1_cache_read: cover(f_past_valid & f_read_complete);
      c2_cache_write: cover(f_past_valid & f_write_complete);
   end

`endif

   fspr_slave #(
       .OPTION_OPERAND_WIDTH(OPTION_OPERAND_WIDTH),
       .SLAVE("DCACHE")
       )
       u_f_dcache_slave (
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

`endif
endmodule
