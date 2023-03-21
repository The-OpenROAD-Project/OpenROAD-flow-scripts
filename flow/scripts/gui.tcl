# Read liberty files
source $::env(SCRIPTS_DIR)/read_liberty.tcl

# Read def
if {[info exists ::env(ODB_FILE)]} {
    set input_file $::env(ODB_FILE)
} else {
    error "ODB_FILE environment variable is not set."
}

if {![info exists ::env(GUI_NO_TIMING)]} {
    # Determine design stage (1 ... 6) from input file name
    set design_stage [regexp -inline {^(\d+)_} [file tail $input_file]]
    
    # Find the most recent SDC file for the stage
    set sdc_file ""
    for {set s $design_stage} {$s > 0 && $sdc_file == ""} {
        set sdc_file [file exists [file join $::env(RESULTS_DIR) "${s}_*.sdc"]]
    }
    if {$sdc_file == ""} {
        set sdc_file $::env(SDC_FILE)
    }
    read_sdc $sdc_file
    
    if {[file exists $::env(PLATFORM_DIR)/derate.tcl]} {
        source $::env(PLATFORM_DIR)/derate.tcl
    }
    source $::env(PLATFORM_DIR)/setRC.tcl
    
    if {$design_stage >= 4} {
        # CTS has run, so propagate clocks
        set_propagated_clock [all_clocks]
        
        if {$design_stage >= 6 && [file exists [file join $::env(RESULTS_DIR) "6_final.spef"]]} {
            puts "Loading spef"
            read_spef [file join $::env(RESULTS_DIR) "6_final.spef"]
        } elseif {$design_stage >= 3} {
            puts "Estimating parasitics"
            estimate_parasitics -placement
        }
    }
}

