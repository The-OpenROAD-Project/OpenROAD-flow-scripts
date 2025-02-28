// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

/// Snitch Configuration.
package snitch_pkg;

  import cf_math_pkg::idx_width;

  localparam DataWidth                  = 32;
  localparam StrbWidth                  = DataWidth/8;
  localparam int NumFPOutstandingLoads  = 4;
  // Use a high number of outstanding loads, if running a latency-throughput analysis
  localparam int NumIntOutstandingLoads = `ifdef TRAFFIC_GEN 2048 `else 8 `endif;
  localparam MetaIdWidth                = idx_width(NumIntOutstandingLoads);
  // Xpulpimg extension enabled?
  localparam bit XPULPIMG = `ifdef XPULPIMG `XPULPIMG `else 1'bX `endif;

  typedef logic [31:0]               addr_t;
  typedef logic [DataWidth-1:0]      data_t;
  typedef logic [StrbWidth-1:0]      strb_t;
  typedef logic [MetaIdWidth-1:0]    meta_id_t;

  typedef struct packed {
    addr_t       BootAddress;
    int unsigned NrCores;
  } SnitchCfg;

  typedef struct packed {
    addr_t addr;
    meta_id_t id;
    logic [3:0] amo;
    logic write;
    data_t data;
    strb_t strb;
  } dreq_t;

  typedef struct packed {
    data_t data;
    meta_id_t id;
    logic error;
  } dresp_t;

  typedef struct packed {
    addr_t addr;
    logic [4:0] id;
    logic [31:0] data_op;
    data_t data_arga;
    data_t data_argb;
    data_t data_argc;
  } acc_req_t;

  typedef struct packed {
    logic [4:0] id;
    logic error;
    data_t data;
  } acc_resp_t;

  // Number of instructions the sequencer can hold
  localparam int FPUSequencerInstr      = 16;
  // SSRs
  localparam logic [31:0] SSR_ADDR_BASE = 32'h20_4800;
  localparam logic [31:0] SSR_ADDR_MASK = 32'hffff_fe00;
  localparam logic [11:0] CSR_SSR       = 12'h7C0;
  localparam int SSRNrCredits           = 4;
  // Registers which are used as SSRs
  localparam [4:0] FT0                  = 5'b0;
  localparam [4:0] FT1                  = 5'b1;
  localparam [1:0][4:0] SSRRegs         = {FT1, FT0};
  function automatic logic is_ssr(logic [4:0] register);
    unique case (register)
      FT0, FT1: return 1'b1;
      default : return 0;
    endcase
  endfunction

  // Amount of address bit which should be used for accesses from the SoC side.
  // This effectively determines the Address Space of a Snitch Cluster.
  localparam logic [31:0] SoCRequestAddrBits = 32;

  // Address Map
  // TCDM, everything below 0x4000_0000
  localparam logic [31:0] TCDMStartAddress = 32'h0000_0000;
  localparam logic [31:0] TCDMMask         = '1 << 28;

  // Slaves on Cluster AXI Bus
  typedef enum integer {
    TCDM               = 0,
    ClusterPeripherals = 1,
    SoC                = 2
  } cluster_slave_e;

  typedef enum integer {
    CoreReq = 0,
    ICache  = 1,
    AXISoC  = 2
  } cluster_master_e;

  localparam int unsigned NrSlaves  = 3;
  localparam int unsigned NrMasters = 3;

  localparam int IdWidth      = 2;
  localparam int IdWidthSlave = $clog2(NrMasters) + IdWidth;

  //                                                    3. SoC         2. Cluster Peripherals  3. TCDM
  localparam logic [NrSlaves-1:0][31:0] StartAddress = {32'h8000_0000, 32'h4000_0000, TCDMStartAddress};
  localparam logic [NrSlaves-1:0][31:0] EndAddress   = {32'hFFFF_FFFF, 32'h5000_0000, TCDMStartAddress + 32'h1000_0000};
  localparam logic [NrSlaves-1:0] ValidRule          = {{NrSlaves}{1'b1}};

  // Cluster Peripheral Registers
  typedef enum logic [31:0] {
    TCDMStartAddressReg = 32'h4000_0000,
    TCDMEndAddressReg   = 32'h4000_0008,
    NrCoresReg          = 32'h4000_0010,
    FetchEnableReg      = 32'h4000_0018,
    ScratchReg          = 32'h4000_0020,
    WakeUpReg           = 32'h4000_0028,
    CycleCountReg       = 32'h4000_0030,
    BarrierReg          = 32'h4000_0038,
    TcdmAccessedReg     = 32'h4000_FFF0,
    TcdmCongestedReg    = 32'h4000_FFF8,
    PerfCounterBase     = 32'h4001_0000
  } cluster_peripheral_addr_e;

  // Offload to shared accelerator
  function automatic logic shared_offload (logic [31:0] instr);
    logic offload;
    unique casez (instr)
      riscv_instr::MUL,
      riscv_instr::MULH,
      riscv_instr::MULHSU,
      riscv_instr::MULHU,
      riscv_instr::DIV,
      riscv_instr::DIVU,
      riscv_instr::REM,
      riscv_instr::REMU,
      riscv_instr::MULW,
      riscv_instr::DIVW,
      riscv_instr::DIVUW,
      riscv_instr::REMW,
      riscv_instr::REMUW: offload = 1;
      default: offload            = 0;
    endcase
    return offload;
  endfunction

  // Event strobes per core, counted by the performance counters in the cluster
  // peripherals.
  typedef struct packed {
    logic issue_fpu;         // core operations performed in the FPU
    logic issue_fpu_seq;     // includes load/store operations
    logic issue_core_to_fpu; // instructions issued from core to FPU
    logic retired_insts;     // number of instructions retired by the core
  } core_events_t;

endpackage
