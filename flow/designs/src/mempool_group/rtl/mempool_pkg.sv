// Copyright 2021 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51
// csamudra : 12/24 edited line 18 localparam integer ...NumCores ..16..endif; earlier it was 0 instead of 16
// csamudra : 12/24 edited line 19 localparam integer ...NumCoresPerTile..4..endif; earlier it was 0 instead of 4
package mempool_pkg;

  import snitch_pkg::MetaIdWidth;
  import cf_math_pkg::idx_width;

  /*********************
   *  TILE PARAMETERS  *
   *********************/

  `include "axi/assign.svh"
  `include "axi/typedef.svh"

  localparam integer unsigned NumCores         = `ifdef NUM_CORES `NUM_CORES `else 16 `endif;
  localparam integer unsigned NumCoresPerTile  = `ifdef NUM_CORES_PER_TILE `NUM_CORES_PER_TILE `else 4 `endif;
  localparam integer unsigned NumGroups        = 4;
  localparam integer unsigned NumTiles         = NumCores / NumCoresPerTile;
  localparam integer unsigned NumTilesPerGroup = NumTiles / NumGroups;
  localparam integer unsigned NumCoresPerGroup = NumCores / NumGroups;
  localparam integer unsigned NumCoresPerCache = NumCoresPerTile;
  localparam integer unsigned AxiCoreIdWidth   = 1;
  localparam integer unsigned AxiTileIdWidth   = AxiCoreIdWidth+1; // + 1 for cache
  localparam integer unsigned AxiDataWidth     = 128;
  localparam integer unsigned AxiLiteDataWidth = 32;

  /***********************
   *  MEMORY PARAMETERS  *
   ***********************/

  localparam integer unsigned AddrWidth        = 32;
  localparam integer unsigned DataWidth        = 32;
  localparam integer unsigned BeWidth          = DataWidth / 8;
  localparam integer unsigned ByteOffset       = $clog2(BeWidth);
  localparam integer unsigned BankingFactor    = 4;
  localparam bit              LrScEnable       = 1'b1;
  localparam integer unsigned TCDMSizePerBank  = 1024; // [B]
  localparam integer unsigned NumBanks         = NumCores * BankingFactor;
  localparam integer unsigned NumBanksPerTile  = NumBanks / NumTiles;
  localparam integer unsigned NumBanksPerGroup = NumBanks / NumGroups;
  localparam integer unsigned TCDMAddrMemWidth = $clog2(TCDMSizePerBank / mempool_pkg::BeWidth);
  localparam integer unsigned TCDMAddrWidth    = TCDMAddrMemWidth + idx_width(NumBanksPerGroup);
  localparam integer unsigned L2Size           = `ifdef L2_SIZE `L2_SIZE `else 0 `endif; // [B]
  localparam integer unsigned L2BeWidth        = AxiDataWidth/8;
  localparam integer unsigned L2ByteOffset     = $clog2(L2BeWidth);

  typedef logic [AxiCoreIdWidth-1:0] axi_core_id_t;
  typedef logic [AxiTileIdWidth-1:0] axi_tile_id_t;
  typedef logic [AxiDataWidth-1:0] axi_data_t;
  typedef logic [AxiDataWidth/8-1:0] axi_strb_t;
  typedef logic [AxiLiteDataWidth-1:0] axi_lite_data_t;
  typedef logic [AxiLiteDataWidth/8-1:0] axi_lite_strb_t;
  typedef logic [AddrWidth-1:0] addr_t;
  typedef logic [DataWidth-1:0] data_t;
  typedef logic [BeWidth-1:0] strb_t;

  localparam NumSystemXbarMasters = NumGroups + 1;
  localparam AxiSystemIdWidth = $clog2(NumSystemXbarMasters) + AxiTileIdWidth;
  typedef logic [AxiSystemIdWidth-1:0] axi_system_id_t;

  localparam NumTestbenchXbarMasters = 1;
  localparam AxiTestbenchIdWidth = $clog2(NumTestbenchXbarMasters) + AxiSystemIdWidth;
  typedef logic [AxiTestbenchIdWidth-1:0] axi_tb_id_t;


  `AXI_TYPEDEF_AW_CHAN_T(axi_core_aw_t, addr_t, axi_core_id_t, logic);
  `AXI_TYPEDEF_W_CHAN_T(axi_core_w_t, axi_data_t, axi_strb_t, logic);
  `AXI_TYPEDEF_B_CHAN_T(axi_core_b_t, axi_core_id_t, logic);
  `AXI_TYPEDEF_AR_CHAN_T(axi_core_ar_t, addr_t, axi_core_id_t, logic);
  `AXI_TYPEDEF_R_CHAN_T(axi_core_r_t, axi_data_t, axi_core_id_t, logic);
  `AXI_TYPEDEF_REQ_T(axi_core_req_t, axi_core_aw_t, axi_core_w_t, axi_core_ar_t);
  `AXI_TYPEDEF_RESP_T(axi_core_resp_t, axi_core_b_t, axi_core_r_t );

  `AXI_TYPEDEF_AW_CHAN_T(axi_tile_aw_t, addr_t, axi_tile_id_t, logic);
  `AXI_TYPEDEF_W_CHAN_T(axi_tile_w_t, axi_data_t, axi_strb_t, logic);
  `AXI_TYPEDEF_B_CHAN_T(axi_tile_b_t, axi_tile_id_t, logic);
  `AXI_TYPEDEF_AR_CHAN_T(axi_tile_ar_t, addr_t, axi_tile_id_t, logic);
  `AXI_TYPEDEF_R_CHAN_T(axi_tile_r_t, axi_data_t, axi_tile_id_t, logic);
  `AXI_TYPEDEF_REQ_T(axi_tile_req_t, axi_tile_aw_t, axi_tile_w_t, axi_tile_ar_t);
  `AXI_TYPEDEF_RESP_T(axi_tile_resp_t, axi_tile_b_t, axi_tile_r_t );

  `AXI_TYPEDEF_AW_CHAN_T(axi_system_aw_t, addr_t, axi_system_id_t, logic);
  `AXI_TYPEDEF_W_CHAN_T(axi_system_w_t, axi_data_t, axi_strb_t, logic);
  `AXI_TYPEDEF_B_CHAN_T(axi_system_b_t, axi_system_id_t, logic);
  `AXI_TYPEDEF_AR_CHAN_T(axi_system_ar_t, addr_t, axi_system_id_t, logic);
  `AXI_TYPEDEF_R_CHAN_T(axi_system_r_t, axi_data_t, axi_system_id_t, logic);
  `AXI_TYPEDEF_REQ_T(axi_system_req_t, axi_system_aw_t, axi_system_w_t, axi_system_ar_t);
  `AXI_TYPEDEF_RESP_T(axi_system_resp_t, axi_system_b_t, axi_system_r_t);

  // AXI to ctrl registers
  `AXI_TYPEDEF_W_CHAN_T(axi_ctrl_w_t, axi_lite_data_t, axi_lite_strb_t, logic);
  `AXI_TYPEDEF_R_CHAN_T(axi_ctrl_r_t, axi_lite_data_t, axi_system_id_t, logic);
  `AXI_TYPEDEF_REQ_T(axi_ctrl_req_t, axi_system_aw_t, axi_ctrl_w_t, axi_system_ar_t);
  `AXI_TYPEDEF_RESP_T(axi_ctrl_resp_t, axi_system_b_t, axi_ctrl_r_t);

  `AXI_TYPEDEF_AW_CHAN_T(axi_tb_aw_t, addr_t, axi_tb_id_t, logic);
  `AXI_TYPEDEF_W_CHAN_T(axi_tb_w_t, axi_data_t, axi_strb_t, logic);
  `AXI_TYPEDEF_B_CHAN_T(axi_tb_b_t, axi_tb_id_t, logic);
  `AXI_TYPEDEF_AR_CHAN_T(axi_tb_ar_t, addr_t, axi_tb_id_t, logic);
  `AXI_TYPEDEF_R_CHAN_T(axi_tb_r_t, axi_data_t, axi_tb_id_t, logic);
  `AXI_TYPEDEF_REQ_T(axi_tb_req_t, axi_tb_aw_t, axi_tb_w_t, axi_tb_ar_t);
  `AXI_TYPEDEF_RESP_T(axi_tb_resp_t, axi_tb_b_t, axi_tb_r_t);

  `AXI_LITE_TYPEDEF_AW_CHAN_T(axi_lite_slv_aw_t, addr_t)
  `AXI_LITE_TYPEDEF_W_CHAN_T(axi_lite_slv_w_t, axi_lite_data_t, axi_lite_strb_t)
  `AXI_LITE_TYPEDEF_B_CHAN_T(axi_lite_slv_b_t)
  `AXI_LITE_TYPEDEF_AR_CHAN_T(axi_lite_slv_ar_t, addr_t)
  `AXI_LITE_TYPEDEF_R_CHAN_T(axi_lite_slv_r_t, axi_lite_data_t)
  `AXI_LITE_TYPEDEF_REQ_T(axi_lite_slv_req_t, axi_lite_slv_aw_t, axi_lite_slv_w_t, axi_lite_slv_ar_t)
  `AXI_LITE_TYPEDEF_RESP_T(axi_lite_slv_resp_t, axi_lite_slv_b_t, axi_lite_slv_r_t)

  /***********************
   *  INSTRUCTION CACHE  *
   ***********************/

  localparam int unsigned ICacheSizeByte  = 512 * NumCoresPerCache;     // Total Size of instruction cache in bytes
  localparam int unsigned ICacheSets      = NumCoresPerCache / 2;       // Number of sets
  localparam int unsigned ICacheLineWidth = 32 * 2 * NumCoresPerCache;  // Size of each cache line in bits,

  /**********************************
   *  TCDM INTERCONNECT PARAMETERS  *
   **********************************/

  typedef logic [TCDMAddrWidth-1:0] tcdm_addr_t;
  typedef logic [TCDMAddrMemWidth-1:0] bank_addr_t;
  typedef logic [TCDMAddrMemWidth+idx_width(NumBanksPerTile)-1:0] tile_addr_t;
  typedef logic [MetaIdWidth-1:0] meta_id_t;
  typedef logic [idx_width(NumCoresPerTile)-1:0] tile_core_id_t;
  typedef logic [idx_width(NumTilesPerGroup)-1:0] tile_group_id_t;
  typedef logic [idx_width(NumGroups)-1:0] group_id_t;
  typedef logic [3:0] amo_t;

  typedef struct packed {
    meta_id_t meta_id;
    tile_core_id_t core_id;
    amo_t amo;
    data_t data;
  } tcdm_payload_t;

  typedef struct packed {
    tcdm_payload_t wdata;
    logic wen;
    strb_t be;
    tcdm_addr_t tgt_addr;
  } tcdm_master_req_t;

  typedef struct packed {
    tcdm_payload_t rdata;
  } tcdm_master_resp_t;

  typedef struct packed {
    tcdm_payload_t wdata;
    logic wen;
    strb_t be;
    tile_addr_t tgt_addr;
    tile_group_id_t ini_addr;
  } tcdm_slave_req_t;

  typedef struct packed {
    tcdm_payload_t rdata;
    tile_group_id_t ini_addr;
  } tcdm_slave_resp_t;

  /*****************
   *  ADDRESS MAP  *
   *****************/

  // Size in bytes of memory that is sequentially addressable per tile
  localparam int unsigned SeqMemSizePerTile = NumCoresPerTile*1024; // 1 KiB

  typedef struct packed {
    int unsigned slave_idx;
    addr_t mask;
    addr_t value;
  } address_map_t;

  /***********************
   *  TRAFFIC GENERATOR  *
   ***********************/

  // Replaces core with a traffic generator
  parameter bit TrafficGeneration  = `ifdef TRAFFIC_GEN `TRAFFIC_GEN `else 0 `endif;

endpackage : mempool_pkg
