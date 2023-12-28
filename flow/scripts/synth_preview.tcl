source $::env(SCRIPTS_DIR)/synth_preamble.tcl

# Fast generic synthesis
synth -top $::env(DESIGN_NAME) -noshare -nofsm -noalumacc -run :fine
synth -top $::env(DESIGN_NAME) -run check:
if { [info exist ::env(ADDER_MAP_FILE)] && [file isfile $::env(ADDER_MAP_FILE)] } {
  techmap -map $::env(ADDER_MAP_FILE)
}
techmap
if {[info exist ::env(DFF_LIB_FILE)]} {
  dfflibmap -liberty $::env(DFF_LIB_FILE)
} else {
  dfflibmap -liberty $::env(DONT_USE_SC_LIB)
}
puts "abc [join $abc_args " "]"
abc {*}$abc_args

write_verilog -noattr -noexpr -nohex -nodec $::env(RESULTS_DIR)/1_0_preview.v
