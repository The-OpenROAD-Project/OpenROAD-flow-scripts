export DESIGN_NICKNAME = riscv32i-mock-sram_fakeram7_256x32
export DESIGN_NAME = fakeram7_256x32
export PLATFORM    = asap7

export VERILOG_FILES = $(DESIGN_HOME)/asap7/riscv32i-mock-sram/fakeram7_256x32/*.v
export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/riscv32i-mock-sram/fakeram7_256x32/constraints.sdc

export CORE_UTILIZATION = 50
export CORE_ASPECT_RATIO = 8
export PLACE_DENSITY = 0.80
# fakeram7 doesn't block off M5, so limit to M4 here.
# However, PDN will use M5, so it is still added to blockages.
export MAX_ROUTING_LAYER = M4

export PLACE_PINS_ARGS = -exclude left:* -exclude bottom:* -exclude top:* -min_distance 6 -min_distance_in_tracks

export PDN_TCL                = $(FLOW_HOME)/platforms/asap7/openRoad/pdn/BLOCK_grid_strategy.tcl
