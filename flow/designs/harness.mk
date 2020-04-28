export DESIGN_NAME = AptosAvalonMMSlaveHardware
export PLATFORM    = nangate45

export DC_NETLIST = ./designs/aptos/results/nangate45/AptosAvalonMMSlaveHardware/1_1_yosys.v
export SDC_FILE      = ./designs/aptos/results/nangate45/AptosAvalonMMSlaveHardware/1_synth.sdc

export MERGED_LEF = ./platforms/nangate45/NangateOpenCellLibrary.mod.lef
export LIB_FILES  = ./platforms/nangate45/NangateOpenCellLibrary_typical.lib
export GDS_FILES  = $(wildcard ./platforms/nangate45/gds/*)

export ADDITIONAL_LEFS = $(shell find ./designs/aptos -iname "*.lef")
export ADDITIONAL_LIBS = $(shell find ./designs/aptos -iname "*.lib")


# Automatically pick a reasonable area and utilization

# Core utilization in %
export CORE_UTILIZATION = 50.0
# Core height / core width
export CORE_ASPECT_RATIO = 1.0
# Core margin in um
export CORE_MARGIN = 2.0

# Start with 250MHz for nangate45, relatively conservative
export CLOCK_PORT   = clock
