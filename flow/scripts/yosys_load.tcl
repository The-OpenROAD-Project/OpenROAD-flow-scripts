# Load synthesis result
yosys -import

source $::env(SCRIPTS_DIR)/util.tcl
source $::env(SCRIPTS_DIR)/synth_stdcells.tcl

read_verilog [orfs_input_path 1_synth.v]
