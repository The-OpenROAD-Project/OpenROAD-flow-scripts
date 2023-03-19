foreach file $::env(VERILOG_FILES) {
  read_verilog -defer -sv {*}$vIdirsArgs $file
}
synth  -top $::env(DESIGN_NAME) {*}$::env(SYNTH_ARGS)
opt -purge
dfflibmap -liberty $::env(DFF_LIB_FILE)
opt

set constr [open $::env(OBJECTS_DIR)/abc.constr w]
puts $constr "set_driving_cell $::env(ABC_DRIVER_CELL)"
puts $constr "set_load $::env(ABC_LOAD_IN_FF)"
close $constr

set abc_script $::env(SCRIPTS_DIR)/abc_speed.script
puts "\[FLOW\] Set ABC_CLOCK_PERIOD_IN_PS to: $::env(ABC_CLOCK_PERIOD_IN_PS)"
abc -D [expr $::env(ABC_CLOCK_PERIOD_IN_PS)] \
      -script $abc_script \
      -liberty $::env(DONT_USE_SC_LIB) \
      -constr $::env(OBJECTS_DIR)/abc.constr

setundef -zero
splitnets
opt_clean -purge

hilomap -singleton \
        -hicell {*}$::env(TIEHI_CELL_AND_PORT) \
        -locell {*}$::env(TIELO_CELL_AND_PORT)
insbuf -buf {*}$::env(MIN_BUF_CELL_AND_PORTS)
tee -o $::env(REPORTS_DIR)/synth_check.txt check

set stat_libs ""
foreach lib $::env(DONT_USE_LIBS) {
  append stat_libs "-liberty $lib "
}
tee -o $::env(REPORTS_DIR)/synth_stat.txt stat {*}$stat_libs
write_verilog -noattr -noexpr -nohex -nodec $::env(RESULTS_DIR)/1_1_yosys.v
