// Copyright 2018-2019 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51
//
// File:   axi_adapter.sv
// Author: Florian Zaruba <zarubaf@iis.ee.ethz.ch>
// Date:   1.8.2018
//
// Description: Manages communication with the AXI Bus

module snitch_axi_adapter #(
  parameter int unsigned WriteFIFODepth = 2,
  parameter int unsigned ReadFIFODepth = 2,
  parameter type addr_t = logic,
  parameter type data_t = logic,
  parameter type strb_t = logic,
  parameter type axi_mst_req_t  = logic,
  parameter type axi_mst_resp_t = logic
) (
  input  logic          clk_i,
  input  logic          rst_ni,
  // AXI port
  input  axi_mst_resp_t axi_resp_i,
  output axi_mst_req_t  axi_req_o,

  input  addr_t         slv_qaddr_i,
  input  logic          slv_qwrite_i,
  input  logic [3:0]    slv_qamo_i,
  input  data_t         slv_qdata_i,
  input  logic [2:0]    slv_qsize_i,
  input  strb_t         slv_qstrb_i,
  input  logic [7:0]    slv_qrlen_i,
  input  logic          slv_qvalid_i,
  output logic          slv_qready_o,
  output data_t         slv_pdata_o,
  output logic          slv_perror_o,
  output logic          slv_plast_o,
  output logic          slv_pvalid_o,
  input  logic          slv_pready_i
);

  localparam DataWidth     = $bits(data_t);
  localparam StrbWidth     = $bits(strb_t);
  localparam SlvByteOffset = $clog2($bits(strb_t));
  localparam AxiByteOffset = $clog2($bits(axi_req_o.w.strb));

  typedef enum logic [3:0] {
    AMONone = 4'h0,
    AMOSwap = 4'h1,
    AMOAdd  = 4'h2,
    AMOAnd  = 4'h3,
    AMOOr   = 4'h4,
    AMOXor  = 4'h5,
    AMOMax  = 4'h6,
    AMOMaxu = 4'h7,
    AMOMin  = 4'h8,
    AMOMinu = 4'h9,
    AMOLR   = 4'hA,
    AMOSC   = 4'hB
  } amo_op_t;

  typedef struct packed {
    data_t data;
    strb_t strb;
  } write_t;

  logic   write_full;
  logic   write_empty;
  logic   read_full;
  write_t write_data_in;
  write_t write_data_out;

  assign axi_req_o.aw.addr   = slv_qaddr_i;
  assign axi_req_o.aw.prot   = 3'b0;
  assign axi_req_o.aw.region = 4'b0;
  assign axi_req_o.aw.size   = slv_qsize_i;
  assign axi_req_o.aw.len    = '0;
  assign axi_req_o.aw.burst  = axi_pkg::BURST_INCR;
  assign axi_req_o.aw.lock   = 1'b0;
  assign axi_req_o.aw.cache  = axi_pkg::CACHE_MODIFIABLE;
  assign axi_req_o.aw.qos    = 4'b0;
  assign axi_req_o.aw.id     = '0;
  assign axi_req_o.aw.user   = '0;
  assign axi_req_o.aw_valid  = ~write_full & slv_qvalid_i & slv_qwrite_i;

  always_comb begin
    write_data_in.data = slv_qdata_i;
    write_data_in.strb = slv_qstrb_i;
    unique case (amo_op_t'(slv_qamo_i))
      // RISC-V atops have a load semantic
      AMOSwap: axi_req_o.aw.atop  = {axi_pkg::ATOP_ATOMICLOAD, axi_pkg::ATOP_LITTLE_END, axi_pkg::ATOP_ATOMICSWAP};
      AMOAdd:  axi_req_o.aw.atop  = {axi_pkg::ATOP_ATOMICLOAD, axi_pkg::ATOP_LITTLE_END, axi_pkg::ATOP_ADD};
      AMOAnd:  begin
        // in this case we need to invert the data to get a "CLR"
        write_data_in.data = ~slv_qdata_i;
        axi_req_o.aw.atop  = {axi_pkg::ATOP_ATOMICLOAD, axi_pkg::ATOP_LITTLE_END, axi_pkg::ATOP_CLR};
      end
      AMOOr:   axi_req_o.aw.atop  = {axi_pkg::ATOP_ATOMICLOAD, axi_pkg::ATOP_LITTLE_END, axi_pkg::ATOP_SET};
      AMOXor:  axi_req_o.aw.atop  = {axi_pkg::ATOP_ATOMICLOAD, axi_pkg::ATOP_LITTLE_END, axi_pkg::ATOP_EOR};
      AMOMax:  axi_req_o.aw.atop  = {axi_pkg::ATOP_ATOMICLOAD, axi_pkg::ATOP_LITTLE_END, axi_pkg::ATOP_SMAX};
      AMOMaxu: axi_req_o.aw.atop  = {axi_pkg::ATOP_ATOMICLOAD, axi_pkg::ATOP_LITTLE_END, axi_pkg::ATOP_UMAX};
      AMOMin:  axi_req_o.aw.atop  = {axi_pkg::ATOP_ATOMICLOAD, axi_pkg::ATOP_LITTLE_END, axi_pkg::ATOP_SMIN};
      AMOMinu: axi_req_o.aw.atop  = {axi_pkg::ATOP_ATOMICLOAD, axi_pkg::ATOP_LITTLE_END, axi_pkg::ATOP_UMIN};
      default: axi_req_o.aw.atop = '0;
    endcase
  end

  localparam int unsigned ShiftWidth = (SlvByteOffset == AxiByteOffset) ? 1 : AxiByteOffset - SlvByteOffset;
  typedef logic [ShiftWidth-1:0] shift_t;
  typedef struct packed {
    write_t data;
    shift_t shift;
  } write_ext_t;

  if (SlvByteOffset == AxiByteOffset) begin : gen_w_data
    // Write
    fifo_v3 #(
      .DEPTH      ( WriteFIFODepth                             ),
      .dtype      ( write_t                                    )
    ) i_fifo_w_data (
      .clk_i,
      .rst_ni,
      .flush_i    ( 1'b0                                       ),
      .testmode_i ( 1'b0                                       ),
      .full_o     ( write_full                                 ),
      .empty_o    ( write_empty                                ),
      .usage_o    ( /* NC */                                   ),
      .data_i     ( write_data_in                              ),
      .push_i     ( slv_qvalid_i & slv_qready_o & slv_qwrite_i ),
      .data_o     ( write_data_out                             ),
      .pop_i      ( axi_req_o.w_valid & axi_resp_i.w_ready     )
    );
    assign axi_req_o.w.data = write_data_out.data;
    assign axi_req_o.w.strb = write_data_out.strb;

    // Read
    assign read_full   = 1'b0;
    assign slv_pdata_o = axi_resp_i.r.data;
  end else begin  : gen_w_data
    // Write
    write_ext_t write_data_ext_in, write_data_ext_out;

    fifo_v3 #(
      .DEPTH      ( WriteFIFODepth                             ),
      .dtype      ( write_ext_t                                )
    ) i_fifo_w_data (
      .clk_i,
      .rst_ni,
      .flush_i    ( 1'b0                                       ),
      .testmode_i ( 1'b0                                       ),
      .full_o     ( write_full                                 ),
      .empty_o    ( write_empty                                ),
      .usage_o    ( /* NC */                                   ),
      .data_i     ( write_data_ext_in                          ),
      .push_i     ( slv_qvalid_i & slv_qready_o & slv_qwrite_i ),
      .data_o     ( write_data_ext_out                         ),
      .pop_i      ( axi_req_o.w_valid & axi_resp_i.w_ready     )
    );

    assign write_data_ext_in.data  = write_data_in;
    assign write_data_ext_in.shift = slv_qaddr_i[AxiByteOffset-1:SlvByteOffset];
    assign axi_req_o.w.data  = {'0, write_data_ext_out.data.data} << ($bits(data_t) * write_data_ext_out.shift);
    assign axi_req_o.w.strb  = {'0, write_data_ext_out.data.strb} << ($bits(strb_t) * write_data_ext_out.shift);

    // Read
    shift_t read_shift;

    fifo_v3 #(
      .DEPTH      ( ReadFIFODepth                               ),
      .DATA_WIDTH ( AxiByteOffset-SlvByteOffset                 )
    ) i_fifo_r_shift (
      .clk_i,
      .rst_ni,
      .flush_i    ( 1'b0                                        ),
      .testmode_i ( 1'b0                                        ),
      .full_o     ( read_full                                   ),
      .empty_o    ( /* NC */                                    ),
      .usage_o    ( /* NC */                                    ),
      .data_i     ( slv_qaddr_i[AxiByteOffset-1:SlvByteOffset]  ),
      .push_i     ( slv_qvalid_i & slv_qready_o & ~slv_qwrite_i ),
      .data_o     ( read_shift                                  ),
      .pop_i      ( axi_resp_i.r_valid & slv_pready_i           )
    );

    assign slv_pdata_o       = axi_resp_i.r.data >> ($bits(data_t) * read_shift);
  end
  assign axi_req_o.w.last    = 1'b1;
  assign axi_req_o.w.user    = '0;
  assign axi_req_o.w_valid   = ~write_empty;

  assign axi_req_o.b_ready   = 1'b1;

  assign axi_req_o.ar.addr   = slv_qaddr_i;
  assign axi_req_o.ar.prot   = 3'b0;
  assign axi_req_o.ar.region = 4'b0;
  assign axi_req_o.ar.size   = slv_qsize_i;
  assign axi_req_o.ar.len    = slv_qrlen_i;
  assign axi_req_o.ar.burst  = axi_pkg::BURST_INCR;
  assign axi_req_o.ar.lock   = 1'b0;
  assign axi_req_o.ar.cache  = axi_pkg::CACHE_MODIFIABLE;
  assign axi_req_o.ar.qos    = 4'b0;
  assign axi_req_o.ar.id     = '0;
  assign axi_req_o.ar.user   = '0;
  assign axi_req_o.ar_valid  = ~read_full & slv_qvalid_i & ~slv_qwrite_i;

  assign slv_perror_o      = (axi_resp_i.r.resp inside {axi_pkg::RESP_EXOKAY, axi_pkg::RESP_OKAY}) ? 1'b0 : 1'b1;
  assign slv_plast_o       = axi_resp_i.r.last;
  assign slv_pvalid_o      = axi_resp_i.r_valid;
  assign axi_req_o.r_ready = slv_pready_i;

  assign slv_qready_o = (axi_resp_i.ar_ready & axi_req_o.ar_valid)
                      | (axi_resp_i.aw_ready & axi_req_o.aw_valid);

  `ifndef VERILATOR
  // pragma translate_off
  hot_one : assert property (
    @(posedge clk_i) disable iff (!rst_ni) (slv_qvalid_i & slv_qwrite_i & slv_qready_o) |-> (slv_qrlen_i == 0))
      else $warning("Bursts are not supported for write transactions");
  // pragma translate_on
  `endif
endmodule
