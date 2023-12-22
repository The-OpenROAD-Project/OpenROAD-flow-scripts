source $::env(SCRIPTS_DIR)/synth_preamble.tcl

if { [info exist ::env(SYNTH_HIERARCHICAL)] && $::env(SYNTH_HIERARCHICAL) == 1 && [file isfile $::env(SYNTH_STOP_MODULE_SCRIPT)] } {
  puts "Sourcing $::env(SYNTH_STOP_MODULE_SCRIPT)"
  source $::env(SYNTH_STOP_MODULE_SCRIPT)
}

set fast [expr [info exist ::env(SYNTH_FAST)] && $::env(SYNTH_FAST) == 1]

set synth_args $::env(SYNTH_ARGS)
if {[expr $fast == 1]} {
  puts "Fast synthesis"
  lappend synth_args -nofsm -noalumacc -noshare -run :fine
}

# Generic synthesis
synth -top $::env(DESIGN_NAME) {*}$synth_args

if {[expr $fast == 1]} {
  puts "Fast synthesis, replacing yosys synth 'fine' label with minimum stages"
  memory_map
  techmap
  abc -fast
  synth -top $::env(DESIGN_NAME) -run check:
}

if { [info exists ::env(USE_LSORACLE)] } {
    set lso_script [open $::env(OBJECTS_DIR)/lso.script w]
    puts $lso_script "ps -a"
    puts $lso_script "oracle --config $::env(LSORACLE_KAHYPAR_CONFIG)"
    puts $lso_script "ps -m"
    puts $lso_script "crit_path_stats"
    puts $lso_script "ntk_stats"
    close $lso_script

    # LSOracle synthesis
    lsoracle -script $::env(OBJECTS_DIR)/lso.script -lso_exe $::env(LSORACLE_CMD)
    techmap
}

if {[expr $fast == 0]} {
  opt -purge
}

# Technology mapping of adders
if {[info exist ::env(ADDER_MAP_FILE)] && [file isfile $::env(ADDER_MAP_FILE)]} {
  # extract the full adders
  extract_fa
  # map full adders
  techmap -map $::env(ADDER_MAP_FILE)
  techmap
  if {[expr $fast == 0]} {
    # Quick optimization
    opt -fast -purge
  }
}

# Technology mapping of latches
if {[info exist ::env(LATCH_MAP_FILE)]} {
  techmap -map $::env(LATCH_MAP_FILE)
}

# Technology mapping of flip-flops
# dfflibmap only supports one liberty file
if {[info exist ::env(DFF_LIB_FILE)]} {
  dfflibmap -liberty $::env(DFF_LIB_FILE)
} else {
  dfflibmap -liberty $::env(DONT_USE_SC_LIB)
}

if {[expr $fast == 0]} {
  opt
}

set constr [open $::env(OBJECTS_DIR)/abc.constr w]
puts $constr "set_driving_cell $::env(ABC_DRIVER_CELL)"
puts $constr "set_load $::env(ABC_LOAD_IN_FF)"
close $constr

if {[expr $fast == 1]} {
  lappend abc_args -fast
}

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

# Create argument list for stat
set stat_libs ""
foreach lib $::env(DONT_USE_LIBS) {
  append stat_libs "-liberty $lib "
}
tee -o $::env(REPORTS_DIR)/synth_stat.txt stat {*}$stat_libs

# Write synthesized design
write_verilog -noattr -noexpr -nohex -nodec $::env(RESULTS_DIR)/1_1_yosys.v
