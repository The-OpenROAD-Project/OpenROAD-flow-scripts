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

# Run process execution and memory collection. `yosys proc` rather than
# bare `proc`: yosys -import cannot shadow Tcl's proc keyword, so the
# bare word would define a procedure instead of running the pass.
yosys proc

# The memory passes, on the modules that hold memory cells only. Every
# pass in `memory -nomap` walks every selected module, and memory_dff
# builds its per-bit driver and consumer index (ModWalker) for a module
# before it asks whether the module has a memory at all; opt_mem_priority
# and opt_mem_feedback scan every module's cells the same way. On a design
# whose memories sit in small generated modules and whose logic sits in
# large ones -- a firtool core keeps every memory in its own ram_* module
# -- that index over the memory-less modules is nearly the whole cost of
# this step. Scoping the passes to the modules with memory cells changes
# nothing in the result: a pass finds nothing to do in a module without
# them. memory_bmux2rom runs first and unscoped, since it is what turns a
# module's constant muxes into a memory. t:$mem* takes every memory cell
# type: read_verilog leaves reads as $memrd until memory_collect. The
# module list comes from the cells' names (module before the first slash)
# rather than the selection's `%m` expansion, which leaves a module
# partially selected when its name carries a `$`, as slang's uniquified
# names do, and the passes then skip it. A module name that itself holds a
# slash would be cut short and select nothing, so the selection must hold
# every memory cell.
memory_bmux2rom
set mem_cells {}
foreach line [tee -q -s result.string select -list t:\$mem*] {
  set line [string trim $line]
  if { $line ne "" } {
    lappend mem_cells $line
  }
}
set mem_modules [dict create]
foreach cell $mem_cells {
  dict set mem_modules [lindex [split $cell "/"] 0] 1
}
set mem_modules [dict keys $mem_modules]
log "extract_memories: [llength $mem_modules] modules hold [llength $mem_cells] memory cells"
set out_json "$::env(RESULTS_DIR)/memories_inferred.json"
file mkdir [file dirname $out_json]
if { [llength $mem_modules] > 0 } {
  yosys select {*}$mem_modules
  select -assert-count [llength $mem_cells] % t:\$mem* %i
  memory -nomap
  # The JSON is read by gen_memories.py's detector, which looks at the
  # $mem_v2 cells of each module and nothing across modules, so the
  # memory modules are all it needs; the rest of the design is most of
  # the bytes.
  write_json -selected $out_json
  select -clear
} else {
  write_json $out_json
}

exit
