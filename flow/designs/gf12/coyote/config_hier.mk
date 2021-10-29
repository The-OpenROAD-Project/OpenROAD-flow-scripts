export DESIGN_NICKNAME = coyote
export DESIGN_NAME = bsg_rocket_node_client_rocc
export PLATFORM    = gf12

#export FLOW_VARIANT = hier
export FLOW_VARIANT = hier_rtlmp
export SYNTH_HIERARCHICAL = 1
export MAX_UNGROUP_SIZE = 100
export RTLMP_FLOW = True

export VERILOG_FILES   = ./designs/src/$(DESIGN_NICKNAME)/coyote.sv2v.v \
                         ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/macros.v

export SDC_FILE        = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint_hier.sdc
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

export FLOORPLAN_DEF = ./results/$(PLATFORM)/$(DESIGN_NICKNAME)/$(FLOW_VARIANT)/2_2_floorplan_io.def
#
# RTL_MP Settings
export RTLMP_MAX_INST = 20000
export RTLMP_MIN_INST = 4000
export RTLMP_MAX_MACRO = 10
export RTLMP_MIN_MACRO = 5 
export RTLMP_RPT_DIR = $(OBJECTS_DIR)/rtl_mp
export RTLMP_RPT_FILE = partition.txt
export RTLMP_CONFIG_FILE = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/rtlmp_config.txt
export RTLMP_BLOCKAGE_FILE = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/macro_blockage.txt

export ABC_CLOCK_PERIOD_IN_PS = 1250

export PLACE_DENSITY = 0.35

export MACRO_WRAPPERS = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/wrappers.tcl

export MACRO_BLOCKAGE_HALO = 25
export DIE_AREA    = 0 0 900 900
export CORE_AREA   = 2 2 898 898 
export PLACE_PINS_ARGS = -exclude left:* -exclude right:* -exclude top:0-350 -exclude top:650-900 -exclude bottom:*

export DESIGN_TYPE = CELL
