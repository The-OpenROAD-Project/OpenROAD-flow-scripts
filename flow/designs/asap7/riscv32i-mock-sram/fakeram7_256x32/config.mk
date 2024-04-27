export DESIGN_NICKNAME = riscv32i-mock-sram_fakeram7_256x32
export DESIGN_NAME = fakeram7_256x32
export PLATFORM    = asap7

export VERILOG_FILES = ./designs/asap7/riscv32i-mock-sram/fakeram7_256x32/*.v
export SDC_FILE      = ./designs/$(PLATFORM)/riscv32i-mock-sram/fakeram7_256x32/constraints.sdc

export CORE_UTILIZATION = 50
export CORE_ASPECT_RATIO = 8
export PLACE_DENSITY = 0.80
export MAX_ROUTING_LAYER = M4

export PLACE_PINS_ARGS = -exclude left:* -exclude bottom:* -exclude top:* -min_distance 4 -min_distance_in_tracks
