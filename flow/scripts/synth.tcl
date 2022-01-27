source $::env(SCRIPTS_DIR)/synth_preamble.tcl

if { [info exist ::env(SYNTH_HIERARCHICAL)] && $::env(SYNTH_HIERARCHICAL) == 1 && [file isfile $::env(SYNTH_STOP_MODULE_SCRIPT)] } {
  puts "Sourcing $::env(SYNTH_STOP_MODULE_SCRIPT)"
  source $::env(SYNTH_STOP_MODULE_SCRIPT)
}

# Generic synthesis
synth  -top $::env(DESIGN_NAME) {*}$::env(SYNTH_ARGS)

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

# Optimize the design
opt -purge

# Technology mapping of adders
if {[info exist ::env(ADDER_MAP_FILE)] && [file isfile $::env(ADDER_MAP_FILE)]} {
  # extract the full adders
  extract_fa
  # map full adders
  techmap -map $::env(ADDER_MAP_FILE)
  techmap
  # Quick optimization
  opt -fast -purge
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
opt


set constr [open $::env(OBJECTS_DIR)/abc.constr w]
puts $constr "set_driving_cell $::env(ABC_DRIVER_CELL)"
puts $constr "set_load $::env(ABC_LOAD_IN_FF)"
close $constr

if {$::env(ABC_AREA)} {
  puts "Using ABC area script."
  set abc_script $::env(SCRIPTS_DIR)/abc_area.script
} else {
  puts "Using ABC speed script."
  set abc_script $::env(SCRIPTS_DIR)/abc_speed.script
}

# Technology mapping for cells
# ABC supports multiple liberty files, but the hook from Yosys to ABC doesn't
if {[info exist ::env(ABC_CLOCK_PERIOD_IN_PS)]} {
  puts "\[FLOW\] Set ABC_CLOCK_PERIOD_IN_PS to: $::env(ABC_CLOCK_PERIOD_IN_PS)"
  abc -D [expr $::env(ABC_CLOCK_PERIOD_IN_PS)] \
      -script $abc_script \
      -liberty $::env(DONT_USE_SC_LIB) \
      -constr $::env(OBJECTS_DIR)/abc.constr
} else {
  puts "\[WARN\]\[FLOW\] No clock period constraints detected in design"
  abc -liberty $::env(DONT_USE_SC_LIB) \
      -constr $::env(OBJECTS_DIR)/abc.constr
}

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
