# https://gist.github.com/brabect1/7695ead3d79be47576890bbcd61fe426
#
# This fifo is from http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf

source designs/src/mock-array/util.tcl

set sdc_version 2.0

set clk_period 333
set clk2_period 1000

set clk1_name clk
create_clock -name $clk1_name -period $clk_period -waveform [list 0 [expr $clk_period/2]] [get_ports $clk1_name]
set_clock_uncertainty 10 [get_clocks $clk1_name]

set clk2_name clk_uncore
create_clock -name $clk2_name -period $clk2_period -waveform [list 0 [expr $clk_period/2]] [get_ports $clk2_name]
set_clock_uncertainty 10 [get_clocks $clk2_name]
set_clock_groups -group $clk1_name -group $clk2_name -asynchronous -allow_paths
# -allow_paths

set_false_path -from [get_ports *rst_n]
set_false_path -to [get_ports *rst_n]

# Give the world outside of the FIFO time to operate
# on the cycle it is reading/writiing to the FIFO
set min_percent 0.1
set max_percent 0.5

set_input_delay -clock $clk2_name -max [expr $clk2_period * $max_percent] [match_pins .* input 0]
set_output_delay -clock $clk2_name -max [expr $clk2_period * $max_percent] [match_pins .* output 0]
set_input_delay -clock $clk2_name -min [expr $clk2_period * $min_percent] [match_pins .* input 0]
set_output_delay -clock $clk2_name -min [expr $clk2_period * $min_percent] [match_pins .* output 0]

proc filter_pins { regex {direction .*} {is_clock 0} {property name}} {
    set pins {}
    # The regex for get_ports is not the tcl regex
    foreach pin [get_pins *] {
        set input [get_property $pin $property]
        # We want the Tcl regex
        if {![regexp $regex $input]} {
            continue
        }
        if {![regexp $direction [get_property $pin direction]]} {
            continue
        }
        if {[expr $is_clock != [sta::is_clock_src $pin]]} {
            continue
        }
        lappend pins [get_property $pin $property]
    }
    return [natural_sort $pins]
}

# Failing timing path, but this flip flop has settled. Set max delay to 2000ps for it:
#set fifo_out_pins [filter_pins fifo_out\.fifomem\.mem.*CLK output 0 full_name]

#set_max_delay -from $clk1_name -to [match_pins .* output 0] 2000

#set fifo_out_sync [filter_pins fifo_out.sync_w2r.rq1_wptr.*/CLK input 0 full_name]
#set_max_delay -from $clk2_name -to $fifo_out_sync 2000



#set_max_delay -from [all_registers -clock_pins] -to [all_registers -data_pins] 2000

## Dual clock fifo timing constraints
# Using fastest clock as constaint
set cdc_max_delay $clk_period

# rdata from fifo_out goes directly to I/O-pins so we need special handling of this case
# to ignore timing path from wclk -> rdata for this special case
# In normal cases fifo output (rdata) will most likely have a FF on I/O output signal
set_false_path -from $clk1_name -to [match_pins rdata* output 0]

# Set timing constraint between clock domains
set_max_delay $cdc_max_delay -from $clk1_name -to $clk2_name -ignore_clock_latency
set_max_delay $cdc_max_delay -from $clk2_name -to $clk1_name -ignore_clock_latency

# Hold times between clock domain makes no sense, and should just be ignored
set_false_path -hold -from $clk1_name -to $clk2_name
set_false_path -hold -from $clk2_name -to $clk1_name