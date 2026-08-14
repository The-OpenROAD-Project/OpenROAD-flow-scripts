# Native Tcl script to extract path details directly from OpenSTA into CSV
# Usage: source dump_paths_native.tcl

set out_file $::env(DUMP_OUT_FILE)
set stage_prefix $::env(DUMP_STAGE_PREFIX)

if {![info exists ::env(DUMP_OUT_FILE)] || ![info exists ::env(DUMP_STAGE_PREFIX)]} {
    puts "Error: DUMP_OUT_FILE or DUMP_STAGE_PREFIX not set."
    exit 1
}

puts "Extracting paths natively for stage: $stage_prefix to $out_file"

set fp [open $out_file w]
puts $fp "startpoint,endpoint,${stage_prefix}_min_clk_period,${stage_prefix}_net_delay,${stage_prefix}_logic_delay,${stage_prefix}_total_cap,${stage_prefix}_buffers"

# Get top 2000 paths
set paths [find_timing_paths -path_delay max -group_path_count 2000]

foreach path_end $paths {
    set slack [$path_end slack]
    set path [$path_end path]
    
    set start_path [$path start_path]
    set start_pin [$start_path pin]
    set end_pin [$path_end pin]
    
    set startpoint [get_name $start_pin]
    set endpoint [get_name $end_pin]
    
    # Get clock period from active clocks or default to datapath arrival if no clocks
    set clocks [all_clocks]
    if {[llength $clocks] > 0} {
        set clk_period [[lindex $clocks 0] period]
        set min_clk_period [expr {$clk_period - $slack}]
    } else {
        set min_clk_period [$path arrival]
    }
    
    # Redirect standard report output to string for precise table parsing
    utl::redirectStringBegin
    sta::set_report_path_digits 4
    sta::set_report_path_fields {capacitance net slew}
    sta::report_path_cmd $path
    set report_str [utl::redirectStringEnd]
    
    set net_delay 0.0
    set logic_delay 0.0
    set total_cap 0.0
    set buffers 0
    
    set datapath_delay [$path arrival]
    if {$datapath_delay < 1e-4} {
        set datapath_delay [expr {$datapath_delay * 1e9}]
    }
    
    # Process report_path_cmd text lines
    set lines [split $report_str "\n"]
    set prev_time 0.0
    foreach line $lines {
        set tokens [regexp -all -inline {\S+} $line]
        if {[llength $tokens] >= 5 && [string is double -strict [lindex $tokens 3]]} {
            set curr_time [lindex $tokens 3]
            set cell_delay [lindex $tokens 2]
            if {[string is double -strict $cell_delay] && $cell_delay > 0.0} {
                set logic_delay [expr {$logic_delay + $cell_delay}]
            }
            set step [expr {$curr_time - $prev_time}]
            set n_delay [expr {$step - $cell_delay}]
            if {$n_delay > 0.0} {
                set net_delay [expr {$net_delay + $n_delay}]
            }
            set prev_time $curr_time
            
            set c_str [lindex $tokens 0]
            if {[string is double -strict $c_str]} {
                set c_val [expr {abs($c_str)}]
                if {$c_val > 0.0} {
                    if {$c_val < 1e-9} { set c_val [expr {$c_val * 1e15}] }
                    set total_cap [expr {$total_cap + $c_val}]
                }
            }
            if {[regexp {\(([^net][^\)]*)\)} $line -> cell_type]} {
                if {[regexp {sky130_fd_sc_hd__(buf|dly)} $cell_type] || [regexp {BUF} $cell_type]} {
                    incr buffers
                }
            }
        }
    }
    
    # Convert seconds to delay units (ps for asap7, ns for sky130hd)
    set is_asap7 0
    if {[info exists ::env(DESIGN_PLATFORM)] && [string match "*asap7*" $::env(DESIGN_PLATFORM)]} {
        set is_asap7 1
    } elseif {[string match "*asap7*" $out_file]} {
        set is_asap7 1
    }
    
    if {$min_clk_period < 1e-4} {
        if {$is_asap7} {
            # asap7 is in ps
            set min_clk_period [expr {$min_clk_period * 1e12}]
        } else {
            # sky130hd is in ns
            set min_clk_period [expr {$min_clk_period * 1e9}]
        }
    }
    
    puts $fp "$startpoint,$endpoint,$min_clk_period,$net_delay,$logic_delay,$total_cap,$buffers"
}

close $fp
puts "Dump complete."
