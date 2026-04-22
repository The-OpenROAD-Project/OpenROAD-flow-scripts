export DESIGN_NICKNAME = murax
export DESIGN_NAME = de1_murax_franz
export PLATFORM    = ihp-sg13g2

export VHDL_FILES = $(DESIGN_HOME)/src/murax/murax_pkg.vhd \
                    $(DESIGN_HOME)/src/murax/murax_ram.vhd \
                    $(DESIGN_HOME)/src/murax/de1_murax_franz.vhd

export SYNTH_HDL_FRONTEND = ghdl

export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export CORE_UTILIZATION = 60
export CORE_ASPECT_RATIO = 1

export ADDITIONAL_LEFS     = $(PLATFORM_DIR)/lef/RM_IHPSG13_1P_1024x8_c2_bm_bist.lef
export ADDITIONAL_TYP_LIBS = $(PLATFORM_DIR)/lib/RM_IHPSG13_1P_1024x8_c2_bm_bist_typ_1p20V_25C.lib
export ADDITIONAL_SLOW_LIBS = $(PLATFORM_DIR)/lib/RM_IHPSG13_1P_1024x8_c2_bm_bist_slow_1p08V_125C.lib
export ADDITIONAL_FAST_LIBS = $(PLATFORM_DIR)/lib/RM_IHPSG13_1P_1024x8_c2_bm_bist_fast_1p32V_m55C.lib
export ADDITIONAL_GDS      = $(PLATFORM_DIR)/gds/RM_IHPSG13_1P_1024x8_c2_bm_bist.gds

export PLACE_DENSITY = 0.65
export TNS_END_PERCENT = 100

export USE_FILL = 1

export REMOVE_ABC_BUFFERS = 1


