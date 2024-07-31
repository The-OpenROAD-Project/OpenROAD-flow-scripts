/* ****************************************************************************
  SPDX-License-Identifier: CERN-OHL-W-2.0

  Description: mor1kx SPRs indicating configuration and version

  All registers are read only and configured at synthesis time.

  Note that the outputs do not have the usual "_o" prefix on the port names
  as this module is intended to be instantiated without a Verilog-mode
  AUTO_TEMPLATE, and as the module is providing read-only signals, there's
  no confusion about the direction of the ports.

  Copyright (C) 2012 Authors

  Author(s): Julius Baxter <juliusbaxter@gmail.com>

***************************************************************************** */

`include "mor1kx-defines.v"

module mor1kx_cfgrs
  #(
    parameter FEATURE_SYSCALL            = "ENABLED",
    parameter FEATURE_TRAP               = "ENABLED",
    parameter FEATURE_RANGE              = "ENABLED",

    parameter FEATURE_DATACACHE          = "NONE",
    parameter OPTION_DCACHE_BLOCK_WIDTH  = 5,
    parameter OPTION_DCACHE_SET_WIDTH    = 9,
    parameter OPTION_DCACHE_WAYS         = 2,
    parameter FEATURE_DMMU               = "NONE",
    parameter [2:0] OPTION_DMMU_SET_WIDTH      = 6,
    parameter OPTION_DMMU_WAYS           = 1,
    parameter FEATURE_INSTRUCTIONCACHE   = "NONE",
    parameter OPTION_ICACHE_BLOCK_WIDTH  = 5,
    parameter OPTION_ICACHE_SET_WIDTH    = 9,
    parameter OPTION_ICACHE_WAYS         = 2,
    parameter FEATURE_IMMU               = "NONE",
    parameter OPTION_IMMU_SET_WIDTH      = 6,
    parameter OPTION_IMMU_WAYS           = 1,
    parameter FEATURE_PIC                = "ENABLED",
    parameter FEATURE_TIMER              = "ENABLED",
    parameter FEATURE_DEBUGUNIT          = "NONE",
    parameter FEATURE_PERFCOUNTERS       = "NONE",
    parameter OPTION_PERFCOUNTERS_NUM    = 0,
    parameter FEATURE_PMU                = "NONE",
    parameter FEATURE_MAC                = "NONE",
    parameter FEATURE_FPU                = "NONE",

    parameter OPTION_PIC_TRIGGER         = "LEVEL",

    parameter FEATURE_DSX                = "NONE",
    parameter FEATURE_FASTCONTEXTS       = "NONE",
    parameter OPTION_RF_NUM_SHADOW_GPR   = 0,
    parameter FEATURE_OVERFLOW           = "NONE",

    parameter FEATURE_DELAYSLOT          = "NONE",

    parameter FEATURE_EVBAR              = "NONE",
    parameter FEATURE_AECSR              = "NONE"
    )
   (
    output [31:0] spr_vr,
    output [31:0] spr_vr2,
    output [31:0] spr_upr,
    output [31:0] spr_cpucfgr,
    output [31:0] spr_dmmucfgr,
    output [31:0] spr_immucfgr,
    output [31:0] spr_dccfgr,
    output [31:0] spr_iccfgr,
    output [31:0] spr_dcfgr,
    output [31:0] spr_pccfgr,
    output [31:0] spr_avr
    );

   assign spr_vr[`OR1K_SPR_VR_REV] = 0;
   assign spr_vr[`OR1K_SPR_VR_UVRP] = 1;
   assign spr_vr[`OR1K_SPR_VR_RESERVED] = 0;
   assign spr_vr[`OR1K_SPR_VR_CFG] = 0;
   assign spr_vr[`OR1K_SPR_VR_VER] = 8'h10;

   assign spr_upr[`OR1K_SPR_UPR_UP] = 1;
   assign spr_upr[`OR1K_SPR_UPR_DCP] = (FEATURE_DATACACHE!="NONE");
   assign spr_upr[`OR1K_SPR_UPR_ICP] = (FEATURE_INSTRUCTIONCACHE!="NONE");
   assign spr_upr[`OR1K_SPR_UPR_DMP] = (FEATURE_DMMU!="NONE");
   assign spr_upr[`OR1K_SPR_UPR_IMP] = (FEATURE_IMMU!="NONE");
   assign spr_upr[`OR1K_SPR_UPR_MP] = (FEATURE_MAC!="NONE");
   assign spr_upr[`OR1K_SPR_UPR_DUP] = (FEATURE_DEBUGUNIT!="NONE");
   assign spr_upr[`OR1K_SPR_UPR_PCUP] = (FEATURE_PERFCOUNTERS!="NONE");
   assign spr_upr[`OR1K_SPR_UPR_PICP] = (FEATURE_PIC!="NONE");
   assign spr_upr[`OR1K_SPR_UPR_PMP] = (FEATURE_PMU!="NONE");
   assign spr_upr[`OR1K_SPR_UPR_TTP] = (FEATURE_TIMER!="NONE");
   assign spr_upr[`OR1K_SPR_UPR_RESERVED] = 0;
   assign spr_upr[`OR1K_SPR_UPR_CUP] = 0;

   assign spr_cpucfgr[`OR1K_SPR_CPUCFGR_NSGF] = OPTION_RF_NUM_SHADOW_GPR;
   assign spr_cpucfgr[`OR1K_SPR_CPUCFGR_CFG] = 0;
   assign spr_cpucfgr[`OR1K_SPR_CPUCFGR_OB32S] = 1;
   assign spr_cpucfgr[`OR1K_SPR_CPUCFGR_OB64S] = 0;
   assign spr_cpucfgr[`OR1K_SPR_CPUCFGR_OF32S] = (FEATURE_FPU!="NONE");
   assign spr_cpucfgr[`OR1K_SPR_CPUCFGR_OF64S] = 0;
   assign spr_cpucfgr[`OR1K_SPR_CPUCFGR_OV64S] = 0;
   assign spr_cpucfgr[`OR1K_SPR_CPUCFGR_ND] = (FEATURE_DELAYSLOT=="NONE");
   /* AVR will always be present in mor1kx */
   assign spr_cpucfgr[`OR1K_SPR_CPUCFGR_AVRP] = 1;
   assign spr_cpucfgr[`OR1K_SPR_CPUCFGR_EVBARP] = (FEATURE_EVBAR!="NONE");
   /* ISRs will always be present */
   assign spr_cpucfgr[`OR1K_SPR_CPUCFGR_ISRP] = 1;
   assign spr_cpucfgr[`OR1K_SPR_CPUCFGR_AECSRP] = (FEATURE_AECSR!="NONE");
   assign spr_cpucfgr[`OR1K_SPR_CPUCFGR_RESERVED] = 0;

   /* Version register 2 */
   /* Implementation ID as per:
      http://opencores.org/or1k/OR1K_CPU_Cores#CPU_ID_Table
      mor1kx breaks up the VR2[23:0] to be 3 8-bit fields
      23:16 - Major version number
      15:8  - Minor version number
      7:0   - Pipeline implementation identifier (set outside of this module)
   */
   assign spr_vr2[`OR1K_SPR_VR2_CPUID] = `MOR1KX_CPUID;
   assign spr_vr2[`OR1K_SPR_VR2_VER] = {`MOR1KX_VERSION_MAJOR,
                                        `MOR1KX_VERSION_MINOR,
                                        8'd0};

   /* Currently supporting OR1K version 1.1 rev0 */
   assign spr_avr[`OR1K_SPR_AVR_MAJ] = 8'd1;
   assign spr_avr[`OR1K_SPR_AVR_MIN] = 8'd1;
   assign spr_avr[`OR1K_SPR_AVR_REV] = 8'd0;
   assign spr_avr[`OR1K_SPR_AVR_RESERVED] = 0;

   /* Data MMU Configuration Register */
   /* Reserved */
   assign spr_dmmucfgr[31:12] = 0;
   /* Hardware TLB Reload */
   assign spr_dmmucfgr[`OR1K_SPR_DMMUFGR_HTR] = 0;
   /* TLB Entry Invalidate Register Implemented */
   assign spr_dmmucfgr[`OR1K_SPR_DMMUFGR_TEIRI] = 0;
   /* Protection Register Implemented */
   assign spr_dmmucfgr[`OR1K_SPR_DMMUFGR_PRI] = 0;
   /* Control Register Implemented */
   assign spr_dmmucfgr[`OR1K_SPR_DMMUFGR_CRI] = 0;
   /* Number of ATB entries */
   assign spr_dmmucfgr[`OR1K_SPR_DMMUFGR_NAE] = 0;
   /* Number of TLB sets */
   assign spr_dmmucfgr[`OR1K_SPR_DMMUFGR_NTS] = (FEATURE_DMMU!="NONE") ?
						OPTION_DMMU_SET_WIDTH : 0;
   /* Number of TLB ways */
   assign spr_dmmucfgr[`OR1K_SPR_DMMUFGR_NTW] = (FEATURE_DMMU!="NONE") ?
						OPTION_DMMU_WAYS-1 : 0;

   /* Instruction MMU Configuration Register */
   /* Reserved */
   assign spr_immucfgr[31:12] = 0;
   /* Hardware TLB Reload */
   assign spr_immucfgr[`OR1K_SPR_IMMUFGR_HTR] = 0;
   /* TLB Entry Invalidate Register Implemented */
   assign spr_immucfgr[`OR1K_SPR_IMMUFGR_TEIRI] = 0;
   /* Protection Register Implemented */
   assign spr_immucfgr[`OR1K_SPR_IMMUFGR_PRI] = 0;
   /* Control Register Implemented */
   assign spr_immucfgr[`OR1K_SPR_IMMUFGR_CRI] = 0;
   /* Number of ATB entries */
   assign spr_immucfgr[`OR1K_SPR_IMMUFGR_NAE] = 0;
   /* Number of TLB sets */
   assign spr_immucfgr[`OR1K_SPR_IMMUFGR_NTS] = (FEATURE_IMMU!="NONE") ?
						OPTION_IMMU_SET_WIDTH : 0;
   /* Number of TLB ways */
   assign spr_immucfgr[`OR1K_SPR_IMMUFGR_NTW] = (FEATURE_IMMU!="NONE") ?
						OPTION_IMMU_WAYS-1 : 0;

   /* Data Cache Configuration register */
   /* Reserved */
   assign spr_dccfgr[31:15] = 0;
   /* Cache Block Write-Back Register Implemented */
   assign spr_dccfgr[`OR1K_SPR_DCCFGR_CBWBRI] = 0;
   /* Cache Block Flush Register Implemented */
   assign spr_dccfgr[`OR1K_SPR_DCCFGR_CBFRI] = (FEATURE_DATACACHE!="NONE");
   /* Cache Block Lock Register Implemented */
   assign spr_dccfgr[`OR1K_SPR_DCCFGR_CBLRI] = 0;
   /* Cache Block Prefetch Register Implemented */
   assign spr_dccfgr[`OR1K_SPR_DCCFGR_CBPRI] = 0;
   /* Cache Block Invalidate Register Implemented */
   assign spr_dccfgr[`OR1K_SPR_DCCFGR_CBIRI] = (FEATURE_DATACACHE!="NONE");
   /* Cache Control Register Implemented */
   assign spr_dccfgr[`OR1K_SPR_DCCFGR_CCRI] = 0;
   /* Cache Write Strategy (0 = write-through, 1 = write-back) */
   assign spr_dccfgr[`OR1K_SPR_DCCFGR_CWS] = 0;
   /* Cache Block Size (0 = 16 bytes, 1 = 32 bytes) */
   assign spr_dccfgr[`OR1K_SPR_DCCFGR_CBS] = (FEATURE_DATACACHE!="NONE") ?
                                             (OPTION_DCACHE_BLOCK_WIDTH == 5 ?
					      1 : 0) :  0;
  /* Number of Cache Sets */
   assign spr_dccfgr[`OR1K_SPR_DCCFGR_NCS] = (FEATURE_DATACACHE!="NONE") ?
                                             OPTION_DCACHE_SET_WIDTH : 0;
   /* Number of Cache Ways */
   assign spr_dccfgr[`OR1K_SPR_DCCFGR_NCW] = (FEATURE_DATACACHE!="NONE") ?
                                             (OPTION_DCACHE_WAYS == 1) ? 3'd0 :
                                             (OPTION_DCACHE_WAYS == 2) ? 3'd1 :
                                             (OPTION_DCACHE_WAYS == 4) ? 3'd2 :
                                             (OPTION_DCACHE_WAYS == 8) ? 3'd3 :
                                             (OPTION_DCACHE_WAYS == 16) ? 3'd4 :
                                             (OPTION_DCACHE_WAYS == 32) ? 3'd5 :
                                             3'd0 : 3'd0;

   /* Instruction Cache Configuration register */
   /* Reserved */
   assign spr_iccfgr[31:13] = 0;
   assign spr_iccfgr[8] = 0;
   /* Cache Block Lock Register Implemented */
   assign spr_iccfgr[`OR1K_SPR_ICCFGR_CBLRI] = 0;
   /* Cache Block Prefetch Register Implemented */
   assign spr_iccfgr[`OR1K_SPR_ICCFGR_CBPRI] = 0;
   /* Cache Block Invalidate Register Implemented */
   assign spr_iccfgr[`OR1K_SPR_ICCFGR_CBIRI] = (FEATURE_INSTRUCTIONCACHE!="NONE");
   /* Cache Control Register Implemented */
   assign spr_iccfgr[`OR1K_SPR_ICCFGR_CCRI] = 0;
   /* Cache Block Size (0 = 16 bytes, 1 = 32 bytes) */
   assign spr_iccfgr[`OR1K_SPR_ICCFGR_CBS] = (FEATURE_INSTRUCTIONCACHE!="NONE") ?
                                             (OPTION_ICACHE_BLOCK_WIDTH == 5 ?
					      1 : 0) :  0;
  /* Number of Cache Sets */
   assign spr_iccfgr[`OR1K_SPR_ICCFGR_NCS] = (FEATURE_INSTRUCTIONCACHE!="NONE") ?
                                             OPTION_ICACHE_SET_WIDTH : 0;
   /* Number of Cache Ways */
   assign spr_iccfgr[`OR1K_SPR_ICCFGR_NCW] = (FEATURE_INSTRUCTIONCACHE!="NONE") ?
                                             (OPTION_ICACHE_WAYS == 1) ? 3'd0 :
                                             (OPTION_ICACHE_WAYS == 2) ? 3'd1 :
                                             (OPTION_ICACHE_WAYS == 4) ? 3'd2 :
                                             (OPTION_ICACHE_WAYS == 8) ? 3'd3 :
                                             (OPTION_ICACHE_WAYS == 16) ? 3'd4 :
                                             (OPTION_ICACHE_WAYS == 32) ? 3'd5 :
                                             3'd0 : 3'd0;

   assign spr_dcfgr = 0;
   assign spr_pccfgr = (FEATURE_PERFCOUNTERS!="NONE") ? OPTION_PERFCOUNTERS_NUM : 0;

endmodule // mor1kx_cfgrs
