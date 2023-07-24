export PLATFORM               = asap7

export DESIGN_NAME            = regfile_64x22
export DESIGN_NICKNAME        = regfile_64x22

export VERILOG_FILES          = $(realpath ./designs/src/$(DESIGN_NICKNAME)/regfile_64x22.v)

export SDC_FILE               = $(realpath ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc)
export SYNTH_SDC_FILE         = $(SDC_FILE)

export PLACE_DENSITY_LB_ADDON = 0.05

export PDN_TCL                = $(dir $(DESIGN_CONFIG))/pdn.tcl

# pre set CORE and DIE to avoid MPL
# add IO and MACRO pre placement
export CORE_AREA              = 0.54 0.5400 99.46 99.46
export DIE_AREA               = 0 0 100 100

export IO_CONSTRAINTS         = $(dir $(DESIGN_CONFIG))/io.tcl
export IO_PLACER_H            = M2
export IO_PLACER_V            = M3
export PLACE_PIN_PITCH        = 0.27
#export PLACE_PINS_ARGS        = -min_distance 1 -min_distance_in_tracks
export PLACE_PINS_ARGS        = -min_distance 0.09

# since this will be either top level macro or chip itself, allow routing to top of the 
# metal stack
export MIN_ROUTING_LAYER      = M2
export MAX_ROUTING_LAYER      = M4
