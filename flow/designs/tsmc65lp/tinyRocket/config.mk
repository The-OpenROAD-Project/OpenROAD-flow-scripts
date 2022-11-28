export DESIGN_NAME = tinyRocket
export DESIGN_TOP_NAME = RocketTile
export PLATFORM    = tsmc65lp

export VERILOG_FILES = ./designs/src/$(DESIGN_NAME)/AsyncResetReg.v \
                       ./designs/src/$(DESIGN_NAME)/ClockDivider2.v \
                       ./designs/src/$(DESIGN_NAME)/ClockDivider3.v \
                       ./designs/src/$(DESIGN_NAME)/plusarg_reader.v \
                       ./designs/src/$(DESIGN_NAME)/freechips.rocketchip.system.TinyConfig.v \
                       ./designs/$(PLATFORM)/$(DESIGN_NAME)/macros.v

export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc

export ADDITIONAL_LEFS = $(PLATFORM_DIR)/lef/tsmc65lp_1rf_lg6_w32_byte.lef \
                         $(PLATFORM_DIR)/lef/tsmc65lp_1rf_lg6_w32_all.lef \
                         $(PLATFORM_DIR)/lef/tsmc65lp_2rf_lg10_w32_bit.lef
export ADDITIONAL_LIBS = $(PLATFORM_DIR)/lib/tsmc65lp_1rf_lg6_w32_byte_ss_1p08v_1p08v_125c.lib \
                         $(PLATFORM_DIR)/lib/tsmc65lp_1rf_lg6_w32_all_ss_1p08v_1p08v_125c.lib \
                         $(PLATFORM_DIR)/lib/tsmc65lp_2rf_lg10_w32_bit_ss_1p08v_1p08v_125c.lib
export ADDITIONAL_GDS  = $(PLATFORM_DIR)/gds/tsmc65lp_1rf_lg6_w32_byte.gds2 \
                         $(PLATFORM_DIR)/gds/tsmc65lp_1rf_lg6_w32_all.gds2 \
                         $(PLATFORM_DIR)/gds/tsmc65lp_2rf_lg10_w32_bit.gds2

# These values must be multiples of placement site
export DIE_AREA    = 0 0 925 806.4
export CORE_AREA   = 10 12 915 796.8
