$(info [INFO-FLOW] ASU ASAP7 - version 2)

FOUNDRY_DIR                   := $(realpath $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))

export FOUNDRY_DIR            := $(PLATFORM_DIR)

export PLATFORM                = asap7
export PROCESS                 = 7

export OPENROAD_PATCHES        +=

# Placement site for core cells
# This can be found in the technology lef
export PLACE_SITE              = asap7sc7p5t

# Set the TIEHI/TIELO cells
# These are used in yosys synthesis to avoid logical 1/0's in the netlist
export TIEHI_CELL_AND_PORT     = TIEHIx1_ASAP7_75t_R H
export TIELO_CELL_AND_PORT     = TIELOx1_ASAP7_75t_R L

# Used in synthesis
export MIN_BUF_CELL_AND_PORTS  = BUFx2_ASAP7_75t_R A Y

# Used in synthesis
export MAX_FANOUT              = 40

export MAKE_TRACKS             = $(FOUNDRY_DIR)/openRoad/make_tracks.tcl

# Yosys mapping files
# Blackbox - list all standard cells and cells yosys should treat as blackboxes
export BLACKBOX_V_FILE         = $(FOUNDRY_DIR)/yoSys/asap7sc7p5t.blackbox.v
export LATCH_MAP_FILE          = $(FOUNDRY_DIR)/yoSys/cells_latch.v
export CLKGATE_MAP_FILE        = $(FOUNDRY_DIR)/yoSys/cells_clkgate.v
export ADDER_MAP_FILE         ?= $(FOUNDRY_DIR)/yoSys/cells_adders.v
export BLACKBOX_MAP_TCL        = $(FOUNDRY_DIR)/yoSys/blackbox_map.tcl

export BC_LIB_FILES            = $(FOUNDRY_DIR)/lib/asap7sc7p5t_AO_RVT_FF_nldm_201020.lib \
                                 $(FOUNDRY_DIR)/lib/asap7sc7p5t_INVBUF_RVT_FF_nldm_201020.lib \
                                 $(FOUNDRY_DIR)/lib/asap7sc7p5t_OA_RVT_FF_nldm_201020.lib \
                                 $(FOUNDRY_DIR)/lib/asap7sc7p5t_SIMPLE_RVT_FF_nldm_201020.lib \
                                 $(FOUNDRY_DIR)/lib/asap7sc7p5t_SEQ_RVT_FF_nldm_201020.lib

export BC_DFF_LIB_FILE        = $(FOUNDRY_DIR)/lib/asap7sc7p5t_SEQ_RVT_FF_nldm_201020.lib

export WC_LIB_FILES           = $(FOUNDRY_DIR)/lib/asap7sc7p5t_AO_RVT_SS_nldm_201020.lib \
                                 $(FOUNDRY_DIR)/lib/asap7sc7p5t_INVBUF_RVT_SS_nldm_201020.lib \
                                 $(FOUNDRY_DIR)/lib/asap7sc7p5t_OA_RVT_SS_nldm_201020.lib \
                                 $(FOUNDRY_DIR)/lib/asap7sc7p5t_SEQ_RVT_SS_nldm_201020.lib \
                                 $(FOUNDRY_DIR)/lib/asap7sc7p5t_SIMPLE_RVT_SS_nldm_201020.lib

export WC_DFF_LIB_FILE        = $(FOUNDRY_DIR)/lib/asap7sc7p5t_SEQ_RVT_SS_nldm_201020.lib \

export TC_LIB_FILES           = $(FOUNDRY_DIR)/lib/asap7sc7p5t_AO_RVT_TT_nldm_201020.lib \
                                 $(FOUNDRY_DIR)/lib/asap7sc7p5t_INVBUF_RVT_TT_nldm_201020.lib \
                                 $(FOUNDRY_DIR)/lib/asap7sc7p5t_OA_RVT_TT_nldm_201020.lib \
                                 $(FOUNDRY_DIR)/lib/asap7sc7p5t_SEQ_RVT_TT_nldm_201020.lib \
                                 $(FOUNDRY_DIR)/lib/asap7sc7p5t_SIMPLE_RVT_TT_nldm_201020.lib

export TC_DFF_LIB_FILE        = $(FOUNDRY_DIR)/lib/asap7sc7p5t_SEQ_RVT_TT_nldm_201020.lib \

export BC_TEMPERATURE          = 25C
export TC_TEMPERATURE          = 0C
export WC_TEMPERATURE          = 100C

export TECH_LEF                = $(FOUNDRY_DIR)/lef/asap7_tech_1x_201209.lef
export SC_LEF                  = $(FOUNDRY_DIR)/lef/asap7sc7p5t_27_R_1x_201211.lef

export GDS_FILES               = $(FOUNDRY_DIR)/gds/asap7sc7p5t_27_R_1x_201211.gds

export TRITON_ROUTE_LEF_FILTER = $(FOUNDRY_DIR)/tritonRoute/LEF_filter.txt
export TRITON_ROUTE_TECH_LEF   = $(TECH_LEF)

# Cell padding in SITE widths to ease rout-ability.  Applied to both sides
export CELL_PAD_IN_SITES_GLOBAL_PLACEMENT ?= 2
export CELL_PAD_IN_SITES_DETAIL_PLACEMENT ?= 1

# Endcap and Welltie cells
export TAPCELL_TCL             = $(FOUNDRY_DIR)/openRoad/tapcell.tcl

# TritonCTS options
export CTS_BUF_CELL            = BUFx4_ASAP7_75t_R

#export CTS_TECH_DIR           = $(FOUNDRY_DIR)/tritonCTS
export CTS_SQR_CAP             = 2.28541e-4
export CTS_SQR_RES             = 1.832146e-0
export CTS_SLEW_INTER          = 7.5e-13
export CTS_CAP_INTER           = 65.0e-17
export CTS_MAX_SLEW            = 1.77e-9
export CTS_MAX_CAP             = 0.968693e-12

export CTS_BUF_DISTANCE        = 60

# Route options
export MIN_ROUTING_LAYER       = M2
export MAX_ROUTING_LAYER       = M7

# IO Pin fix margin
export IO_PIN_MARGIN           = 70

# Layer to use for parasitics estimations
export WIRE_RC_LAYER           = M3

# resizer repair_long_wires -max_length
export MAX_WIRE_LENGTH         = 1000

# KLayout technology file
export KLAYOUT_TECH_FILE       = $(FOUNDRY_DIR)/KLayout/asap7.lyt

# KLayout DRC ruledeck
export KLAYOUT_DRC_FILE        = 

# Dont use cells to ease congestion
# Specify at least one filler cell if none
export DONT_USE_CELLS          = *x1_ASAP7* *x1p*_ASAP7* *xp*_ASAP7*
export DONT_USE_CELLS          += SDF* ICG* DFFH* 

# Fill cells used in fill cell insertion
#export FILL_CELLS              = "FILLER_ASAP7_75t_R FILLERxp5_ASAP7_75t_R"
export FILL_CELLS              = "FILLERxp5_ASAP7_75t_R"

#export POST_MERGELIB           = $(FOUNDRY_DIR)/openRoad/post_mergeLib.py

# Template definition for power grid analysis
export TEMPLATE_PGA_CFG        = $(FOUNDRY_DIR)/pdn/template_pga.cfg

# IO Placer pin layers
export IO_PLACER_H             = M4
export IO_PLACER_V             = M5

# Set yosys-abc clock period to first "-period" found in sdc file
export ABC_DRIVER_CELL         = BUFx2_ASAP7_75t_R

# BUF_X1, pin (A) = 0.974659. Arbitrarily multiply by 4
export ABC_LOAD_IN_FF          = 3.898

export SET_RC_TCL              = $(FOUNDRY_DIR)/openRoad/setRC.tcl

# OpenRCX extRules
export RCX_RULES               = ./platforms/$(PLATFORM)/rcx_patterns.rules

# XS - defining function for selecting different timing library set
# XS - defining function for 4x sizing
ifdef ($(ASAP7_USE4X))
  export 4X                      = 1
  export TECH_LEF                = $(FOUNDRY_DIR)/lef/asap7_tech_4x_201209.lef
  export SC_LEF                  = $(FOUNDRY_DIR)/lef/asap7sc7p5t_27_R_4x_201211.lef
  export GDS_FILES               = $(FOUNDRY_DIR)/gds/asap7sc7p5t_27_R_4x_201211.gds
endif

# XS - defining function for using LVT
ifdef ($(ASAP7_USELVT))
  export TIEHI_CELL_AND_PORT     = TIEHIx1_ASAP7_75t_L H
  export TIELO_CELL_AND_PORT     = TIELOx1_ASAP7_75t_L L

  export MIN_BUF_CELL_AND_PORTS  = BUFx2_ASAP7_75t_L A Y

  export HOLD_BUF_CELL           = BUFx2_ASAP7_75t_L

  export BC_LIB_FILES            = $(FOUNDRY_DIR)/lib/asap7sc7p5t_AO_LVT_FF_nldm_201020.lib \
                                   $(FOUNDRY_DIR)/lib/asap7sc7p5t_INVBUF_LVT_FF_nldm_201020.lib \
                                   $(FOUNDRY_DIR)/lib/asap7sc7p5t_OA_LVT_FF_nldm_201020.lib \
                                   $(FOUNDRY_DIR)/lib/asap7sc7p5t_SIMPLE_LVT_FF_nldm_201020.lib \
                                   $(FOUNDRY_DIR)/lib/asap7sc7p5t_SEQ_LVT_FF_nldm_201020.lib

  export WC_LIB_FILES           = $(FOUNDRY_DIR)/lib/asap7sc7p5t_AO_LVT_SS_nldm_201020.lib \
                                   $(FOUNDRY_DIR)/lib/asap7sc7p5t_INVBUF_LVT_SS_nldm_201020.lib \
                                   $(FOUNDRY_DIR)/lib/asap7sc7p5t_OA_LVT_SS_nldm_201020.lib \
                                   $(FOUNDRY_DIR)/lib/asap7sc7p5t_SEQ_LVT_SS_nldm_201020.lib \
                                   $(FOUNDRY_DIR)/lib/asap7sc7p5t_SIMPLE_LVT_SS_nldm_201020.lib

  export TC_LIB_FILES           = $(FOUNDRY_DIR)/lib/asap7sc7p5t_AO_LVT_TT_nldm_201020.lib \
                                   $(FOUNDRY_DIR)/lib/asap7sc7p5t_INVBUF_LVT_TT_nldm_201020.lib \
                                   $(FOUNDRY_DIR)/lib/asap7sc7p5t_OA_LVT_TT_nldm_201020.lib \
                                   $(FOUNDRY_DIR)/lib/asap7sc7p5t_SEQ_LVT_TT_nldm_201020.lib \
                                   $(FOUNDRY_DIR)/lib/asap7sc7p5t_SIMPLE_LVT_TT_nldm_201020.lib

endif
