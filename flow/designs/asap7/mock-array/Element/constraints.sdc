set sdc_version 2.0

set clk_period 500

set clk_name  clock
set clk_port_name clock
set clk_in_pct 0.50
set clk_o1_pct 0.2
set clk_o2_pct 0.75

create_clock -name $clk_name       -period $clk_period -waveform [list 0 [expr $clk_period/2]] [get_ports $clk_port_name]
set_clock_uncertainty 20 [get_clocks $clk_name]

create_clock -name ${clk_name}_vir -period $clk_period -waveform [list 0 [expr $clk_period/2]]
set_clock_uncertainty  20 [get_clocks ${clk_name}_vir]
set_clock_latency     100 [get_clocks ${clk_name}_vir]       ;# Matching real clock latency

set clk_port [get_ports $clk_port_name]
set non_clock_inputs [lsearch -inline -all -not -exact [all_inputs] $clk_port]
set lsb_register_out [concat [get_ports io_lsbOuts_4] [get_ports io_lsbOuts_7]]
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

set_input_delay  [expr $clk_period * $clk_in_pct] -clock ${clk_name}_vir $non_clock_inputs 
set_output_delay [expr $clk_period * $clk_o1_pct] -clock ${clk_name}_vir $non_reg_outputs
set_output_delay [expr $clk_period * $clk_o2_pct] -clock ${clk_name}_vir $reg_outputs

set_max_transition 50 [current_design]
set_max_transition 50 -clock_path [all_clocks]
