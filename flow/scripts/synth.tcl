source $::env(SCRIPTS_DIR)/synth_preamble.tcl

hierarchy -check -top $::env(DESIGN_NAME)

set ungroup_threshold 0
if { $::env(MAX_UNGROUP_SIZE) > 0 } {
  set ungroup_threshold $::env(MAX_UNGROUP_SIZE)
  puts "Ungroup modules of size greater than $ungroup_threshold"
}

set fp [open $::env(SYNTH_STATS) r]
while {[gets $fp line] != -1} {
    set fields [split $line " "]
    set area [lindex $fields 0]
    set module_name [lindex $fields 1]

    if {[expr $area > $ungroup_threshold]} {
      puts "Keeping module $module_name (area: $area)"
      select -module $module_name
      setattr -mod -set keep_hierarchy 1
      select -clear
    } else {
      puts "Flattening module $module_name (area: $area)"
    }
}
close $fp

if { [env_var_equals SYNTH_GUT 1] } {
  # /deletes all cells at the top level, which will quickly optimize away
  # everything else, including macros.
  delete $::env(DESIGN_NAME)/c:*
}

synthesize_check mem $::env(SYNTH_FULL_ARGS)

# rename registers to have the verilog register name in its name
# of the form \regName$_DFF_P_. We should fix yosys to make it the reg name.
# At least this is predictable.
renames -wire

# Optimize the design
opt -purge

# Technology mapping of adders
if {[env_var_exists_and_non_empty ADDER_MAP_FILE] && [file isfile $::env(ADDER_MAP_FILE)]} {
  # extract the full adders
  extract_fa
  # map full adders
  techmap -map $::env(ADDER_MAP_FILE)
  techmap
  # Quick optimization
  opt -fast -purge
}

# Technology mapping of latches
if {[env_var_exists_and_non_empty LATCH_MAP_FILE]} {
  techmap -map $::env(LATCH_MAP_FILE)
}

set dfflibmap_args ""
foreach cell $::env(DONT_USE_CELLS) {
  lappend dfflibmap_args -dont_use $cell
}

# Technology mapping of flip-flops
# dfflibmap only supports one liberty file
if {[env_var_exists_and_non_empty DFF_LIB_FILE]} {
  dfflibmap -liberty $::env(DFF_LIB_FILE) {*}$dfflibmap_args
} else {
  dfflibmap -liberty $::env(DONT_USE_SC_LIB) {*}$dfflibmap_args
}
opt

puts "abc [join $abc_args " "]"
abc {*}$abc_args

# Replace undef values with defined constants
setundef -zero

# Splitting nets resolves unwanted compound assign statements in netlist (assign {..} = {..})
splitnets

# Remove unused cells and wires
opt_clean -purge

# Technology mapping of constant hi- and/or lo-drivers
hilomap -singleton \
        -hicell {*}$::env(TIEHI_CELL_AND_PORT) \
        -locell {*}$::env(TIELO_CELL_AND_PORT)

# Insert buffer cells for pass through wires
insbuf -buf {*}$::env(MIN_BUF_CELL_AND_PORTS)

# Reports
tee -o $::env(REPORTS_DIR)/synth_check.txt check

tee -o $::env(REPORTS_DIR)/synth_stat.txt stat {*}$stat_libs

# Write synthesized design
write_verilog -noexpr -nohex -nodec $::env(RESULTS_DIR)/1_1_yosys.v
# One day a more sophisticated synthesis will write out a modified
# .sdc file after synthesis. For now, just copy the input .sdc file,
# making synthesis more consistent with other stages.
log_cmd exec cp $::env(SDC_FILE) $::env(RESULTS_DIR)/1_synth.sdc
