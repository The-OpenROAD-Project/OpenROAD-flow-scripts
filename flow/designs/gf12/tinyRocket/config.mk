export DESIGN_NICKNAME = tinyRocket
export DESIGN_NAME = RocketTile
export PLATFORM    = gf12

export SYNTH_HIERARCHICAL = 1
export SYNTH_MINIMUM_KEEP_SIZE ?= 1000

export VERILOG_FILES  = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/AsyncResetReg.v \
                        $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ClockDivider2.v \
                        $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ClockDivider3.v \
                        $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/plusarg_reader.v \
                        $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/freechips.rocketchip.system.TinyConfig.v \
                        $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/macros.v

export SDC_FILE       = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export WRAP_LEFS      = $(PLATFORM_DIR)/lef/gf12_1rf_lg6_w32_all.lef \
                        $(PLATFORM_DIR)/lef/gf12_1rf_lg6_w32_byte.lef

export WRAP_LIBS      = $(PLATFORM_DIR)/lib/gf12_1rf_lg6_w32_all_ffpg_sigcmin_0p88v_0p88v_m40c.lib \
                        $(PLATFORM_DIR)/lib/gf12_1rf_lg6_w32_byte_ffpg_sigcmin_0p88v_0p88v_m40c.lib \

#$(PLATFORM_DIR)/lib/gf12_2rf_lg10_w32_bit_ffpg_sigcmin_0p88v_0p88v_m40c.lib

export ADDITIONAL_GDS = $(PLATFORM_DIR)/gds/gf12_1rf_lg6_w32_all.gds2 \
                        $(PLATFORM_DIR)/gds/gf12_1rf_lg6_w32_byte.gds2

export CORE_UTILIZATION = 50
export PLACE_DENSITY_LB_ADDON = 0.10

export MACRO_WRAPPERS = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/wrappers.tcl

ifeq ($(USE_FILL),1)
export DESIGN_TYPE = CELL
else
export DESIGN_TYPE = CELL_NODEN
endif

export SWAP_ARITH_OPERATORS = 1
export OPENROAD_HIERARCHICAL = 1
