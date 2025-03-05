// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Fabian Schuiki <fschuiki@iis.ee.ethz.ch>

module snitch_icache_handler #(
    parameter snitch_icache_pkg::config_t CFG = '0
)(
    input  logic clk_i,
    input  logic rst_ni,

    input  logic [CFG.FETCH_AW-1:0]      in_req_addr_i,
    input  logic [CFG.ID_WIDTH_REQ-1:0]  in_req_id_i,
    input  logic [CFG.SET_ALIGN-1:0]     in_req_set_i,
    input  logic                         in_req_hit_i,
    input  logic [CFG.LINE_WIDTH-1:0]    in_req_data_i,
    input  logic                         in_req_error_i,
    input  logic                         in_req_valid_i,
    output logic                         in_req_ready_o,

    output logic [CFG.LINE_WIDTH-1:0]    in_rsp_data_o,
    output logic                         in_rsp_error_o,
    output logic [CFG.ID_WIDTH_RESP-1:0] in_rsp_id_o,
    output logic                         in_rsp_valid_o,
    input  logic                         in_rsp_ready_i,

    output logic [CFG.COUNT_ALIGN-1:0]   write_addr_o,
    output logic [CFG.SET_ALIGN-1:0]     write_set_o,
    output logic [CFG.LINE_WIDTH-1:0]    write_data_o,
    output logic [CFG.TAG_WIDTH-1:0]     write_tag_o,
    output logic                         write_error_o,
    output logic                         write_valid_o,
    input  logic                         write_ready_i,

    output logic [CFG.FETCH_AW-1:0]      out_req_addr_o,
    output logic [CFG.PENDING_IW-1:0]    out_req_id_o,
    output logic                         out_req_valid_o,
    input  logic                         out_req_ready_i,

    input  logic [CFG.LINE_WIDTH-1:0]    out_rsp_data_i,
    input  logic                         out_rsp_error_i,
    input  logic [CFG.PENDING_IW-1:0]    out_rsp_id_i,
    input  logic                         out_rsp_valid_i,
    output logic                         out_rsp_ready_o
);

    `ifndef SYNTHESIS
    initial assert(CFG != '0);
    `endif

    // The table of pending refills holds the metadata of all refills that are
    // currently in flight. The table has a push and a pop interfaces. The push
    // interface is used to mark entries as valid and update the mask of request
    // IDs that the refill will serve. The pop interface is used to read a value
    // from the table and clear its valid flag.
    typedef struct packed {
        logic valid;
        logic [CFG.FETCH_AW-1:0] addr;
        logic [CFG.ID_WIDTH_RESP-1:0] idmask; // mask of incoming ids
    } pending_t;
    pending_t pending_q [CFG.PENDING_COUNT];
    logic [CFG.PENDING_COUNT-1:0] pending_clr;
    logic [CFG.PENDING_COUNT-1:0] pending_set;

    logic [CFG.PENDING_IW-1:0]    push_index;
    logic                         push_init;   // reset the idmask instead of or'ing
    logic [CFG.FETCH_AW-1:0]      push_addr;
    logic [CFG.ID_WIDTH_RESP-1:0] push_idmask;
    logic                         push_enable;

    logic [CFG.PENDING_IW-1:0]    pop_index;
    logic [CFG.FETCH_AW-1:0]      pop_addr;
    logic [CFG.ID_WIDTH_RESP-1:0] pop_idmask;
    logic                         pop_enable;

    for (genvar i = 0; i < CFG.PENDING_COUNT; i++) begin : g_pending_row
        always_ff @(posedge clk_i, negedge rst_ni) begin
            if (!rst_ni)
                pending_q[i].valid <= 0;
            else if (pending_set[i] || pending_clr[i])
                pending_q[i].valid <= pending_set[i] && ~pending_clr[i];
        end

        always_ff @(posedge clk_i, negedge rst_ni) begin
            if (!rst_ni) begin
                pending_q[i].addr <= '0;
                pending_q[i].idmask <= '0;
            end else if (pending_set[i]) begin
                pending_q[i].addr <= push_addr;
                pending_q[i].idmask <= push_init ? push_idmask : push_idmask | pending_q[i].idmask;
            end
        end
    end

    // The bypass logic ensures that if a table entry is pushed and popped at
    // the same time, the pop is updated with the push information and the push
    // discarded.
    always_comb begin : p_pushpop_bypass
        pending_set = push_enable ? 'b1 << push_index : '0;
        pending_clr = pop_enable ? 'b1 << pop_index : '0;
        pop_addr = pending_q[pop_index].addr;
        pop_idmask = pending_q[pop_index].idmask;
        if (push_enable && pop_enable && push_index == pop_index) begin
            pop_addr = push_addr;
            pop_idmask |= push_idmask;
        end
    end

    // Determine the first available entry in the pending table, if any is free.
    logic [CFG.PENDING_COUNT-1:0] free_entries;
    logic free;
    logic [CFG.PENDING_IW-1:0] free_id;

    always_comb begin : p_free_id
        for (int i = 0; i < CFG.PENDING_COUNT; i++)
            free_entries[i] = ~pending_q[i].valid;
        free = |free_entries;
    end

    lzc #(.WIDTH(CFG.PENDING_COUNT)) i_lzc_free (
        .in_i    ( free_entries ),
        .cnt_o   ( free_id      ),
        .empty_o (              )
    );

    // Determine if the address of the incoming request coincides with any of
    // the entries in the pending table.
    logic [CFG.PENDING_COUNT-1:0] pending_matches;
    logic pending;
    logic [CFG.PENDING_IW-1:0] pending_id;

    always_comb begin : p_pending_id
        for (int i = 0; i < CFG.PENDING_COUNT; i++)
            pending_matches[i] = pending_q[i].valid && pending_q[i].addr == in_req_addr_i;
        pending = |pending_matches;
    end

    lzc #(.WIDTH(CFG.PENDING_COUNT)) i_lzc_pending (
        .in_i    ( pending_matches ),
        .cnt_o   ( pending_id      ),
        .empty_o (                 )
    );

    // The miss handler checks if the access into the cache was a hit. If yes,
    // the data is forwarded to the response handler. Otherwise the table of
    // pending refills is consulted to check if any refills are currently in
    // progress which cover the request. If not, a new refill request is issued
    // and the next free entry in the table allocated. Otherwise the existing
    // table entry is updated.
    logic [CFG.ID_WIDTH_RESP-1:0] hit_id;
    logic [CFG.LINE_WIDTH-1:0]    hit_data;
    logic                         hit_error;
    logic                         hit_valid;
    logic                         hit_ready;

    always_comb begin : p_miss_handler
        hit_valid = 0;
        hit_id    = 'b1 << in_req_id_i;
        hit_data  = in_req_data_i;
        hit_error = in_req_error_i;

        push_index  = free_id;
        push_init   = 0;
        push_addr   = in_req_addr_i;
        push_idmask = 'b1 << in_req_id_i;
        push_enable = 0;

        in_req_ready_o  = 1;

        out_req_addr_o  = in_req_addr_i;
        out_req_id_o    = free_id;
        out_req_valid_o = 0;

        if (in_req_valid_i) begin
            // The cache lookup was a hit.
            if (in_req_hit_i) begin
                hit_valid = 1;
                in_req_ready_o = hit_ready;

            // The cache lookup was a miss, but there is already a pending
            // refill that covers the line.
            end else if (pending) begin
                push_index  = pending_id;
                push_enable = 1;

            // The cache lookup was a miss, there is no pending refill, but
            // there are available entries in the table.
            end else if (free) begin
                out_req_addr_o  = in_req_addr_i;
                out_req_id_o    = free_id;
                out_req_valid_o = 1;
                in_req_ready_o  = out_req_ready_i;
                push_index      = free_id;
                push_init       = 1;
                push_enable     = out_req_ready_i;

            // The cache lookup was a miss, there is no pending refill, and
            // there is no room in the table for a new refill at the moment.
            end else begin
                in_req_ready_o = 0;
            end
        end
    end

    // The cache line eviction LFSR is responsible for picking a cache line for
    // replacement at random. Note that we assume that the entire cache is full,
    // so no empty cache lines are available. This is the common case since we
    // do not support flushing of the cache.
    logic [CFG.SET_ALIGN-1:0] evict_index;
    logic evict_enable;

    snitch_icache_lfsr #(CFG.SET_ALIGN) i_evict_lfsr (
        .clk_i    ( clk_i        ),
        .rst_ni   ( rst_ni       ),
        .value_o  ( evict_index  ),
        .enable_i ( evict_enable )
    );

    // The response handler deals with incoming refill responses. It queries and
    // clears the corresponding entry in the pending table, stores the data in
    // the cache via the `write` port, and returns the data to the appropriate
    // fetch ports via the `in_rsp` port. It also mixes the data of a cache hit
    // into the response stream.
    logic write_served_q;
    logic in_rsp_served_q;
    logic rsp_valid, rsp_ready;

    struct packed {
        logic sel;
        logic lock;
    } arb_q, arb_d;

    always_ff @(posedge clk_i, negedge rst_ni) begin
        if (!rst_ni)
            arb_q <= '0;
        else
            arb_q <= arb_d;
    end

    always_comb begin : p_response_handler
        pop_index  = out_rsp_id_i;
        pop_enable = 0;

        write_addr_o  = pop_addr >> CFG.LINE_ALIGN;
        write_set_o   = evict_index;
        write_data_o  = out_rsp_data_i;
        write_tag_o   = pop_addr >> (CFG.LINE_ALIGN + CFG.COUNT_ALIGN);
        write_error_o = out_rsp_error_i;
        write_valid_o = 0;

        in_rsp_data_o  = out_rsp_data_i;
        in_rsp_error_o = out_rsp_error_i;
        in_rsp_id_o    = pop_idmask;
        in_rsp_valid_o = 0;

        hit_ready       = 1;
        out_rsp_ready_o = 1;
        evict_enable    = 0;
        rsp_valid       = 0;
        rsp_ready       = 1;

        arb_d = arb_q;
        if (!arb_q.lock) begin
            if (hit_valid) begin
                arb_d.sel  = 0;
                arb_d.lock = 1;
            end else if (out_rsp_valid_i) begin
                arb_d.sel  = 1;
                arb_d.lock = 1;
            end else begin
                arb_d.sel  = 0;
                arb_d.lock = 0;
            end
        end

        // Cache hit data is pending.
        if (arb_d.sel == 0) begin
            if (hit_valid) begin
                out_rsp_ready_o = 0;
                in_rsp_data_o   = hit_data;
                in_rsp_error_o  = 0;
                in_rsp_id_o     = hit_id;
                in_rsp_valid_o  = 1;
                hit_ready = in_rsp_ready_i;
            end else hit_ready = 1;
            if (hit_ready) arb_d.lock = 0;

        // No cache hit is pending, but response data is available.
        end else if (arb_d.sel == 1) begin
            if (out_rsp_valid_i) begin
                rsp_valid       = 1;
                rsp_ready       = (in_rsp_ready_i || in_rsp_served_q) && (write_ready_i || write_served_q);
                write_valid_o   = 1 && ~write_served_q;
                in_rsp_valid_o  = 1 && ~in_rsp_served_q;
                pop_enable      = rsp_ready;
                out_rsp_ready_o = rsp_ready;
                evict_enable    = rsp_ready;
            end else rsp_ready = 1;
            if (rsp_ready) arb_d.lock = 0;
        end
    end

    always_ff @(posedge clk_i, negedge rst_ni) begin
        if (!rst_ni) begin
            write_served_q <= 0;
            in_rsp_served_q <= 0;
        end else begin
            write_served_q <= rsp_valid & ~rsp_ready & (write_served_q | write_ready_i);
            in_rsp_served_q <= rsp_valid & ~rsp_ready & (in_rsp_served_q | in_rsp_ready_i);
        end
    end

endmodule
