export DESIGN_NICKNAME = coyote
export DESIGN_NAME = bsg_rocket_node_client_rocc
export PLATFORM    = gf12

export SYNTH_HIERARCHICAL = 1
export MAX_UNGROUP_SIZE ?= 1000
export RTLMP_FLOW = True

export SDC_FILE        = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint_hier.sdc
#
# RTL_MP Settings
export RTLMP_MAX_INST = 25000
export RTLMP_MIN_INST = 5000
export RTLMP_MAX_MACRO = 10
export RTLMP_MIN_MACRO = 5 

export VERILOG_FILES   = ./designs/src/$(DESIGN_NICKNAME)/coyote.sv2v.v \
                         ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/macros.v

export ABC_AREA        = 1

export WRAP_LEFS       = $(PLATFORM_DIR)/lef/gf12_1rf_lg6_w80_bit.lef \
                         $(PLATFORM_DIR)/lef/gf12_1rf_lg8_w128_all.lef \
                         $(PLATFORM_DIR)/lef/gf12_2rf_lg6_w44_bit.lef \
                         $(PLATFORM_DIR)/lef/gf12_2rf_lg8_w64_bit.lef

export WRAP_LIBS       = $(PLATFORM_DIR)/lib/gf12_1rf_lg6_w80_bit_ffpg_sigcmin_0p88v_0p88v_m40c.lib \
                         $(PLATFORM_DIR)/lib/gf12_1rf_lg8_w128_all_ffpg_sigcmin_0p88v_0p88v_m40c.lib \
                         $(PLATFORM_DIR)/lib/gf12_2rf_lg6_w44_bit_ffpg_sigcmin_0p88v_0p88v_m40c.lib \
                         $(PLATFORM_DIR)/lib/gf12_2rf_lg8_w64_bit_ffpg_sigcmin_0p88v_0p88v_m40c.lib

export ADDITIONAL_GDS  = $(PLATFORM_DIR)/gds/gf12_1rf_lg6_w80_bit.gds2 \
                         $(PLATFORM_DIR)/gds/gf12_1rf_lg8_w128_all.gds2 \
                         $(PLATFORM_DIR)/gds/gf12_2rf_lg6_w44_bit.gds2 \
                         $(PLATFORM_DIR)/gds/gf12_2rf_lg8_w64_bit.gds2


export MACRO_WRAPPERS = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/wrappers.tcl

export DIE_AREA    = 0 0 1000 850
export CORE_AREA   = 2 2 998 848 
export PLACE_PINS_ARGS = -exclude left:* -exclude right:* -exclude top:0-350 -exclude top:650-1000 -exclude bottom:*
export HAS_IO_CONSTRAINTS = 1

export MACRO_PLACE_HALO = 5 5
export MACRO_PLACE_CHANNEL = 10 10

#export PLACE_DENSITY_LB = 0.38
export PLACE_DENSITY_LB_ADDON = 0.10 

ifneq ($(USE_FILL),)
export DESIGN_TYPE = CELL
else
export DESIGN_TYPE = CELL_NODEN
endif
