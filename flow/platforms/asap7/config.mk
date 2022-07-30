$(info [INFO-FLOW] ASU ASAP7 - version 2)

export PLATFORM                = asap7
export PROCESS                 = 7

#Library Setup variable
export TECH_LEF                = $(PLATFORM_DIR)/lef/asap7_tech_1x_201209.lef
export SC_LEF                  = $(PLATFORM_DIR)/lef/asap7sc7p5t_27_R_1x_201211.lef

export GDS_FILES               = $(PLATFORM_DIR)/gds/asap7sc7p5t_27_R_1x_201211.gds \
                                 $(ADDITIONAL_GDS)

export BC_LIB_FILES            = $(PLATFORM_DIR)/lib/asap7sc7p5t_AO_RVT_FF_nldm_201020.lib \
				 $(PLATFORM_DIR)/lib/asap7sc7p5t_INVBUF_RVT_FF_nldm_201020.lib \
				 $(PLATFORM_DIR)/lib/asap7sc7p5t_OA_RVT_FF_nldm_201020.lib \
				 $(PLATFORM_DIR)/lib/asap7sc7p5t_SIMPLE_RVT_FF_nldm_201020.lib \
				 $(PLATFORM_DIR)/lib/asap7sc7p5t_SEQ_RVT_FF_nldm_201020.lib \
				 $(ADDITIONAL_LIBS)

export BC_DFF_LIB_FILE        = $(PLATFORM_DIR)/lib/asap7sc7p5t_SEQ_RVT_FF_nldm_201020.lib

export WC_LIB_FILES           = $(PLATFORM_DIR)/lib/asap7sc7p5t_AO_RVT_SS_nldm_201020.lib \
				$(PLATFORM_DIR)/lib/asap7sc7p5t_INVBUF_RVT_SS_nldm_201020.lib \
				$(PLATFORM_DIR)/lib/asap7sc7p5t_OA_RVT_SS_nldm_201020.lib \
				$(PLATFORM_DIR)/lib/asap7sc7p5t_SEQ_RVT_SS_nldm_201020.lib \
				$(PLATFORM_DIR)/lib/asap7sc7p5t_SIMPLE_RVT_SS_nldm_201020.lib \
				$(ADDITIONAL_LIBS)

export WC_DFF_LIB_FILE        = $(PLATFORM_DIR)/lib/asap7sc7p5t_SEQ_RVT_SS_nldm_201020.lib

export TC_LIB_FILES           = $(PLATFORM_DIR)/lib/asap7sc7p5t_AO_RVT_TT_nldm_201020.lib \
				$(PLATFORM_DIR)/lib/asap7sc7p5t_INVBUF_RVT_TT_nldm_201020.lib \
				$(PLATFORM_DIR)/lib/asap7sc7p5t_OA_RVT_TT_nldm_201020.lib \
				$(PLATFORM_DIR)/lib/asap7sc7p5t_SEQ_RVT_TT_nldm_201020.lib \
				$(PLATFORM_DIR)/lib/asap7sc7p5t_SIMPLE_RVT_TT_nldm_201020.lib \
				$(ADDITIONAL_LIBS)

export TC_DFF_LIB_FILE        = $(PLATFORM_DIR)/lib/asap7sc7p5t_SEQ_RVT_TT_nldm_201020.lib

export BC_TEMPERATURE          = 25C
export TC_TEMPERATURE          = 0C
export WC_TEMPERATURE          = 100C

export BC_VOLTAGE          = 0.77
export TC_VOLTAGE          = 0.70
export WC_VOLTAGE          = 0.63

# Dont use cells to ease congestion
# Specify at least one filler cell if none
export DONT_USE_CELLS          = *x1p*_ASAP7* *xp*_ASAP7*
export DONT_USE_CELLS          += SDF* ICG* DFFH*

# Yosys mapping files
# Blackbox - list all standard cells and cells yosys should treat as blackboxes
export BLACKBOX_V_FILE         = $(PLATFORM_DIR)/yoSys/asap7sc7p5t.blackbox.v
export LATCH_MAP_FILE          = $(PLATFORM_DIR)/yoSys/cells_latch.v
export CLKGATE_MAP_FILE        = $(PLATFORM_DIR)/yoSys/cells_clkgate.v
export ADDER_MAP_FILE         ?= $(PLATFORM_DIR)/yoSys/cells_adders.v
export BLACKBOX_MAP_TCL        = $(PLATFORM_DIR)/yoSys/blackbox_map.tcl

# Set yosys-abc clock period to first "clk_period" value or "-period" value found in sdc file
export ABC_CLOCK_PERIOD_IN_PS ?= $(shell sed -nr "s/^set\s+clk_period\s+(\S+).*|.*-period\s+(\S+).*/\1\2/p" $(SDC_FILE) | head -1 | awk '{print $$1}')
export ABC_DRIVER_CELL         = BUFx2_ASAP7_75t_R

# BUF_X1, pin (A) = 0.974659. Arbitrarily multiply by 4
export ABC_LOAD_IN_FF          = 3.898

# Set the TIEHI/TIELO cells
# These are used in yosys synthesis to avoid logical 1/0's in the netlist
export TIEHI_CELL_AND_PORT     = TIEHIx1_ASAP7_75t_R H
export TIELO_CELL_AND_PORT     = TIELOx1_ASAP7_75t_R L

# Used in synthesis
export MIN_BUF_CELL_AND_PORTS  = BUFx2_ASAP7_75t_R A Y

# Placement site for core cells
# This can be found in the technology lef
export PLACE_SITE              = asap7sc7p5t

export MAKE_TRACKS             = $(PLATFORM_DIR)/openRoad/make_tracks.tcl

# Define default PDN config
export PDN_TCL ?= $(PLATFORM_DIR)/openRoad/pdn/grid_strategy-M2-M5-M7.tcl

# IO Placer pin layers
export IO_PLACER_H             = M4
export IO_PLACER_V             = M5

export MACRO_PLACE_HALO ?= 10 10
export MACRO_PLACE_CHANNEL ?= 12 12

# Cell padding in SITE widths to ease rout-ability.  Applied to both sides
export CELL_PAD_IN_SITES_GLOBAL_PLACEMENT ?= 2
export CELL_PAD_IN_SITES_DETAIL_PLACEMENT ?= 1

export PLACE_DENSITY ?= 0.60

# Endcap and Welltie cells
export TAPCELL_TCL             = $(PLATFORM_DIR)/openRoad/tapcell.tcl

# TritonCTS options
export CTS_BUF_CELL            ?= BUFx4_ASAP7_75t_R

export CTS_BUF_DISTANCE        = 60

# Fill cells used in fill cell insertion
export FILL_CELLS              = "FILLERxp5_ASAP7_75t_R"


export SET_RC_TCL              = $(PLATFORM_DIR)/setRC.tcl

# Route options
export MIN_ROUTING_LAYER       = M2
export MAX_ROUTING_LAYER       = M7

# KLayout technology file
export KLAYOUT_TECH_FILE       = $(PLATFORM_DIR)/KLayout/asap7.lyt

# OpenRCX extRules
export RCX_RULES               = $(PLATFORM_DIR)/rcx_patterns.rules

# XS - defining function for selecting different timing library set
# XS - defining function for 4x sizing
ifdef ($(ASAP7_USE4X))
   export 4X                      = 1
   export TECH_LEF                = $(PLATFORM_DIR)/lef/asap7_tech_4x_201209.lef
   export SC_LEF                  = $(PLATFORM_DIR)/lef/asap7sc7p5t_27_R_4x_201211.lef
   export GDS_FILES               = $(PLATFORM_DIR)/gds/asap7sc7p5t_27_R_4x_201211.gds
endif

# XS - defining function for using LVT
ifdef ($(ASAP7_USELVT))
   export TIEHI_CELL_AND_PORT     = TIEHIx1_ASAP7_75t_L H
   export TIELO_CELL_AND_PORT     = TIELOx1_ASAP7_75t_L L

   export MIN_BUF_CELL_AND_PORTS  = BUFx2_ASAP7_75t_L A Y

   export HOLD_BUF_CELL           = BUFx2_ASAP7_75t_L

   export BC_LIB_FILES           = $(PLATFORM_DIR)/lib/asap7sc7p5t_AO_LVT_FF_nldm_201020.lib \
			           $(PLATFORM_DIR)/lib/asap7sc7p5t_INVBUF_LVT_FF_nldm_201020.lib \
			           $(PLATFORM_DIR)/lib/asap7sc7p5t_OA_LVT_FF_nldm_201020.lib \
			           $(PLATFORM_DIR)/lib/asap7sc7p5t_SIMPLE_LVT_FF_nldm_201020.lib \
			           $(PLATFORM_DIR)/lib/asap7sc7p5t_SEQ_LVT_FF_nldm_201020.lib

   export WC_LIB_FILES           = $(PLATFORM_DIR)/lib/asap7sc7p5t_AO_LVT_SS_nldm_201020.lib \
				   $(PLATFORM_DIR)/lib/asap7sc7p5t_INVBUF_LVT_SS_nldm_201020.lib \
				   $(PLATFORM_DIR)/lib/asap7sc7p5t_OA_LVT_SS_nldm_201020.lib \
				   $(PLATFORM_DIR)/lib/asap7sc7p5t_SEQ_LVT_SS_nldm_201020.lib \
				   $(PLATFORM_DIR)/lib/asap7sc7p5t_SIMPLE_LVT_SS_nldm_201020.lib

   export TC_LIB_FILES           = $(PLATFORM_DIR)/lib/asap7sc7p5t_AO_LVT_TT_nldm_201020.lib \
				   $(PLATFORM_DIR)/lib/asap7sc7p5t_INVBUF_LVT_TT_nldm_201020.lib \
				   $(PLATFORM_DIR)/lib/asap7sc7p5t_OA_LVT_TT_nldm_201020.lib \
				   $(PLATFORM_DIR)/lib/asap7sc7p5t_SEQ_LVT_TT_nldm_201020.lib \
				   $(PLATFORM_DIR)/lib/asap7sc7p5t_SIMPLE_LVT_TT_nldm_201020.lib

endif

#Dont use SC library based on CORNER selection
ifeq ($(CORNER),)
   export CORNER = BC
   $(info Default PVT selection: $(CORNER))
   export LIB_FILES             += $($(CORNER)_LIB_FILES)
   export LIB_DIRS              += $($(CORNER)_LIB_DIRS)
   export TEMPERATURE            = $($(CORNER)_TEMPERATURE)
   export VOLTAGE                = $($(CORNER)_VOLTAGE)
   export DONT_USE_SC_LIB        = $(OBJECTS_DIR)/lib/merged.lib
else
   $(info User PVT selection: $(CORNER))
   export LIB_FILES             += $($(CORNER)_LIB_FILES)
   export LIB_DIRS              += $($(CORNER)_LIB_DIRS)
   export TEMPERATURE            = $($(CORNER)_TEMPERATURE)
   export VOLTAGE                = $($(CORNER)_VOLTAGE)
   export DONT_USE_SC_LIB        = $(OBJECTS_DIR)/lib/merged.lib
endif
# ---------------------------------------------------------
#  IR Drop
# ---------------------------------------------------------

# IR drop estimation supply net name to be analyzed and supply voltage variable
# For multiple nets: PWR_NETS_VOLTAGES  = "VDD1 1.8 VDD2 1.2"
export PWR_NETS_VOLTAGES  ?= "VDD $(VOLTAGE)"
export GND_NETS_VOLTAGES  ?= "VSS 0.0"
export IR_DROP_LAYER ?= M1
