###############################################################################
# Created by write_sdc
# Sat Nov  7 14:46:58 2020
###############################################################################
current_design swerv_wrapper
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name core_clock -period 1500.0 -waveform {0.0000 750.0} [get_ports {clk}]
set_clock_uncertainty -setup 70.0000 core_clock
set_clock_uncertainty -hold  70.0000 core_clock
#set_propagated_clock [get_clocks {core_clock}]
create_clock -name jtag_clock -period 1500 -waveform {0.0000 750.0} [get_ports {jtag_tck}]
set_clock_uncertainty -setup 70.0000 jtag_clock
set_clock_uncertainty -hold  70.0000 jtag_clock
#set_propagated_clock [get_clocks {jtag_clock}]

# There is sync logic between jtag and core_clock
#set_clock_groups -logically_exclusive -group {core_clock} -group {jtag_clock}

###############################################################################
# Environment
###############################################################################
###############################################################################
# Design Rules
###############################################################################
set clock_ports "jtag_tck clk"
set jtag_ports  "jtag_id* jtag_tdi jtag_tms jtag_trst_n"
#set input_not_jtag_ports [remove_from_collection [all_inputs] "$jtag_ports $clock_ports"]
set input_not_jtag_ports [list]
foreach input [all_inputs] {
  set addFlag 1
  foreach s [get_ports "$clock_ports $jtag_ports"] {
    if { $s == $input } {
      set addFlag 0
      break
    }
  }
  if { $addFlag } {
    lappend input_not_jtag_ports $input
  }
}
set_input_delay  375 -clock jtag_clock $jtag_ports
set_output_delay 375 -clock jtag_clock [get_ports "jtag_tdo"]
set_input_delay  750 -clock core_clock $input_not_jtag_ports
set ports_list [list]
foreach output [all_outputs] {
  set addFlag 1
  foreach s [get_ports "jtag_tdo"] {
    if { $s == $output } {
      set addFlag 0
      break
    }
  }
  if { $addFlag } {
    lappend ports_list $output
  }
}
set_output_delay 750 -clock core_clock $ports_list

set_driving_cell -lib_cell BUFH_X2N_A9PP84TR_C14 [all_inputs]

foreach input [all_inputs] {
  set_load 0 $input
}


