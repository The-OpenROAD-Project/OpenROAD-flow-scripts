# tpu is mesochronous with its surroundings: the same clock, a phase it
# does not know (its clock runs through its tiles), with the FIFOs on its
# boundary outside it. So only register-to-register paths are judged,
# and the boundary is a set_max_delay budget for repair, with no input or
# output delay (the platform's constraints.sdc).
set clk_name core_clock
set clk_port_name clk
set clk_period 450
set in2reg_max 300
set reg2out_max 100
set in2out_max 100
source $::env(PLATFORM_DIR)/constraints.sdc
