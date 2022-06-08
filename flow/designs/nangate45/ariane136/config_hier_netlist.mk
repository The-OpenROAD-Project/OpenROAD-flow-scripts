include $(dir $(DESIGN_CONFIG))/config.mk

export FLOW_VARIANT = hier_netlist
export SYNTH_HIERARCHICAL = 1
#export MAX_UNGROUP_SIZE = 1000
export RTLMP_FLOW = True

export VERILOG_FILES = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/ariane_netlist.v
#export CACHED_NETLIST = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/ariane_netlist.v
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export FLOORPLAN_DEF = ./results/$(PLATFORM)/$(DESIGN_NICKNAME)/$(FLOW_VARIANT)/2_2_floorplan_io.def
export ABC_CLOCK_PERIOD_IN_PS = 4000
#
# RTL_MP Settings
export RTLMP_MAX_INST = 5000
export RTLMP_MIN_INST = 1000
export RTLMP_MAX_MACRO = 24 
export RTLMP_MIN_MACRO = 4

# These values must be multiples of placement site
export DIE_AREA    = 0 0 1700 1700
export CORE_AREA   = 10 10 1690 1690
export PLACE_PINS_ARGS = -exclude left:0-550 -exclude left:1000-1700 -exclude right:* -exclude top:* -exclude bottom:*

export MACRO_PLACE_HALO = 5 5
export MACRO_PLACE_CHANNEL = 10 10

