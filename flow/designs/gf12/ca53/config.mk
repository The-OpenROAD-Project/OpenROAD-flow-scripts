export DESIGN_NAME = ca53_cpu
export PLATFORM    = gf12


export VERILOG_FILES  = $(PLATFORM_DIR)/$(DESIGN_NAME)/rtl/ca53_cpu.v
export CACHED_NETLIST = $(PLATFORM_DIR)/$(DESIGN_NAME)/rtl/ca53_cpu.v

export SDC_FILE      = $(PLATFORM_DIR)/$(DESIGN_NAME)/sdc/ca53_cpu.sdc


export ADDITIONAL_LEFS += $(PLATFORM_DIR)/lef/sc9mcpp84_12lp_base_lvt_c14.lef
export ADDITIONAL_LIBS += $(PLATFORM_DIR)/lib/sc9mcpp84_12lp_base_lvt_c14_tt_nominal_max_0p80v_25c.lib
export ADDITIONAL_GDS  += $(PLATFORM_DIR)/gds/sc9mcpp84_12lp_base_lvt_c14.gds2

export WRAP_LEFS = $(PLATFORM_DIR)/$(DESIGN_NAME)/lef/RFSPHD_A53_HS_128X32M2_FB1FS1SB0PG1.lef \
                   $(PLATFORM_DIR)/$(DESIGN_NAME)/lef/RFSPHD_A53_HS_160X118M2_FB1FS2SB0PG1.lef \
                   $(PLATFORM_DIR)/$(DESIGN_NAME)/lef/RFSPHD_A53_HS_128X50M2_FB1FS2SB0PG1.lef \
                   $(PLATFORM_DIR)/$(DESIGN_NAME)/lef/RFSPHD_A53_HS_128X60M2_FB1FS2SB0PG1.lef \
                   $(PLATFORM_DIR)/$(DESIGN_NAME)/lef/RFSPHD_A53_HS_256X12M2_FB1FS1SB0WM1PG1.lef \
                   $(PLATFORM_DIR)/$(DESIGN_NAME)/lef/RFSPHD_A53_HS_256X32M2_FB1FS1SB0PG1.lef \
                   $(PLATFORM_DIR)/$(DESIGN_NAME)/lef/SRAMSPHD_A53_HS_1024X39M4_FB2FS2SB0PG1.lef \
                   $(PLATFORM_DIR)/$(DESIGN_NAME)/lef/SRAMSPHD_A53_HS_2048X42M4_FB2FS2SB0WM1PG1.lef

export WRAP_LIBS = $(PLATFORM_DIR)/$(DESIGN_NAME)/lib/RFSPHD_A53_HS_128X32M2_FB1FS1SB0PG1_tt_nominal_0p80v_0p80v_25c.lib \
                   $(PLATFORM_DIR)/$(DESIGN_NAME)/lib/RFSPHD_A53_HS_128X50M2_FB1FS2SB0PG1_tt_nominal_0p80v_0p80v_25c.lib \
                   $(PLATFORM_DIR)/$(DESIGN_NAME)/lib/RFSPHD_A53_HS_128X60M2_FB1FS2SB0PG1_tt_nominal_0p80v_0p80v_25c.lib \
                   $(PLATFORM_DIR)/$(DESIGN_NAME)/lib/RFSPHD_A53_HS_160X118M2_FB1FS2SB0PG1_tt_nominal_0p80v_0p80v_25c.lib \
                   $(PLATFORM_DIR)/$(DESIGN_NAME)/lib/RFSPHD_A53_HS_256X12M2_FB1FS1SB0WM1PG1_tt_nominal_0p80v_0p80v_25c.lib \
                   $(PLATFORM_DIR)/$(DESIGN_NAME)/lib/RFSPHD_A53_HS_256X32M2_FB1FS1SB0PG1_tt_nominal_0p80v_0p80v_25c.lib \
                   $(PLATFORM_DIR)/$(DESIGN_NAME)/lib/SRAMSPHD_A53_HS_1024X39M4_FB2FS2SB0PG1_tt_nominal_0p80v_0p80v_25c.lib \
                   $(PLATFORM_DIR)/$(DESIGN_NAME)/lib/SRAMSPHD_A53_HS_2048X42M4_FB2FS2SB0WM1PG1_tt_nominal_0p80v_0p80v_25c.lib



export ADDITIONAL_GDS  += $(PLATFORM_DIR)/$(DESIGN_NAME)/gds2/RFSPHD_A53_HS_128X32M2_FB1FS1SB0PG1.gds2 \
                         $(PLATFORM_DIR)/$(DESIGN_NAME)/gds2/RFSPHD_A53_HS_160X118M2_FB1FS2SB0PG1.gds2 \
                         $(PLATFORM_DIR)/$(DESIGN_NAME)/gds2/RFSPHD_A53_HS_128X50M2_FB1FS2SB0PG1.gds2 \
                         $(PLATFORM_DIR)/$(DESIGN_NAME)/gds2/RFSPHD_A53_HS_128X60M2_FB1FS2SB0PG1.gds2 \
                         $(PLATFORM_DIR)/$(DESIGN_NAME)/gds2/RFSPHD_A53_HS_256X12M2_FB1FS1SB0WM1PG1.gds2 \
                         $(PLATFORM_DIR)/$(DESIGN_NAME)/gds2/RFSPHD_A53_HS_256X32M2_FB1FS1SB0PG1.gds2 \
                         $(PLATFORM_DIR)/$(DESIGN_NAME)/gds2/SRAMSPHD_A53_HS_1024X39M4_FB2FS2SB0PG1.gds2 \
                         $(PLATFORM_DIR)/$(DESIGN_NAME)/gds2/SRAMSPHD_A53_HS_2048X42M4_FB2FS2SB0WM1PG1.gds2

export FILL_CELLS += $(LVT_FILL_CELLS)

# These values must be multiples of placement site
export DIE_AREA    = 0 0 1400 1400 
export CORE_AREA   = 10 10 1390 1390 
export PLACE_DENSITY_LB_ADDON = 0.05

export PLACE_PINS_ARGS = -exclude left:0-600 -exclude left:1350-1400 -exclude right:* -exclude top:* -exclude bottom:*

export MACRO_PLACE_HALO = 7 7
export MACRO_PLACE_CHANNEL = 14 14

export MACRO_WRAPPERS = $(dir $(DESIGN_CONFIG))/wrappers.tcl

#export MAX_ROUTING_LAYER = H2 
export FASTROUTE_TCL = $(dir $(DESIGN_CONFIG))/fastroute.tcl
#
ifeq ($(USE_FILL),1)
export DESIGN_TYPE = CELL
else
export DESIGN_TYPE = CELL_NODEN
endif

#export SKIP_PIN_SWAP          = 1
export SKIP_INCREMENTAL_REPAIR = 1
export TNS_END_PERCENT = 5
