// Copyright 2021 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51


module mempool_tile
  import mempool_pkg::*;
  import cf_math_pkg::idx_width;
#(
  // TCDM
  parameter addr_t       TCDMBaseAddr = 32'b0,
  // Boot address
  parameter logic [31:0] BootAddr     = 32'h0000_1000,
  // Dependent parameters. DO NOT CHANGE.
  parameter int unsigned NumCaches    = NumCoresPerTile / NumCoresPerCache
) (
  // Clock and reset
  input  logic                                        clk_i,
  input  logic                                        rst_ni,
  // Scan chain
  input  logic                                        scan_enable_i,
  input  logic                                        scan_data_i,
  output logic                                        scan_data_o,
  // Tile ID
  input  logic              [idx_width(NumTiles)-1:0] tile_id_i,
  // TCDM Master interfaces
  output tcdm_master_req_t  [NumGroups-1:0]           tcdm_master_req_o,
  output logic              [NumGroups-1:0]           tcdm_master_req_valid_o,
  input  logic              [NumGroups-1:0]           tcdm_master_req_ready_i,
  input  tcdm_master_resp_t [NumGroups-1:0]           tcdm_master_resp_i,
  input  logic              [NumGroups-1:0]           tcdm_master_resp_valid_i,
  output logic              [NumGroups-1:0]           tcdm_master_resp_ready_o,
  // TCDM slave interfaces
  input  tcdm_slave_req_t   [NumGroups-1:0]           tcdm_slave_req_i,
  input  logic              [NumGroups-1:0]           tcdm_slave_req_valid_i,
  output logic              [NumGroups-1:0]           tcdm_slave_req_ready_o,
  output tcdm_slave_resp_t  [NumGroups-1:0]           tcdm_slave_resp_o,
  output logic              [NumGroups-1:0]           tcdm_slave_resp_valid_o,
  input  logic              [NumGroups-1:0]           tcdm_slave_resp_ready_i,
  // AXI Interface
  output axi_tile_req_t                               axi_mst_req_o,
  input  axi_tile_resp_t                              axi_mst_resp_i,
  // Wake up interface
  input  logic              [NumCoresPerTile-1:0]     wake_up_i
);

  /****************
   *   Includes   *
   ****************/
//the below line includes register definitions --> not sure why this is required, why do we have such a file ?
  `include "common_cells/registers.svh"

  /*****************
   *  Definitions  *
   *****************/

  import snitch_pkg::dreq_t;
  import snitch_pkg::dresp_t;

  typedef logic [idx_width(NumGroups)-1:0] group_id_t;

  // TCDM Memory Region
  localparam addr_t TCDMSize = NumBanks * TCDMSizePerBank;
  localparam addr_t TCDMMask = ~(TCDMSize - 1);

  // Local interconnect address width
  typedef logic [idx_width(NumCoresPerTile + NumGroups)-1:0] local_req_interco_addr_t;

  // Group ID
  logic [idx_width(NumGroups)-1:0] group_id;
  if (NumGroups != 1) begin: gen_group_id
    assign group_id = tile_id_i[$clog2(NumTiles)-1 -: $clog2(NumGroups)];
  end else begin: gen_group_id
    assign group_id = '0;
  end: gen_group_id

  /***********
   *  Cores  *
   ***********/

  // Instruction interfaces
  addr_t [NumCaches-1:0][NumCoresPerCache-1:0] snitch_inst_addr;
  data_t [NumCaches-1:0][NumCoresPerCache-1:0] snitch_inst_data;
  logic  [NumCaches-1:0][NumCoresPerCache-1:0] snitch_inst_valid;
  logic  [NumCaches-1:0][NumCoresPerCache-1:0] snitch_inst_ready;

  // Data interfaces
  addr_t    [NumCoresPerTile-1:0] snitch_data_qaddr;
  logic     [NumCoresPerTile-1:0] snitch_data_qwrite;
  amo_t     [NumCoresPerTile-1:0] snitch_data_qamo;
  data_t    [NumCoresPerTile-1:0] snitch_data_qdata;
  strb_t    [NumCoresPerTile-1:0] snitch_data_qstrb;
  meta_id_t [NumCoresPerTile-1:0] snitch_data_qid;
  logic     [NumCoresPerTile-1:0] snitch_data_qvalid;
  logic     [NumCoresPerTile-1:0] snitch_data_qready;
  data_t    [NumCoresPerTile-1:0] snitch_data_pdata;
  logic     [NumCoresPerTile-1:0] snitch_data_perror;
  meta_id_t [NumCoresPerTile-1:0] snitch_data_pid;
  logic     [NumCoresPerTile-1:0] snitch_data_pvalid;
  logic     [NumCoresPerTile-1:0] snitch_data_pready;

  for (genvar c = 0; unsigned'(c) < NumCoresPerTile; c++) begin: gen_cores
    logic [31:0] hart_id;
    assign hart_id = {unsigned'(tile_id_i), c[idx_width(NumCoresPerTile)-1:0]};

    if (!TrafficGeneration) begin: gen_mempool_cc
      mempool_cc #(
        .BootAddr (BootAddr)
      ) riscv_core (
        .clk_i         (clk_i                                                    ),
        .rst_i         (!rst_ni                                                  ),
        .hart_id_i     (hart_id                                                  ),
        // IMEM Port
        .inst_addr_o   (snitch_inst_addr[c/NumCoresPerCache][c%NumCoresPerCache] ),
        .inst_data_i   (snitch_inst_data[c/NumCoresPerCache][c%NumCoresPerCache] ),
        .inst_valid_o  (snitch_inst_valid[c/NumCoresPerCache][c%NumCoresPerCache]),
        .inst_ready_i  (snitch_inst_ready[c/NumCoresPerCache][c%NumCoresPerCache]),
        // Data Ports
        .data_qaddr_o  (snitch_data_qaddr[c]                                     ),
        .data_qwrite_o (snitch_data_qwrite[c]                                    ),
        .data_qamo_o   (snitch_data_qamo[c]                                      ),
        .data_qdata_o  (snitch_data_qdata[c]                                     ),
        .data_qstrb_o  (snitch_data_qstrb[c]                                     ),
        .data_qid_o    (snitch_data_qid[c]                                       ),
        .data_qvalid_o (snitch_data_qvalid[c]                                    ),
        .data_qready_i (snitch_data_qready[c]                                    ),
        .data_pdata_i  (snitch_data_pdata[c]                                     ),
        .data_perror_i (snitch_data_perror[c]                                    ),
        .data_pid_i    (snitch_data_pid[c]                                       ),
        .data_pvalid_i (snitch_data_pvalid[c]                                    ),
        .data_pready_o (snitch_data_pready[c]                                    ),
        .wake_up_sync_i(wake_up_i[c]                                             ),
        // Core Events
        .core_events_o (/* Unused */                                             )
      );
    end else begin
      assign snitch_data_qaddr[c]                                      = '0;
      assign snitch_data_qwrite[c]                                     = '0;
      assign snitch_data_qamo[c]                                       = '0;
      assign snitch_data_qdata[c]                                      = '0;
      assign snitch_data_qstrb[c]                                      = '0;
      assign snitch_data_qid[c]                                        = '0;
      assign snitch_data_qvalid[c]                                     = '0;
      assign snitch_data_pready[c]                                     = '0;
      assign snitch_inst_addr[c/NumCoresPerCache][c%NumCoresPerCache]  = '0;
      assign snitch_inst_valid[c/NumCoresPerCache][c%NumCoresPerCache] = '0;
    end
  end

  /***********************
   *  Instruction Cache  *
   ***********************/
  // Instruction interface
  addr_t [NumCaches-1:0]                      refill_qaddr;
  logic  [NumCaches-1:0][7:0]                 refill_qlen;
  logic  [NumCaches-1:0]                      refill_qvalid;
  logic  [NumCaches-1:0]                      refill_qready;
  logic  [NumCaches-1:0][AxiDataWidth-1:0]    refill_pdata;
  logic  [NumCaches-1:0]                      refill_perror;
  logic  [NumCaches-1:0]                      refill_pvalid;
  logic  [NumCaches-1:0]                      refill_plast;
  logic  [NumCaches-1:0]                      refill_pready;

  for (genvar c = 0; unsigned'(c) < NumCaches; c++) begin: gen_caches
    snitch_icache #(
      .NR_FETCH_PORTS     (NumCoresPerCache                                    ),
      /// Cache Line Width
      .L0_LINE_COUNT      (4                                                   ),
      .LINE_WIDTH         (ICacheLineWidth                                     ),
      .LINE_COUNT         (ICacheSizeByte / (ICacheSets * ICacheLineWidth / 8) ),
      .SET_COUNT          (ICacheSets                                          ),
      .FETCH_AW           (AddrWidth                                           ),
      .FETCH_DW           (DataWidth                                           ),
      .FILL_AW            (AddrWidth                                           ),
      .FILL_DW            (AxiDataWidth                                        ),
      .L1_TAG_SCM         (1                                                   ),
      /// Make the early cache latch-based. This reduces latency at the cost of
      /// increased combinatorial path lengths and the hassle of having latches in
      /// the design.
      .EARLY_LATCH        (1                                                   ),
      .L0_EARLY_TAG_WIDTH (11                                                  ),
      .ISO_CROSSING       (0                                                   )
    ) i_snitch_icache (
      .clk_i                (clk_i                   ),
      .clk_d2_i             (clk_i                   ),
      .rst_ni               (rst_ni                  ),
      .enable_prefetching_i (snitch_inst_valid[c]    ),
      .icache_events_o      (/* Unused */            ),
      .flush_valid_i        (1'b0                    ),
      .flush_ready_o        (/* Unused */            ),
      .inst_addr_i          (snitch_inst_addr[c]     ),
      .inst_data_o          (snitch_inst_data[c]     ),
      .inst_cacheable_i     ({NumCoresPerCache{1'b1}}),
      .inst_valid_i         (snitch_inst_valid[c]    ),
      .inst_ready_o         (snitch_inst_ready[c]    ),
      .inst_error_o         (/* Unused */            ),
      .refill_qaddr_o       (refill_qaddr[c]         ),
      .refill_qlen_o        (refill_qlen[c]          ),
      .refill_qvalid_o      (refill_qvalid[c]        ),
      .refill_qready_i      (refill_qready[c]        ),
      .refill_pdata_i       (refill_pdata[c]         ),
      .refill_perror_i      (refill_perror[c]        ),
      .refill_pvalid_i      (refill_pvalid[c]        ),
      .refill_plast_i       (refill_plast[c]         ),
      .refill_pready_o      (refill_pready[c]        )
    );
  end

  /******************
   *  Memory Banks  *
   ******************/

  // Bank metadata
  typedef struct packed {
    local_req_interco_addr_t ini_addr;
    meta_id_t meta_id;
    tile_group_id_t tile_id;
    tile_core_id_t core_id;
  } bank_metadata_t;

  // Memory interfaces
  logic                    [NumBanksPerTile-1:0] bank_req_valid;
  logic                    [NumBanksPerTile-1:0] bank_req_ready;
  local_req_interco_addr_t [NumBanksPerTile-1:0] bank_req_ini_addr;
  tcdm_slave_req_t         [NumBanksPerTile-1:0] bank_req_payload;
  logic                    [NumBanksPerTile-1:0] bank_resp_valid;
  logic                    [NumBanksPerTile-1:0] bank_resp_ready;
  tcdm_slave_resp_t        [NumBanksPerTile-1:0] bank_resp_payload;
  local_req_interco_addr_t [NumBanksPerTile-1:0] bank_resp_ini_addr;

  for (genvar b = 0; unsigned'(b) < NumBanksPerTile; b++) begin: gen_banks
    bank_metadata_t meta_in;
    bank_metadata_t meta_out;
    logic req_valid;
    logic req_write;
    bank_addr_t req_addr;
    data_t req_wdata;
    data_t resp_rdata;
    strb_t req_be;

    // Un/Pack metadata
    assign meta_in = '{
      ini_addr  : bank_req_ini_addr[b],
      meta_id   : bank_req_payload[b].wdata.meta_id,
      core_id   : bank_req_payload[b].wdata.core_id,
      tile_id   : bank_req_payload[b].ini_addr
    };
    assign bank_resp_ini_addr[b]              = meta_out.ini_addr;
    assign bank_resp_payload[b].rdata.meta_id = meta_out.meta_id;
    assign bank_resp_payload[b].ini_addr      = meta_out.tile_id;
    assign bank_resp_payload[b].rdata.core_id = meta_out.core_id;
    assign bank_resp_payload[b].rdata.amo     = '0; // Don't care

    tcdm_adapter #(
      .AddrWidth  (TCDMAddrMemWidth),
      .DataWidth  (DataWidth       ),
      .metadata_t (bank_metadata_t ),
      .LrScEnable (LrScEnable      ),
      .RegisterAmo(1'b0            )
    ) i_tcdm_adapter (
      .clk_i       (clk_i                                                                       ),
      .rst_ni      (rst_ni                                                                      ),
      .in_valid_i  (bank_req_valid[b]                                                           ),
      .in_ready_o  (bank_req_ready[b]                                                           ),
      .in_address_i(bank_req_payload[b].tgt_addr[idx_width(NumBanksPerTile) +: TCDMAddrMemWidth]),
      .in_amo_i    (bank_req_payload[b].wdata.amo                                               ),
      .in_write_i  (bank_req_payload[b].wen                                                     ),
      .in_wdata_i  (bank_req_payload[b].wdata.data                                              ),
      .in_meta_i   (meta_in                                                                     ),
      .in_be_i     (bank_req_payload[b].be                                                      ),
      .in_valid_o  (bank_resp_valid[b]                                                          ),
      .in_ready_i  (bank_resp_ready[b]                                                          ),
      .in_rdata_o  (bank_resp_payload[b].rdata.data                                             ),
      .in_meta_o   (meta_out                                                                    ),
      .out_req_o   (req_valid                                                                   ),
      .out_add_o   (req_addr                                                                    ),
      .out_write_o (req_write                                                                   ),
      .out_wdata_o (req_wdata                                                                   ),
      .out_be_o    (req_be                                                                      ),
      .out_rdata_i (resp_rdata                                                                  )
    );

    // Bank
    tc_sram #(
      .DataWidth(DataWidth          ),
      .NumWords (2**TCDMAddrMemWidth),
      .NumPorts (1                  )
    ) mem_bank (
      .clk_i  (clk_i     ),
      .rst_ni (rst_ni    ),
      .req_i  (req_valid ),
      .we_i   (req_write ),
      .addr_i (req_addr  ),
      .wdata_i(req_wdata ),
      .be_i   (req_be    ),
      .rdata_o(resp_rdata)
    );
  end

  /***************
   *  Registers  *
   ***************/

  // These are required to break dependencies between request and response, establishing a correct
  // valid/ready handshake.
  tcdm_master_req_t  [NumGroups-1:0] prereg_tcdm_master_req;
  logic              [NumGroups-1:0] prereg_tcdm_master_req_valid;
  logic              [NumGroups-1:0] prereg_tcdm_master_req_ready;
  tcdm_slave_req_t   [NumGroups-1:0] postreg_tcdm_slave_req;
  logic              [NumGroups-1:0] postreg_tcdm_slave_req_valid;
  logic              [NumGroups-1:0] postreg_tcdm_slave_req_ready;
  tcdm_slave_resp_t  [NumGroups-1:0] prereg_tcdm_slave_resp;
  logic              [NumGroups-1:0] prereg_tcdm_slave_resp_valid;
  logic              [NumGroups-1:0] prereg_tcdm_slave_resp_ready;
  tcdm_master_resp_t [NumGroups-1:0] postreg_tcdm_master_resp;
  tile_core_id_t     [NumGroups-1:0] postreg_tcdm_master_resp_ini_sel;
  logic              [NumGroups-1:0] postreg_tcdm_master_resp_valid;
  logic              [NumGroups-1:0] postreg_tcdm_master_resp_ready;

  // Break paths between request and response with registers
  for (genvar h = 0; unsigned'(h) < NumGroups; h++) begin: gen_tcdm_registers
    spill_register #(
      .T(tcdm_master_req_t)
    ) i_tcdm_master_req_register (
      .clk_i  (clk_i                          ),
      .rst_ni (rst_ni                         ),
      .data_i (prereg_tcdm_master_req[h]      ),
      .valid_i(prereg_tcdm_master_req_valid[h]),
      .ready_o(prereg_tcdm_master_req_ready[h]),
      .data_o (tcdm_master_req_o[h]           ),
      .valid_o(tcdm_master_req_valid_o[h]     ),
      .ready_i(tcdm_master_req_ready_i[h]     )
    );

    fall_through_register #(
      .T(tcdm_master_resp_t)
    ) i_tcdm_master_resp_register (
      .clk_i     (clk_i                            ),
      .rst_ni    (rst_ni                           ),
      .clr_i     (1'b0                             ),
      .testmode_i(1'b0                             ),
      .data_i    (tcdm_master_resp_i[h]            ),
      .valid_i   (tcdm_master_resp_valid_i[h]      ),
      .ready_o   (tcdm_master_resp_ready_o[h]      ),
      .data_o    (postreg_tcdm_master_resp[h]      ),
      .valid_o   (postreg_tcdm_master_resp_valid[h]),
      .ready_i   (postreg_tcdm_master_resp_ready[h])
    );

    // Helper signal to drive the remote response interconnect
    assign postreg_tcdm_master_resp_ini_sel[h] = postreg_tcdm_master_resp[h].rdata.core_id;

    fall_through_register #(
      .T(tcdm_slave_req_t)
    ) i_tcdm_slave_req_register (
      .clk_i     (clk_i                          ),
      .rst_ni    (rst_ni                         ),
      .clr_i     (1'b0                           ),
      .testmode_i(1'b0                           ),
      .data_i    (tcdm_slave_req_i[h]            ),
      .valid_i   (tcdm_slave_req_valid_i[h]      ),
      .ready_o   (tcdm_slave_req_ready_o[h]      ),
      .data_o    (postreg_tcdm_slave_req[h]      ),
      .valid_o   (postreg_tcdm_slave_req_valid[h]),
      .ready_i   (postreg_tcdm_slave_req_ready[h])
    );

    spill_register #(
      .T(tcdm_slave_resp_t)
    ) i_tcdm_slave_resp_register (
      .clk_i  (clk_i                          ),
      .rst_ni (rst_ni                         ),
      .data_i (prereg_tcdm_slave_resp[h]      ),
      .valid_i(prereg_tcdm_slave_resp_valid[h]),
      .ready_o(prereg_tcdm_slave_resp_ready[h]),
      .data_o (tcdm_slave_resp_o[h]           ),
      .valid_o(tcdm_slave_resp_valid_o[h]     ),
      .ready_i(tcdm_slave_resp_ready_i[h]     )
    );
  end: gen_tcdm_registers

  /****************************
   *   Remote Interconnects   *
   ****************************/

  tcdm_master_req_t  [NumCoresPerTile-1:0] remote_req_interco;
  logic              [NumCoresPerTile-1:0] remote_req_interco_valid;
  logic              [NumCoresPerTile-1:0] remote_req_interco_ready;
  group_id_t         [NumCoresPerTile-1:0] remote_req_interco_tgt_sel;
  tcdm_master_resp_t [NumCoresPerTile-1:0] remote_resp_interco;
  logic              [NumCoresPerTile-1:0] remote_resp_interco_valid;
  logic              [NumCoresPerTile-1:0] remote_resp_interco_ready;

  stream_xbar #(
    .NumInp   (NumCoresPerTile  ),
    .NumOut   (NumGroups        ),
    .payload_t(tcdm_master_req_t)
  ) i_remote_req_interco (
    .clk_i  (clk_i                       ),
    .rst_ni (rst_ni                      ),
    .flush_i(1'b0                        ),
    // External priority flag
    .rr_i   ('0                          ),
    // Master
    .data_i (remote_req_interco          ),
    .valid_i(remote_req_interco_valid    ),
    .ready_o(remote_req_interco_ready    ),
    .sel_i  (remote_req_interco_tgt_sel  ),
    // Slave
    .data_o (prereg_tcdm_master_req      ),
    .valid_o(prereg_tcdm_master_req_valid),
    .ready_i(prereg_tcdm_master_req_ready),
    .idx_o  (/* Unused */                )
  );

  stream_xbar #(
    .NumInp   (NumGroups         ),
    .NumOut   (NumCoresPerTile   ),
    .payload_t(tcdm_master_resp_t)
  ) i_remote_resp_interco (
    .clk_i  (clk_i                           ),
    .rst_ni (rst_ni                          ),
    .flush_i(1'b0                            ),
    // External priority flag
    .rr_i   ('0                              ),
    // Master
    .data_i (postreg_tcdm_master_resp        ),
    .valid_i(postreg_tcdm_master_resp_valid  ),
    .ready_o(postreg_tcdm_master_resp_ready  ),
    .sel_i  (postreg_tcdm_master_resp_ini_sel),
    // Slave
    .data_o (remote_resp_interco             ),
    .valid_o(remote_resp_interco_valid       ),
    .ready_i(remote_resp_interco_ready       ),
    .idx_o  (/* Unused */                    )
  );

  /**********************
   *   Local Intercos   *
   **********************/

  logic             [NumCoresPerTile-1:0] local_req_interco_valid;
  logic             [NumCoresPerTile-1:0] local_req_interco_ready;
  tcdm_slave_req_t  [NumCoresPerTile-1:0] local_req_interco_payload;
  logic             [NumCoresPerTile-1:0] local_resp_interco_valid;
  logic             [NumCoresPerTile-1:0] local_resp_interco_ready;
  tcdm_slave_resp_t [NumCoresPerTile-1:0] local_resp_interco_payload;

  logic [NumCoresPerTile+NumGroups-1:0][idx_width(NumBanksPerTile)-1:0] local_req_interco_tgt_sel;
  for (genvar j = 0; unsigned'(j) < NumCoresPerTile; j++) begin: gen_local_req_interco_tgt_sel_local
    assign local_req_interco_tgt_sel[j]  = local_req_interco_payload[j].tgt_addr[idx_width(NumBanksPerTile)-1:0];
  end: gen_local_req_interco_tgt_sel_local
  for (genvar j = 0; unsigned'(j) < NumGroups; j++) begin: gen_local_req_interco_tgt_sel_remote
    assign local_req_interco_tgt_sel[j + NumCoresPerTile]  = postreg_tcdm_slave_req[j].tgt_addr[idx_width(NumBanksPerTile)-1:0];
  end: gen_local_req_interco_tgt_sel_remote

  stream_xbar #(
    .NumInp   (NumCoresPerTile+NumGroups),
    .NumOut   (NumBanksPerTile          ),
    .payload_t(tcdm_slave_req_t         )
  ) i_local_req_interco (
    .clk_i  (clk_i                                                  ),
    .rst_ni (rst_ni                                                 ),
    .flush_i(1'b0                                                   ),
    // External priority flag
    .rr_i   ('0                                                     ),
    // Master
    .data_i ({postreg_tcdm_slave_req, local_req_interco_payload}    ),
    .valid_i({postreg_tcdm_slave_req_valid, local_req_interco_valid}),
    .ready_o({postreg_tcdm_slave_req_ready, local_req_interco_ready}),
    .sel_i  (local_req_interco_tgt_sel                              ),
    // Slave
    .data_o (bank_req_payload                                       ),
    .valid_o(bank_req_valid                                         ),
    .ready_i(bank_req_ready                                         ),
    .idx_o  (bank_req_ini_addr                                      )
  );

  stream_xbar #(
    .NumInp   (NumBanksPerTile          ),
    .NumOut   (NumCoresPerTile+NumGroups),
    .payload_t(tcdm_slave_resp_t        )
  ) i_local_resp_interco (
    .clk_i  (clk_i                                                   ),
    .rst_ni (rst_ni                                                  ),
    .flush_i(1'b0                                                    ),
    // External priority flag
    .rr_i   ('0                                                      ),
    // Master
    .data_i (bank_resp_payload                                       ),
    .valid_i(bank_resp_valid                                         ),
    .ready_o(bank_resp_ready                                         ),
    .sel_i  (bank_resp_ini_addr                                      ),
    // Slave
    .data_o ({prereg_tcdm_slave_resp, local_resp_interco_payload}    ),
    .valid_o({prereg_tcdm_slave_resp_valid, local_resp_interco_valid}),
    .ready_i({prereg_tcdm_slave_resp_ready, local_resp_interco_ready}),
    .idx_o  (/* Unused */                                            )
  );

  /*******************
   *   Core De/mux   *
   *******************/

  // SoC requests
  dreq_t  [NumCoresPerTile-1:0] soc_data_q;
  logic   [NumCoresPerTile-1:0] soc_data_qvalid;
  logic   [NumCoresPerTile-1:0] soc_data_qready;
  dresp_t [NumCoresPerTile-1:0] soc_data_p;
  logic   [NumCoresPerTile-1:0] soc_data_pvalid;
  logic   [NumCoresPerTile-1:0] soc_data_pready;

  // Address map
  typedef enum int unsigned {
    TCDM_EXTERNAL = 0, TCDM_LOCAL, SOC
  } addr_map_slave_t;

  address_map_t [2:0] mask_map;
  assign mask_map = '{
    // Lowest priority: send request through the SoC port
    '{slave_idx: SOC,
      mask     : '0,
      value    : '0
    },
    // Send request through the external TCDM port
    '{slave_idx: TCDM_EXTERNAL,
      mask     : TCDMMask,
      value    : TCDMBaseAddr
    },
    // Highest priority: send request through the local TCDM port
    '{slave_idx: TCDM_LOCAL,
      mask     : TCDMMask | ({idx_width(NumTiles){1'b1}} << (ByteOffset + $clog2(NumBanksPerTile))),
      value    : TCDMBaseAddr | (tile_id_i << (ByteOffset + $clog2(NumBanksPerTile)))
    }
  };

  for (genvar c = 0; c < NumCoresPerTile; c++) begin: gen_core_mux
    // Remove tile index from local_req_interco_addr_int, since it will not be used for routing.
    addr_t local_req_interco_addr_int;
    assign local_req_interco_payload[c].tgt_addr =
     tcdm_addr_t'({local_req_interco_addr_int[ByteOffset + idx_width(NumBanksPerTile) + $clog2(NumTiles) +: TCDMAddrMemWidth], // Bank address
             local_req_interco_addr_int[ByteOffset +: idx_width(NumBanksPerTile)]}); // Bank

    // Switch tile and bank indexes for correct upper level routing, and remove the group index
    addr_t prescramble_tcdm_req_tgt_addr;
    if (NumTilesPerGroup == 1) begin : gen_remote_req_interco_tgt_addr
      assign remote_req_interco[c].tgt_addr =
      tcdm_addr_t'({prescramble_tcdm_req_tgt_addr[ByteOffset + idx_width(NumBanksPerTile) + $clog2(NumGroups) +: TCDMAddrMemWidth], // Bank address
         prescramble_tcdm_req_tgt_addr[ByteOffset +: idx_width(NumBanksPerTile)]}); // Tile
    end else begin : gen_remote_req_interco_tgt_addr
      assign remote_req_interco[c].tgt_addr =
      tcdm_addr_t'({prescramble_tcdm_req_tgt_addr[ByteOffset + idx_width(NumBanksPerTile) + $clog2(NumTilesPerGroup) + $clog2(NumGroups) +: TCDMAddrMemWidth], // Bank address
         prescramble_tcdm_req_tgt_addr[ByteOffset +: idx_width(NumBanksPerTile)],                                                                              // Bank
         prescramble_tcdm_req_tgt_addr[ByteOffset + idx_width(NumBanksPerTile) +: $clog2(NumTilesPerGroup)]}); // Tile
    end
    if (NumGroups == 1) begin : gen_remote_req_interco_tgt_sel
      assign remote_req_interco_tgt_sel[c] = 1'b0;
    end else begin : gen_remote_req_interco_tgt_sel
      // Output port depends on both the target and initiator group
      assign remote_req_interco_tgt_sel[c] = (prescramble_tcdm_req_tgt_addr[ByteOffset + $clog2(NumBanksPerTile) + $clog2(NumTilesPerGroup) +: $clog2(NumGroups)]) ^ group_id;
    end

    // We don't care about these
    assign local_req_interco_payload[c].wdata.core_id = '0;
    assign local_req_interco_payload[c].ini_addr      = '0;
    assign soc_data_q[c].id                           = '0;

    // Constant value
    assign remote_req_interco[c].wdata.core_id = c[idx_width(NumCoresPerTile)-1:0];

    // Scramble address before entering TCDM shim for sequential+interleaved memory map
    addr_t snitch_data_qaddr_scrambled;
    address_scrambler #(
      .AddrWidth         (AddrWidth        ),
      .ByteOffset        (ByteOffset       ),
      .NumTiles          (NumTiles         ),
      .NumBanksPerTile   (NumBanksPerTile  ),
      .Bypass            (0                ),
      .SeqMemSizePerTile (SeqMemSizePerTile)
    ) i_address_scrambler (
      .address_i (snitch_data_qaddr[c]       ),
      .address_o (snitch_data_qaddr_scrambled)
    );

    if (!TrafficGeneration) begin: gen_tcdm_shim
      tcdm_shim #(
        .AddrWidth           (AddrWidth                         ),
        .DataWidth           (DataWidth                         ),
        .MaxOutStandingReads (snitch_pkg::NumIntOutstandingLoads),
        .NrTCDM              (2                                 ),
        .NrSoC               (1                                 ),
        .NumRules            (3                                 )
      ) i_tcdm_shim (
        .clk_i              (clk_i                                                                              ),
        .rst_ni             (rst_ni                                                                             ),
        // to TCDM --> FF Connection to outside of tile
        .tcdm_req_valid_o   ({local_req_interco_valid[c], remote_req_interco_valid[c]}                          ),
        .tcdm_req_tgt_addr_o({local_req_interco_addr_int, prescramble_tcdm_req_tgt_addr}                        ),
        .tcdm_req_wen_o     ({local_req_interco_payload[c].wen, remote_req_interco[c].wen}                      ),
        .tcdm_req_wdata_o   ({local_req_interco_payload[c].wdata.data, remote_req_interco[c].wdata.data}        ),
        .tcdm_req_amo_o     ({local_req_interco_payload[c].wdata.amo, remote_req_interco[c].wdata.amo}          ),
        .tcdm_req_id_o      ({local_req_interco_payload[c].wdata.meta_id, remote_req_interco[c].wdata.meta_id}  ),
        .tcdm_req_be_o      ({local_req_interco_payload[c].be, remote_req_interco[c].be}                        ),
        .tcdm_req_ready_i   ({local_req_interco_ready[c], remote_req_interco_ready[c]}                          ),
        .tcdm_resp_valid_i  ({local_resp_interco_valid[c], remote_resp_interco_valid[c]}                        ),
        .tcdm_resp_ready_o  ({local_resp_interco_ready[c], remote_resp_interco_ready[c]}                        ),
        .tcdm_resp_rdata_i  ({local_resp_interco_payload[c].rdata.data, remote_resp_interco[c].rdata.data}      ),
        .tcdm_resp_id_i     ({local_resp_interco_payload[c].rdata.meta_id, remote_resp_interco[c].rdata.meta_id}),
        // to SoC
        .soc_qaddr_o        (soc_data_q[c].addr                                                                 ),
        .soc_qwrite_o       (soc_data_q[c].write                                                                ),
        .soc_qamo_o         (soc_data_q[c].amo                                                                  ),
        .soc_qdata_o        (soc_data_q[c].data                                                                 ),
        .soc_qstrb_o        (soc_data_q[c].strb                                                                 ),
        .soc_qvalid_o       (soc_data_qvalid[c]                                                                 ),
        .soc_qready_i       (soc_data_qready[c]                                                                 ),
        .soc_pdata_i        (soc_data_p[c].data                                                                 ),
        .soc_perror_i       (soc_data_p[c].error                                                                ),
        .soc_pvalid_i       (soc_data_pvalid[c]                                                                 ),
        .soc_pready_o       (soc_data_pready[c]                                                                 ),
        // from core
        .data_qaddr_i       (snitch_data_qaddr_scrambled                                                        ),
        .data_qwrite_i      (snitch_data_qwrite[c]                                                              ),
        .data_qamo_i        (snitch_data_qamo[c]                                                                ),
        .data_qdata_i       (snitch_data_qdata[c]                                                               ),
        .data_qstrb_i       (snitch_data_qstrb[c]                                                               ),
        .data_qid_i         (snitch_data_qid[c]                                                                 ),
        .data_qvalid_i      (snitch_data_qvalid[c]                                                              ),
        .data_qready_o      (snitch_data_qready[c]                                                              ),
        .data_pdata_o       (snitch_data_pdata[c]                                                               ),
        .data_perror_o      (snitch_data_perror[c]                                                              ),
        .data_pid_o         (snitch_data_pid[c]                                                                 ),
        .data_pvalid_o      (snitch_data_pvalid[c]                                                              ),
        .data_pready_i      (snitch_data_pready[c]                                                              ),
        .address_map_i      (mask_map                                                                           )
      );
    end else begin: gen_traffic_generator
      traffic_generator #(
        .NumRules           (3                                 ),
        .TCDMBaseAddr       (TCDMBaseAddr                      ),
        .MaxOutStandingReads(snitch_pkg::NumIntOutstandingLoads)
      ) i_traffic_gen (
        .clk_i              (clk_i                                                        ),
        .rst_ni             (rst_ni                                                       ),
        .core_id_i          ({tile_id_i, c[idx_width(NumCoresPerTile)-1:0]}               ),
        // Address map
        .address_map_i      (mask_map                                                     ),
        // To TCDM
        .tcdm_req_valid_o   ({local_req_interco_valid[c], remote_req_interco_valid[c]}    ),
        .tcdm_req_tgt_addr_o({local_req_interco_addr_int, prescramble_tcdm_req_tgt_addr}  ),
        .tcdm_req_wen_o     ({local_req_interco_payload[c].wen, remote_req_interco[c].wen}),
        .tcdm_req_wdata_o   ({local_req_interco_payload[c].wdata.data,
            remote_req_interco[c].wdata.data}),
        .tcdm_req_amo_o({local_req_interco_payload[c].wdata.amo,
            remote_req_interco[c].wdata.amo}),
        .tcdm_req_id_o({local_req_interco_payload[c]
            .wdata.meta_id, remote_req_interco[c].wdata.meta_id}),
        .tcdm_req_be_o    ({local_req_interco_payload[c].be, remote_req_interco[c].be}),
        .tcdm_req_ready_i ({local_req_interco_ready[c], remote_req_interco_ready[c]}  ),
        .tcdm_resp_valid_i({local_resp_interco_valid[c], remote_resp_interco_valid[c]}),
        .tcdm_resp_ready_o({local_resp_interco_ready[c], remote_resp_interco_ready[c]}),
        .tcdm_resp_rdata_i({local_resp_interco_payload[c].rdata.data,
            remote_resp_interco[c].rdata.data} ),
        .tcdm_resp_id_i ({local_resp_interco_payload[c].rdata.meta_id,
            remote_resp_interco[c].rdata.meta_id})
      );

      // Tie unused signals
      assign soc_data_q[c].addr    = '0;
      assign soc_data_q[c].write   = '0;
      assign soc_data_q[c].amo     = '0;
      assign soc_data_q[c].data    = '0;
      assign soc_data_q[c].strb    = '0;
      assign soc_data_qvalid[c]    = '0;
      assign soc_data_pready[c]    = '0;
      assign snitch_data_qready[c] = '0;
      assign snitch_data_pdata[c]  = '0;
      assign snitch_data_perror[c] = '0;
      assign snitch_data_pid[c]    = '0;
      assign snitch_data_pvalid[c] = '0;
    end
  end

  /****************
   *   AXI Plug   *
   ****************/

  snitch_pkg::dreq_t soc_req_o;
  snitch_pkg::dresp_t soc_resp_i;

  logic soc_qvalid;
  logic soc_qready;
  logic soc_pvalid;
  logic soc_pready;

  // We don't care about this
  assign soc_resp_i.id = 'x;

  snitch_demux #(
    .NrPorts (NumCoresPerTile    ),
    .req_t   (snitch_pkg::dreq_t ),
    .resp_t  (snitch_pkg::dresp_t)
  ) i_snitch_demux_data (
    .clk_i         (clk_i          ),
    .rst_ni        (rst_ni         ),
    // Inputs
    .req_payload_i (soc_data_q     ),
    .req_valid_i   (soc_data_qvalid),
    .req_ready_o   (soc_data_qready),
    .resp_payload_o(soc_data_p     ),
    .resp_last_o   (/* Unused */   ),
    .resp_valid_o  (soc_data_pvalid),
    .resp_ready_i  (soc_data_pready),
    // Output
    .req_payload_o (soc_req_o      ),
    .req_valid_o   (soc_qvalid     ),
    .req_ready_i   (soc_qready     ),
    .resp_payload_i(soc_resp_i     ),
    .resp_last_i   (1'b1           ),
    .resp_valid_i  (soc_pvalid     ),
    .resp_ready_o  (soc_pready     )
  );

  // Core request
  axi_core_req_t  axi_cores_req, axi_cache_req;
  axi_core_resp_t axi_cores_resp, axi_cache_resp;
  axi_tile_req_t  axi_mst_req;
  axi_tile_resp_t axi_mst_resp;

  snitch_axi_adapter #(
    .addr_t         (snitch_pkg::addr_t),
    .data_t         (snitch_pkg::data_t),
    .strb_t         (snitch_pkg::strb_t),
    .axi_mst_req_t  (axi_core_req_t    ),
    .axi_mst_resp_t (axi_core_resp_t   )
  ) i_snitch_core_axi_adapter (
    .clk_i       (clk_i           ),
    .rst_ni      (rst_ni          ),
    .slv_qaddr_i (soc_req_o.addr  ),
    .slv_qwrite_i(soc_req_o.write ),
    .slv_qamo_i  (soc_req_o.amo   ),
    .slv_qdata_i (soc_req_o.data  ),
    .slv_qsize_i (3'b010          ),
    .slv_qstrb_i (soc_req_o.strb  ),
    .slv_qrlen_i ('0              ),
    .slv_qvalid_i(soc_qvalid      ),
    .slv_qready_o(soc_qready      ),
    .slv_pdata_o (soc_resp_i.data ),
    .slv_perror_o(soc_resp_i.error),
    .slv_plast_o (/* Unused */    ),
    .slv_pvalid_o(soc_pvalid      ),
    .slv_pready_i(soc_pready      ),
    .axi_req_o   (axi_cores_req   ),
    .axi_resp_i  (axi_cores_resp  )
  );

  // TODO: Add demux for the case where we have many intruction caches
  snitch_axi_adapter #(
    .addr_t         (snitch_pkg::addr_t),
    .data_t         (axi_data_t        ),
    .strb_t         (axi_strb_t        ),
    .axi_mst_req_t  (axi_core_req_t    ),
    .axi_mst_resp_t (axi_core_resp_t   )
  ) i_snitch_cache_axi_adapter (
    .clk_i       (clk_i                     ),
    .rst_ni      (rst_ni                    ),
    .slv_qaddr_i (refill_qaddr[0]           ),
    .slv_qwrite_i('0                        ),
    .slv_qamo_i  ('0                        ),
    .slv_qdata_i ('0                        ),
    .slv_qsize_i (3'($clog2(AxiDataWidth/8))),
    .slv_qstrb_i ('0                        ),
    .slv_qrlen_i (refill_qlen[0]            ),
    .slv_qvalid_i(refill_qvalid[0]          ),
    .slv_qready_o(refill_qready[0]          ),
    .slv_pdata_o (refill_pdata[0]           ),
    .slv_perror_o(refill_perror[0]          ),
    .slv_plast_o (refill_plast[0]           ),
    .slv_pvalid_o(refill_pvalid[0]          ),
    .slv_pready_i(refill_pready[0]          ),
    .axi_req_o   (axi_cache_req             ),
    .axi_resp_i  (axi_cache_resp            )
  );

  axi_mux #(
    .SlvAxiIDWidth (AxiCoreIdWidth ),
    .slv_aw_chan_t (axi_core_aw_t  ),
    .mst_aw_chan_t (axi_tile_aw_t  ),
    .w_chan_t      (axi_tile_w_t   ),
    .slv_b_chan_t  (axi_core_b_t   ),
    .mst_b_chan_t  (axi_tile_b_t   ),
    .slv_ar_chan_t (axi_core_ar_t  ),
    .mst_ar_chan_t (axi_tile_ar_t  ),
    .slv_r_chan_t  (axi_core_r_t   ),
    .mst_r_chan_t  (axi_tile_r_t   ),
    .slv_req_t     (axi_core_req_t ),
    .slv_resp_t    (axi_core_resp_t),
    .mst_req_t     (axi_tile_req_t ),
    .mst_resp_t    (axi_tile_resp_t),
    .NoSlvPorts    (2              ),
    .MaxWTrans     (8              ),
    .FallThrough   (1              )
  ) i_axi_mux (
    .clk_i      (clk_i                           ),
    .rst_ni     (rst_ni                          ),
    .test_i     (1'b0                            ),
    .slv_reqs_i ({axi_cores_req, axi_cache_req}  ),
    .slv_resps_o({axi_cores_resp, axi_cache_resp}),
    .mst_req_o  (axi_mst_req                     ),
    .mst_resp_i (axi_mst_resp                    )
  );

  axi_cut #(
    .aw_chan_t(axi_tile_aw_t  ),
    .w_chan_t (axi_tile_w_t   ),
    .b_chan_t (axi_tile_b_t   ),
    .ar_chan_t(axi_tile_ar_t  ),
    .r_chan_t (axi_tile_r_t   ),
    .req_t    (axi_tile_req_t ),
    .resp_t   (axi_tile_resp_t)
  ) axi_mst_slice (
    .clk_i     (clk_i         ),
    .rst_ni    (rst_ni        ),
    .slv_req_i (axi_mst_req   ),
    .slv_resp_o(axi_mst_resp  ),
    .mst_req_o (axi_mst_req_o ),
    .mst_resp_i(axi_mst_resp_i)
  );

  /******************
   *   Assertions   *
   ******************/

  // Check invariants.
  if (BootAddr[1:0] != 2'b00)
    $fatal(1, "[mempool_tile] Boot address should be aligned in a 4-byte boundary.");

  if (NumCoresPerTile != 2**$clog2(NumCoresPerTile))
    $fatal(1, "[mempool_tile] The number of cores per tile must be a power of two.");

  if (NumCores != unsigned'(2**$clog2(NumCores)))
    $fatal(1, "[mempool_tile] The number of cores must be a power of two.");

  if (NumBanksPerTile < 1)
    $fatal(1, "[mempool_tile] The number of banks per tile must be larger than one");

  if (NumCaches != 1)
    $error("NumCaches > 1 is not supported!");

  if (DataWidth > AxiDataWidth)
    $error("AxiDataWidth needs to be larger than DataWidth!");

endmodule : mempool_tile

/*****************
 *    WRAPPER    *
 *****************/
/*verilator lint_off DECLFILENAME*/
//what is the below file exactly used for ?
`include "mempool/mempool.svh"

module mempool_tile_wrap
  import mempool_pkg::*;
  import cf_math_pkg::idx_width;
#(
  // TCDM
  parameter addr_t       TCDMBaseAddr    = 32'b0,
  // Boot address
  parameter logic [31:0] BootAddr        = 32'h0000_1000,
  // Dependent parameters. DO NOT CHANGE.
  parameter int unsigned NumCaches       = NumCoresPerTile / NumCoresPerCache
) (
  // Clock and reset
  input  logic                             clk_i,
  input  logic                             rst_ni,
  // Scan chain
  input  logic                             scan_enable_i,
  input  logic                             scan_data_i,
  output logic                             scan_data_o,
  // Tile ID
  input  logic [idx_width(NumTiles)-1:0]   tile_id_i,
  // TCDM Master interfaces
  output `STRUCT_PORT(tcdm_master_req_t)   tcdm_master_north_req_o,
  output logic                             tcdm_master_north_req_valid_o,
  input  logic                             tcdm_master_north_req_ready_i,
  input  `STRUCT_PORT(tcdm_master_resp_t)  tcdm_master_north_resp_i,
  input  logic                             tcdm_master_north_resp_valid_i,
  output logic                             tcdm_master_north_resp_ready_o,
  output `STRUCT_PORT(tcdm_master_req_t)   tcdm_master_northeast_req_o,
  output logic                             tcdm_master_northeast_req_valid_o,
  input  logic                             tcdm_master_northeast_req_ready_i,
  input  `STRUCT_PORT(tcdm_master_resp_t)  tcdm_master_northeast_resp_i,
  input  logic                             tcdm_master_northeast_resp_valid_i,
  output logic                             tcdm_master_northeast_resp_ready_o,
  output `STRUCT_PORT(tcdm_master_req_t)   tcdm_master_east_req_o,
  output logic                             tcdm_master_east_req_valid_o,
  input  logic                             tcdm_master_east_req_ready_i,
  input  `STRUCT_PORT(tcdm_master_resp_t)  tcdm_master_east_resp_i,
  input  logic                             tcdm_master_east_resp_valid_i,
  output logic                             tcdm_master_east_resp_ready_o,
  output `STRUCT_PORT(tcdm_master_req_t)   tcdm_master_local_req_o,
  output logic                             tcdm_master_local_req_valid_o,
  input  logic                             tcdm_master_local_req_ready_i,
  input  `STRUCT_PORT(tcdm_master_resp_t)  tcdm_master_local_resp_i,
  input  logic                             tcdm_master_local_resp_valid_i,
  output logic                             tcdm_master_local_resp_ready_o,
  // TCDM Slave interfaces
  input  `STRUCT_PORT(tcdm_slave_req_t)    tcdm_slave_north_req_i,
  input  logic                             tcdm_slave_north_req_valid_i,
  output logic                             tcdm_slave_north_req_ready_o,
  output `STRUCT_PORT(tcdm_slave_resp_t)   tcdm_slave_north_resp_o,
  output logic                             tcdm_slave_north_resp_valid_o,
  input  logic                             tcdm_slave_north_resp_ready_i,
  input  `STRUCT_PORT(tcdm_slave_req_t)    tcdm_slave_northeast_req_i,
  input  logic                             tcdm_slave_northeast_req_valid_i,
  output logic                             tcdm_slave_northeast_req_ready_o,
  output `STRUCT_PORT(tcdm_slave_resp_t)   tcdm_slave_northeast_resp_o,
  output logic                             tcdm_slave_northeast_resp_valid_o,
  input  logic                             tcdm_slave_northeast_resp_ready_i,
  input  `STRUCT_PORT(tcdm_slave_req_t)    tcdm_slave_east_req_i,
  input  logic                             tcdm_slave_east_req_valid_i,
  output logic                             tcdm_slave_east_req_ready_o,
  output `STRUCT_PORT(tcdm_slave_resp_t)   tcdm_slave_east_resp_o,
  output logic                             tcdm_slave_east_resp_valid_o,
  input  logic                             tcdm_slave_east_resp_ready_i,
  input  `STRUCT_PORT(tcdm_slave_req_t)    tcdm_slave_local_req_i,
  input  logic                             tcdm_slave_local_req_valid_i,
  output logic                             tcdm_slave_local_req_ready_o,
  output `STRUCT_PORT(tcdm_slave_resp_t)   tcdm_slave_local_resp_o,
  output logic                             tcdm_slave_local_resp_valid_o,
  input  logic                             tcdm_slave_local_resp_ready_i,
  // AXI Interface
  output `STRUCT_PORT(axi_tile_req_t)      axi_mst_req_o,
  input  `STRUCT_PORT(axi_tile_resp_t)     axi_mst_resp_i,
  // Wake up interface
  input  logic [NumCoresPerTile-1:0]       wake_up_i
);

  mempool_tile #(
    .TCDMBaseAddr(TCDMBaseAddr),
    .BootAddr    (BootAddr    )
  ) i_tile (
    .clk_i                   (clk_i                                                                                                                              ),
    .rst_ni                  (rst_ni                                                                                                                             ),
    .tile_id_i               (tile_id_i                                                                                                                          ),
    // Scan chain
    .scan_enable_i           (scan_enable_i                                                                                                                      ),
    .scan_data_i             (scan_data_i                                                                                                                        ),
    .scan_data_o             (scan_data_o                                                                                                                        ),
    // TCDM Master
    .tcdm_master_req_o       ({tcdm_master_northeast_req_o, tcdm_master_north_req_o, tcdm_master_east_req_o, tcdm_master_local_req_o}                            ),
    .tcdm_master_req_ready_i ({tcdm_master_northeast_req_ready_i, tcdm_master_north_req_ready_i, tcdm_master_east_req_ready_i, tcdm_master_local_req_ready_i}    ),
    .tcdm_master_req_valid_o ({tcdm_master_northeast_req_valid_o, tcdm_master_north_req_valid_o, tcdm_master_east_req_valid_o, tcdm_master_local_req_valid_o}    ),
    .tcdm_master_resp_i      ({tcdm_master_northeast_resp_i, tcdm_master_north_resp_i, tcdm_master_east_resp_i, tcdm_master_local_resp_i}                        ),
    .tcdm_master_resp_ready_o({tcdm_master_northeast_resp_ready_o, tcdm_master_north_resp_ready_o, tcdm_master_east_resp_ready_o, tcdm_master_local_resp_ready_o}),
    .tcdm_master_resp_valid_i({tcdm_master_northeast_resp_valid_i, tcdm_master_north_resp_valid_i, tcdm_master_east_resp_valid_i, tcdm_master_local_resp_valid_i}),
    // TCDM Slave
    .tcdm_slave_req_i        ({tcdm_slave_northeast_req_i, tcdm_slave_north_req_i, tcdm_slave_east_req_i, tcdm_slave_local_req_i}                                ),
    .tcdm_slave_req_ready_o  ({tcdm_slave_northeast_req_ready_o, tcdm_slave_north_req_ready_o, tcdm_slave_east_req_ready_o, tcdm_slave_local_req_ready_o}        ),
    .tcdm_slave_req_valid_i  ({tcdm_slave_northeast_req_valid_i, tcdm_slave_north_req_valid_i, tcdm_slave_east_req_valid_i, tcdm_slave_local_req_valid_i}        ),
    .tcdm_slave_resp_o       ({tcdm_slave_northeast_resp_o, tcdm_slave_north_resp_o, tcdm_slave_east_resp_o, tcdm_slave_local_resp_o}                            ),
    .tcdm_slave_resp_ready_i ({tcdm_slave_northeast_resp_ready_i, tcdm_slave_north_resp_ready_i, tcdm_slave_east_resp_ready_i, tcdm_slave_local_resp_ready_i}    ),
    .tcdm_slave_resp_valid_o ({tcdm_slave_northeast_resp_valid_o, tcdm_slave_north_resp_valid_o, tcdm_slave_east_resp_valid_o, tcdm_slave_local_resp_valid_o}    ),
    // AXI interface
    .axi_mst_req_o           (axi_mst_req_o                                                                                                                      ),
    .axi_mst_resp_i          (axi_mst_resp_i                                                                                                                     ),
    // Wake up interface
    .wake_up_i               (wake_up_i                                                                                                                          )
  );

endmodule: mempool_tile_wrap
