// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Fabian Schuiki <fschuiki@iis.ee.ethz.ch>

/// A refiller for cache lines.
module snitch_icache_refill #(
    parameter snitch_icache_pkg::config_t CFG = '0
) (
    input  logic clk_i,
    input  logic rst_ni,

    input  logic [CFG.FETCH_AW-1:0]     in_req_addr_i,
    input  logic [CFG.PENDING_IW-1:0]   in_req_id_i,
    input  logic                        in_req_bypass_i,
    input  logic                        in_req_valid_i,
    output logic                        in_req_ready_o,

    output logic [CFG.LINE_WIDTH-1:0]   in_rsp_data_o,
    output logic                        in_rsp_error_o,
    output logic [CFG.PENDING_IW-1:0]   in_rsp_id_o,
    output logic                        in_rsp_bypass_o,
    output logic                        in_rsp_valid_o,
    input  logic                        in_rsp_ready_i,

    output logic [CFG.FILL_AW-1:0]      refill_qaddr_o,
    output logic [7:0]                  refill_qlen_o,
    output logic                        refill_qvalid_o,
    input  logic                        refill_qready_i,

    input  logic [CFG.FILL_DW-1:0]      refill_pdata_i,
    input  logic                        refill_perror_i,
    input  logic                        refill_plast_i,
    input  logic                        refill_pvalid_i,
    output logic                        refill_pready_o
);

    `ifndef SYNTHESIS
    initial assert(CFG != '0);
    `endif

    // How many response beats are necessary to refill one cache line.
    localparam BEATS_PER_REFILL = CFG.LINE_WIDTH >= CFG.FILL_DW ? CFG.LINE_WIDTH/CFG.FILL_DW : 1;

    // The response queue holds metadata for the issued requests in order.
    logic queue_full;
    logic queue_push;
    logic queue_pop;

    fifo_v3  #(
        .DEPTH      ( 4                ),
        .DATA_WIDTH ( CFG.PENDING_IW+1 )
    ) i_fifo_id_queue (
        .clk_i       ( clk_i                          ),
        .rst_ni      ( rst_ni                         ),
        .flush_i     ( 1'b0                           ),
        .testmode_i  ( 1'b0                           ),
        .full_o      ( queue_full                     ),
        .empty_o     (                                ),
        .usage_o     (                                ),
        .data_i      ( {in_req_bypass_i, in_req_id_i} ),
        .push_i      ( queue_push                     ),
        .data_o      ( {in_rsp_bypass_o, in_rsp_id_o} ),
        .pop_i       ( queue_pop                      )
    );

    // Accept incoming requests, push the ID into the queue, and issue the
    // corresponding request.
    assign refill_qaddr_o  = in_req_addr_i;
    assign refill_qlen_o   = $unsigned(BEATS_PER_REFILL-1);
    assign refill_qvalid_o = in_req_valid_i & ~queue_full;
    assign in_req_ready_o  = refill_qready_i & ~queue_full;
    assign queue_push      = refill_qvalid_o & refill_qready_i;

    // Assemble incoming responses if the cache line is wider than the bus data width.
    logic [CFG.LINE_WIDTH-1:0] response_data;

    if (CFG.LINE_WIDTH > CFG.FILL_DW) begin : g_data_concat
        always_ff @(posedge clk_i, negedge rst_ni) begin
            if (!rst_ni)
                response_data[CFG.LINE_WIDTH-CFG.FILL_DW-1:0] <= '0;
            else if (refill_pvalid_i && refill_pready_o)
                response_data[CFG.LINE_WIDTH-CFG.FILL_DW-1:0] <= response_data[CFG.LINE_WIDTH-1:CFG.FILL_DW];
        end
        assign response_data[CFG.LINE_WIDTH-1:CFG.LINE_WIDTH-CFG.FILL_DW] = refill_pdata_i;
    end else if (CFG.LINE_WIDTH < CFG.FILL_DW) begin : g_data_slice
        assign response_data = refill_pdata_i >> (in_req_addr_i[CFG.FILL_ALIGN-1:CFG.LINE_ALIGN] * CFG.LINE_WIDTH);
    end else begin : g_data_passthrough
        assign response_data = refill_pdata_i;
    end

    // Accept response beats. Upon the last beat, pop the ID off the queue
    // and return the response.
    always_comb begin : p_response
        in_rsp_data_o  = response_data;
        in_rsp_error_o = refill_perror_i;
        in_rsp_valid_o = 0;
        queue_pop      = 0;
        refill_pready_o  = 0;

        if (refill_pvalid_i) begin
            if (!refill_plast_i) begin
                refill_pready_o  = 1;
            end else begin
                in_rsp_valid_o = 1;
                if (in_rsp_ready_i) begin
                    refill_pready_o  = 1;
                    queue_pop      = 1;
                end
            end
        end
    end

endmodule
