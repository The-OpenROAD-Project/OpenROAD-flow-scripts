# Yosys pre-synthesis pass for memory extraction.
# Elaborates RTL and collects inferred memory arrays into $mem_v2 primitives.
# tclint-disable command-args

source $::env(SCRIPTS_DIR)/synth_preamble.tcl

# Read all RTL sources using active frontend (all frontends)
read_design_sources

# Elaborate hierarchy
hierarchy -top $::env(DESIGN_NAME)

# Run process execution and memory collection
proc
memory -nomap

# Write netlist JSON containing inferred $mem_v2 primitives
set out_json "$::env(RESULTS_DIR)/memories_inferred.json"
file mkdir [file dirname $out_json]
write_json $out_json

exit
