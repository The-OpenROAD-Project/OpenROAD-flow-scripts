# Yosys pre-synthesis pass for memory extraction.
# Elaborates RTL and collects inferred memory arrays into $mem_v2 primitives.
# tclint-disable command-args

source $::env(SCRIPTS_DIR)/synth_preamble.tcl

# This pass runs before gen_memories.py, so results/memories/blackboxes.txt
# does not exist yet and there is nothing to blackbox: this is the pass
# whose output that list is derived from. read_design_sources consults
# auto_memories_blackboxes in every frontend branch, and that proc errors
# out when the file is absent, so reading the sources with AUTO_MEMORIES
# still set fails the step that has to run first. Clear it for this
# process only; the guard keeps its strength for synthesis.
set ::env(AUTO_MEMORIES) 0

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
