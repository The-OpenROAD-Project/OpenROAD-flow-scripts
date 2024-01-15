source $::env(SCRIPTS_DIR)/synth_preamble.tcl

set ungroup_threshold 0
if { [info exist ::env(MAX_UNGROUP_SIZE)] && $::env(MAX_UNGROUP_SIZE) > 0 } {
  set ungroup_threshold $::env(MAX_UNGROUP_SIZE)
  puts "Ungroup modules of size $ungroup_threshold"
}

# Minimal hierarchical synthesis to use number of cells to drive policy
# of whether to flatten a module or not.
synth -run :coarse -top $::env(DESIGN_NAME)
# These commands are cherry-picked from the "synth -run coarse:" list
# of commands in the Yosys manual.
#
# 'proc' pass is called 'procs' to avoid conflict with tcl 'proc' command
procs
memory -nomap
memory_map
json -o $::env(OBJECTS_DIR)/synth.json
