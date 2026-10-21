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
# type: read_verilog leaves reads as $memrd until memory_collect. `%m`
# then selects every module that holds one, whole, without going through
# its name: an escaped module or memory name may carry a slash, a `$` or a
# glob character, and none of those survives being cut out of a
# `select -list` line and handed back to `select`.
memory_bmux2rom
set n_mem_cells [lindex [tee -q -s result.string select -count t:\$mem*] 0]
set out_json "$::env(RESULTS_DIR)/memories_inferred.json"
file mkdir [file dirname $out_json]
if { $n_mem_cells > 0 } {
  yosys select t:\$mem* %m
  set mem_modules [tee -q -s result.string select -list-mod %]
  set n_mem_modules [llength [split [string trim $mem_modules] "\n"]]
  log "extract_memories: $n_mem_modules modules hold $n_mem_cells memory cells"
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
