# ####################################################################

#  Created by Genus(TM) Synthesis Solution 21.10-p002_1 on Fri Jul 01 20:44:40 PDT 2022

# ####################################################################

set sdc_version 2.0

# Set the current design
current_design ariane

create_clock -name "core_clock" -period 8.0 -waveform {0.0 4.0} [get_ports clk_i]
set_clock_gating_check -setup 0.0 
set_wire_load_mode "top"
