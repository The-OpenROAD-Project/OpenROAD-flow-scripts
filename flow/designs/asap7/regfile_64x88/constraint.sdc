#####################################################
set sdc_version 2.0

# Clock definition
set clk_period    500    ;# Relax clock period did not bring down -200ps slack accodingly; use 750 period at next level up
set clk_in_pct    0.70   ;# Not adding hold buffers 
set clk_out_pct   0.20   ;# read access takes almost a cycle including clock latency   

set rclk_name      R0_clk
set rclk_port_name R0_clk
set wclk_name      W0_clk
set wclk_port_name W0_clk

create_clock -name $rclk_name -period $clk_period -waveform [list 0 [expr $clk_period/2]] [get_ports $rclk_port_name] 
set_clock_uncertainty 20 $rclk_name

create_clock -name $wclk_name -period $clk_period -waveform [list 0 [expr $clk_period/2]] [get_ports $wclk_port_name] 
set_clock_uncertainty 20 $wclk_name

# Create corresponding virtual clocks
create_clock -name ${rclk_name}_vir -period $clk_period
set_clock_uncertainty 20 ${rclk_name}_vir
set_clock_latency 100 [get_clocks ${rclk_name}_vir]

create_clock -name ${wclk_name}_vir -period $clk_period
set_clock_uncertainty 20 ${wclk_name}_vir
set_clock_latency 100 [get_clocks ${wclk_name}_vir]


# Transition
set_max_transition 300 [current_design]
set_max_transition 100 -clock_path [all_clocks]

# Inputs/Outputs
set non_clock_inputs [lsearch -inline -all -not -exact [all_inputs] [list $rclk_port_name $wclk_port_name]]

set wr_inputs  "W0_en W0_addr W0_data W0_mask"
set rd_inputs  "R0_en R0_addr"
set rd_outputs "R0_data"

set_input_delay  [expr $clk_period * $clk_in_pct]  -clock ${wclk_name}_vir $wr_inputs 
set_input_delay  [expr $clk_period * $clk_in_pct]  -clock ${rclk_name}_vir $rd_inputs 
set_output_delay [expr $clk_period * $clk_out_pct] -clock ${rclk_name}_vir $rd_outputs

# Input/Output
set_max_fanout 1 $non_clock_inputs
set_load 20 [all_outputs]

set_driving_cell -lib_cell BUFx2_ASAP7_75t_R -from_pin A -pin Y $non_clock_inputs
set_driving_cell -lib_cell BUFx8_ASAP7_75t_R -from_pin A -pin Y [list $rclk_port_name $wclk_port_name]

# Design Specifics
set_clock_groups -logically_exclusive -group $wclk_name -group $rclk_name

