export DESIGN_NICKNAME = mempool_tile
export DESIGN_NAME = mempool_tile_wrap
export PLATFORM    = nangate45
#
export FLOW_VARIANT = hier
export SYNTH_HIERARCHICAL = 1
#export MAX_UNGROUP_SIZE = 1000
export RTLMP_FLOW = True
#
export FLOORPLAN_DEF = ./results/$(PLATFORM)/$(DESIGN_NICKNAME)/$(FLOW_VARIANT)/2_2_floorplan_io.def
export ABC_CLOCK_PERIOD_IN_PS = 4000
#
# RTL_MP Settings
export RTLMP_MAX_INST = 10000
export RTLMP_MIN_INST = 1000
export RTLMP_MAX_MACRO = 12
export RTLMP_MIN_MACRO = 4

#export CACHED_NETLIST = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/mempool_tile_wrap.v
export VERILOG_FILES = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/mempool_tile_wrap.v

export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/mempool_tile_wrap.sdc
export ABC_CLOCK_PERIOD_IN_PS = 4000

export ADDITIONAL_LEFS = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/fakeram45_256x32.lef \
                         ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/fakeram45_64x64.lef

export ADDITIONAL_LIBS = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/fakeram45_256x32.lib \
                         ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/fakeram45_64x64.lib

# These values must be multiples of placement site
export DIE_AREA    = 0.0 0.0 1000 1000
export CORE_AREA   = 10.07 9.94 990 990 
export PLACE_PINS_ARGS = -exclude left:0-300 -exclude left:800-1000 -exclude right:* -exclude top:* -exclude bottom:*
#
export MACRO_PLACE_HALO = 10 10
export MACRO_PLACE_CHANNEL = 20 20

export PLACE_DENSITY_LB_ADDON ?= 0.20
