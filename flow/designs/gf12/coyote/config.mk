export DESIGN_NICKNAME = coyote
export DESIGN_NAME = bsg_rocket_node_client_rocc
export PLATFORM    = gf12

export VERILOG_FILES   = ./designs/src/$(DESIGN_NICKNAME)/coyote.sv2v.v \
                         ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/macros.v

export SDC_FILE        = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc
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

export PLACE_DENSITY = 0.35

export MACRO_WRAPPERS = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/wrappers.tcl

export DIE_AREA    = 0 0 752 752
export CORE_AREA   = 2 2 750 750
export PLACE_PINS_ARGS = -exclude left:* -exclude right:* -exclude top:* -exclude bottom:0-20 -exclude bottom:450-750

ifeq ($(USE_FILL),1)
export DESIGN_TYPE = CELL
else
export DESIGN_TYPE = CELL_NODEN
endif
