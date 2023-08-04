set sdc_version 2.0

set clk_period 500

set clk_name  clock
set clk_port_name clock
set clk_in_pct 0.15
set clk_o1_pct 0.2
set clk_o2_pct 0.50

create_clock -name $clk_name       -period $clk_period -waveform [list 0 [expr $clk_period/2]] [get_ports $clk_port_name]
set_clock_uncertainty 20 [get_clocks $clk_name]

create_clock -name ${clk_name}_vir -period $clk_period -waveform [list 0 [expr $clk_period/2]]
set_clock_uncertainty  20 [get_clocks ${clk_name}_vir]
# There clock tree of mock-array needs to account for clock network latency
# of Element before we can increase this to match the clock network latency
set_clock_latency       0 [get_clocks ${clk_name}_vir]

set clk_port [get_ports $clk_port_name]
set non_clock_inputs [lsearch -inline -all -not -exact [all_inputs] $clk_port]
set lsb_register_out [concat [get_ports io_lsbOuts_3] [get_ports io_lsbOuts_7]]
set all_lsb_outs [get_ports io_lsbOuts_*]

proc subtract {a b} {
    set result {}
    foreach item $a {
        if {[lsearch $b $item] == -1} {
            lappend result $item
        }
    }
    return $result
}

set non_reg_outputs [subtract $all_lsb_outs $lsb_register_out]
set reg_outputs [subtract [all_outputs] $non_reg_outputs]

# KISS the Element does not have translational symmetry, yet the Element
# is repeated in the array and we have to articulate a single .sdc file.
#
# We need to provide a .sdc file that is sufficient to drive optimizations,
# but the pass/fail on timing constraints is actually done at the
# mock-array level only, because only at the mock-array level do we have
# start and end registers for combinational paths through the element.
set_input_delay  [expr $clk_period * $clk_in_pct] -clock ${clk_name}_vir $non_clock_inputs
# The max flight path for input to output paths is 4 elements,
# but that can only be checked at the mock-array level.
#
# Use input delay + logic propagation time for max delay here
set_max_delay 140 -from [get_ports {io_lsbIns_*}] -to [get_ports {io_lsbOuts_*}]
set_output_delay [expr $clk_period * $clk_o2_pct] -clock ${clk_name}_vir $reg_outputs


set_max_transition 300 [current_design]
set_max_transition 100 -clock_path [all_clocks]
