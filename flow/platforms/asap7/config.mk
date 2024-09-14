export PLATFORM                = asap7
export PROCESS                 = 7

ifeq ($(LIB_MODEL),)
   export LIB_MODEL = NLDM
endif
export LIB_DIR                ?= $(PLATFORM_DIR)/lib/$(LIB_MODEL)

#Library Setup variable
export TECH_LEF                = $(PLATFORM_DIR)/lef/asap7_tech_1x_201209.lef
export SC_LEF                  = $(PLATFORM_DIR)/lef/asap7sc7p5t_28_R_1x_220121a.lef

export GDS_FILES               = $(PLATFORM_DIR)/gds/asap7sc7p5t_28_R_220121a.gds \
                                 $(ADDITIONAL_GDS)

export BC_NLDM_LIB_FILES            = $(LIB_DIR)/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz \
				 $(LIB_DIR)/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz \
				 $(LIB_DIR)/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz \
				 $(LIB_DIR)/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz \
				 $(LIB_DIR)/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib \
				 $(BC_ADDITIONAL_LIBS)

export BC_NLDM_DFF_LIB_FILE        = $(LIB_DIR)/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib

export BC_CCS_LIB_FILES            = $(LIB_DIR)/asap7sc7p5t_AO_RVT_FF_ccs_211120.lib.gz \
				 $(LIB_DIR)/asap7sc7p5t_INVBUF_RVT_FF_ccs_220122.lib.gz \
				 $(LIB_DIR)/asap7sc7p5t_OA_RVT_FF_ccs_211120.lib.gz \
				 $(LIB_DIR)/asap7sc7p5t_SIMPLE_RVT_FF_ccs_211120.lib.gz \
				 $(LIB_DIR)/asap7sc7p5t_SEQ_RVT_FF_ccs_220123.lib \
				 $(BC_ADDITIONAL_LIBS)

export BC_CCS_DFF_LIB_FILE        = $(LIB_DIR)/asap7sc7p5t_SEQ_RVT_FF_ccs_220123.lib

export WC_NLDM_LIB_FILES           = $(LIB_DIR)/asap7sc7p5t_AO_RVT_SS_nldm_211120.lib.gz \
				$(LIB_DIR)/asap7sc7p5t_INVBUF_RVT_SS_nldm_220122.lib.gz \
				$(LIB_DIR)/asap7sc7p5t_OA_RVT_SS_nldm_211120.lib.gz \
				$(LIB_DIR)/asap7sc7p5t_SEQ_RVT_SS_nldm_220123.lib \
				$(LIB_DIR)/asap7sc7p5t_SIMPLE_RVT_SS_nldm_211120.lib.gz \
				$(WC_ADDITIONAL_LIBS)

export WC_NLDM_DFF_LIB_FILE        = $(LIB_DIR)/asap7sc7p5t_SEQ_RVT_SS_nldm_220123.lib

export TC_NLDM_LIB_FILES           = $(LIB_DIR)/asap7sc7p5t_AO_RVT_TT_nldm_211120.lib.gz \
				$(LIB_DIR)/asap7sc7p5t_INVBUF_RVT_TT_nldm_220122.lib.gz \
				$(LIB_DIR)/asap7sc7p5t_OA_RVT_TT_nldm_211120.lib.gz \
				$(LIB_DIR)/asap7sc7p5t_SEQ_RVT_TT_nldm_220123.lib \
				$(LIB_DIR)/asap7sc7p5t_SIMPLE_RVT_TT_nldm_211120.lib.gz \
				$(TC_ADDITIONAL_LIBS)

export TC_NLDM_DFF_LIB_FILE        = $(LIB_DIR)/asap7sc7p5t_SEQ_RVT_TT_nldm_220123.lib

ifdef CLUSTER_FLOPS
  # Add the multi-bit FF for clustering.  These are single corner libraries.
  export ADDITIONAL_LIBS     += $(LIB_DIR)/asap7sc7p5t_DFFHQNH2V2X_RVT_TT_nldm_FAKE.lib \
                                $(LIB_DIR)/asap7sc7p5t_DFFHQNV2X_RVT_TT_nldm_FAKE.lib
#                               $(LIB_DIR)/asap7sc7p5t_DFFHQNV4X_RVT_TT_nldm_FAKE.lib

  export ADDITIONAL_LEFS     += $(PLATFORM_DIR)/lef/asap7sc7p5t_DFFHQNH2V2X.lef \
                                $(PLATFORM_DIR)/lef/asap7sc7p5t_DFFHQNV2X.lef
#                               $(PLATFORM_DIR)/lef/asap7sc7p5t_DFFHQNV4X.lef
  export ADDITIONAL_SITES    += asap7sc7p5t_pg
  export GDS_ALLOW_EMPTY     ?= DFFHQN[VH][24].*
endif



export BC_TEMPERATURE          = 25C
export TC_TEMPERATURE          = 0C
export WC_TEMPERATURE          = 100C

export BC_VOLTAGE          = 0.77
export TC_VOLTAGE          = 0.70
export WC_VOLTAGE          = 0.63

# Dont use cells to ease congestion
# Specify at least one filler cell if none
export DONT_USE_CELLS          = *x1p*_ASAP7* *xp*_ASAP7*
export DONT_USE_CELLS          += SDF* ICG*

# Yosys mapping files
export LATCH_MAP_FILE          = $(PLATFORM_DIR)/yoSys/cells_latch_R.v
export CLKGATE_MAP_FILE        = $(PLATFORM_DIR)/yoSys/cells_clkgate_R.v
export ADDER_MAP_FILE         ?= $(PLATFORM_DIR)/yoSys/cells_adders_R.v
export MAX_UNGROUP_SIZE       ?= 100

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
export PLACE_SITE              ?= asap7sc7p5t

export MAKE_TRACKS             = $(PLATFORM_DIR)/openRoad/make_tracks.tcl

# Define default PDN config
ifeq ($(BLOCKS),)
   export PDN_TCL ?= $(PLATFORM_DIR)/openRoad/pdn/grid_strategy-M1-M2-M5-M6.tcl
else
   export PDN_TCL ?= $(PLATFORM_DIR)/openRoad/pdn/BLOCKS_grid_strategy.tcl
endif


# IO Placer pin layers
export IO_PLACER_H             ?= M4
export IO_PLACER_V             ?= M5

export MACRO_PLACE_HALO        ?= 10 10
export MACRO_PLACE_CHANNEL     ?= 12 12

# the followings create a keep out / halo between
# macro and core rows
export MACRO_HALO_X            ?= 2
export MACRO_HALO_Y            ?= 2

export PLACE_DENSITY ?= 0.60

# Endcap and Welltie cells
export TAPCELL_TCL             ?= $(PLATFORM_DIR)/openRoad/tapcell.tcl

# Fill cells used in fill cell insertion
export FILL_CELLS              ?= FILLERxp5_ASAP7_75t_R \
                                  FILLER_ASAP7_75t_R \
                                  DECAPx1_ASAP7_75t_R \
                                  DECAPx2_ASAP7_75t_R \
                                  DECAPx4_ASAP7_75t_R \
                                  DECAPx6_ASAP7_75t_R \
                                  DECAPx10_ASAP7_75t_R

export TAP_CELL_NAME           ?= TAPCELL_ASAP7_75t_R

export SET_RC_TCL              = $(PLATFORM_DIR)/setRC.tcl

# Route options
export MIN_ROUTING_LAYER       ?= M2
#export MIN_CLOCK_ROUTING_LAYER = M4
export MAX_ROUTING_LAYER       ?= M7

# KLayout technology file
export KLAYOUT_TECH_FILE       = $(PLATFORM_DIR)/KLayout/asap7.lyt

# KLayout DRC ruledeck
export KLAYOUT_DRC_FILE = $(PLATFORM_DIR)/drc/asap7.lydrc

# OpenRCX extRules
export RCX_RULES               = $(PLATFORM_DIR)/rcx_patterns.rules

# XS - defining function for using LVT
ifeq ($(ASAP7_USELVT), 1)
   export TIEHI_CELL_AND_PORT     = TIEHIx1_ASAP7_75t_L H
   export TIELO_CELL_AND_PORT     = TIELOx1_ASAP7_75t_L L

   export MIN_BUF_CELL_AND_PORTS  = BUFx2_ASAP7_75t_L A Y

   export HOLD_BUF_CELL           = BUFx2_ASAP7_75t_L

   export ABC_DRIVER_CELL         = BUFx2_ASAP7_75t_L

   export FILL_CELLS              ?= "FILLERxp5_ASAP7_75t_L"

   export TAP_CELL_NAME           ?= TAPCELL_ASAP7_75t_L

   export GDS_FILES               = $(PLATFORM_DIR)/gds/asap7sc7p5t_28_L_220121a.gds \
                                     $(ADDITIONAL_GDS)

   export SC_LEF                  = $(PLATFORM_DIR)/lef/asap7sc7p5t_28_L_1x_220121a.lef

   export LATCH_MAP_FILE          = $(PLATFORM_DIR)/yoSys/cells_latch_L.v
   export CLKGATE_MAP_FILE        = $(PLATFORM_DIR)/yoSys/cells_clkgate_L.v
   export ADDER_MAP_FILE         ?= $(PLATFORM_DIR)/yoSys/cells_adders_L.v

   export BC_NLDM_DFF_LIB_FILE         = $(LIB_DIR)/asap7sc7p5t_SEQ_LVT_FF_nldm_220123.lib

   export BC_NLDM_LIB_FILES            = $(LIB_DIR)/asap7sc7p5t_AO_LVT_FF_nldm_211120.lib.gz \
			            $(LIB_DIR)/asap7sc7p5t_INVBUF_LVT_FF_nldm_220122.lib.gz \
			            $(LIB_DIR)/asap7sc7p5t_OA_LVT_FF_nldm_211120.lib.gz \
			            $(LIB_DIR)/asap7sc7p5t_SIMPLE_LVT_FF_nldm_211120.lib.gz \
			            $(LIB_DIR)/asap7sc7p5t_SEQ_LVT_FF_nldm_220123.lib

   export WC_NLDM_DFF_LIB_FILE         = $(LIB_DIR)/asap7sc7p5t_SEQ_LVT_SS_nldm_220123.lib

   export WC_NLDM_LIB_FILES            = $(LIB_DIR)/asap7sc7p5t_AO_LVT_SS_nldm_211120.lib.gz \
				    $(LIB_DIR)/asap7sc7p5t_INVBUF_LVT_SS_nldm_220122.lib.gz \
				    $(LIB_DIR)/asap7sc7p5t_OA_LVT_SS_nldm_211120.lib.gz \
				    $(LIB_DIR)/asap7sc7p5t_SEQ_LVT_SS_nldm_220123.lib \
				    $(LIB_DIR)/asap7sc7p5t_SIMPLE_LVT_SS_nldm_211120.lib.gz

   export TC_NLDM_DFF_LIB_FILE         = $(LIB_DIR)/asap7sc7p5t_SEQ_LVT_TT_nldm_220123.lib

   export TC_NLDM_LIB_FILES            = $(LIB_DIR)/asap7sc7p5t_AO_LVT_TT_nldm_211120.lib.gz \
				    $(LIB_DIR)/asap7sc7p5t_INVBUF_LVT_TT_nldm_220122.lib.gz \
				    $(LIB_DIR)/asap7sc7p5t_OA_LVT_TT_nldm_211120.lib.gz \
				    $(LIB_DIR)/asap7sc7p5t_SEQ_LVT_TT_nldm_220123.lib \
				    $(LIB_DIR)/asap7sc7p5t_SIMPLE_LVT_TT_nldm_211120.lib.gz

endif

ifeq ($(ASAP7_USESLVT), 1)
   export TIEHI_CELL_AND_PORT     = TIEHIx1_ASAP7_75t_SL H
   export TIELO_CELL_AND_PORT     = TIELOx1_ASAP7_75t_SL L

   export MIN_BUF_CELL_AND_PORTS  = BUFx2_ASAP7_75t_SL A Y

   export HOLD_BUF_CELL           = BUFx2_ASAP7_75t_SL

   export ABC_DRIVER_CELL         = BUFx2_ASAP7_75t_SL

   export FILL_CELLS              ?= "FILLERxp5_ASAP7_75t_SL"

   export TAP_CELL_NAME		  ?= TAPCELL_ASAP7_75t_SL

   export GDS_FILES               = $(PLATFORM_DIR)/gds/asap7sc7p5t_28_SL_220121a.gds \
				    $(ADDITIONAL_GDS)

   export SC_LEF                  = $(PLATFORM_DIR)/lef/asap7sc7p5t_28_SL_1x_220121a.lef

   export LATCH_MAP_FILE          = $(PLATFORM_DIR)/yoSys/cells_latch_SL.v
   export CLKGATE_MAP_FILE        = $(PLATFORM_DIR)/yoSys/cells_clkgate_SL.v
   export ADDER_MAP_FILE         ?= $(PLATFORM_DIR)/yoSys/cells_adders_SL.v

   export BC_NLDM_DFF_LIB_FILE        = $(LIB_DIR)/asap7sc7p5t_SEQ_SLVT_FF_nldm_220123.lib

   export BC_NLDM_LIB_FILES           = $(LIB_DIR)/asap7sc7p5t_AO_SLVT_FF_nldm_211120.lib.gz \
			           $(LIB_DIR)/asap7sc7p5t_INVBUF_SLVT_FF_nldm_220122.lib.gz \
			           $(LIB_DIR)/asap7sc7p5t_OA_SLVT_FF_nldm_211120.lib.gz \
			           $(LIB_DIR)/asap7sc7p5t_SIMPLE_SLVT_FF_nldm_211120.lib.gz \
			           $(LIB_DIR)/asap7sc7p5t_SEQ_SLVT_FF_nldm_220123.lib

   export WC_NLDM_DFF_LIB_FILE        = $(LIB_DIR)/asap7sc7p5t_SEQ_SLVT_SS_nldm_220123.lib

   export WC_NLDM_LIB_FILES           = $(LIB_DIR)/asap7sc7p5t_AO_SLVT_SS_nldm_211120.lib.gz \
				   $(LIB_DIR)/asap7sc7p5t_INVBUF_SLVT_SS_nldm_220122.lib.gz \
				   $(LIB_DIR)/asap7sc7p5t_OA_SLVT_SS_nldm_211120.lib.gz \
				   $(LIB_DIR)/asap7sc7p5t_SEQ_SLVT_SS_nldm_220123.lib \
				   $(LIB_DIR)/asap7sc7p5t_SIMPLE_SLVT_SS_nldm_211120.lib.gz

   export TC_NLDM_DFF_LIB_FILE        = $(LIB_DIR)/asap7sc7p5t_SEQ_SLVT_TT_nldm_220123.lib

   export TC_NLDM_LIB_FILES           = $(LIB_DIR)/asap7sc7p5t_AO_SLVT_TT_nldm_211120.lib.gz \
				   $(LIB_DIR)/asap7sc7p5t_INVBUF_SLVT_TT_nldm_220122.lib.gz \
				   $(LIB_DIR)/asap7sc7p5t_OA_SLVT_TT_nldm_211120.lib.gz \
				   $(LIB_DIR)/asap7sc7p5t_SEQ_SLVT_TT_nldm_220123.lib \
				   $(LIB_DIR)/asap7sc7p5t_SIMPLE_SLVT_TT_nldm_211120.lib.gz

endif

# Dont use SC library based on CORNER selection
#
# BC - Best case, fastest
# WC - Worst case, slowest
# TC - Typical case
export CORNER ?= BC
export LIB_FILES             += $($(CORNER)_$(LIB_MODEL)_LIB_FILES)
export LIB_FILES             += $(ADDITIONAL_LIBS)
export DB_FILES              += $(realpath $($(CORNER)_DB_FILES))
export TEMPERATURE            = $($(CORNER)_TEMPERATURE)
export VOLTAGE                = $($(CORNER)_VOLTAGE)
export DONT_USE_SC_LIB        = $(OBJECTS_DIR)/lib/merged.lib

# ---------------------------------------------------------
#  IR Drop
# ---------------------------------------------------------

# IR drop estimation supply net name to be analyzed and supply voltage variable
# For multiple nets: PWR_NETS_VOLTAGES  = "VDD1 1.8 VDD2 1.2"
export PWR_NETS_VOLTAGES  ?= "VDD $(VOLTAGE)"
export GND_NETS_VOLTAGES  ?= "VSS 0.0"
export IR_DROP_LAYER ?= M1

# Allow empty GDS cell
export GDS_ALLOW_EMPTY ?= fakeram.*
