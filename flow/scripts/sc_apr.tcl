source sc_manifest.tcl

set sc_tool "openroad"
set sc_step [dict get $sc_cfg arg step]
set sc_index [dict get $sc_cfg arg index]
set sc_refdir [dict get $sc_cfg tool $sc_tool refdir $sc_step $sc_index]

set results_dir $::env(RESULTS_DIR)
set inputs [list]

# Step-specific pre-processing step(s)
if {$sc_step == "import"} {
    # Import: Create macro wrappers if necessary.
    # TODO: It looks like this step only applies to gf12 designs, so we cannot adequately test it atm.
} elseif {$sc_step == "export"} {
    # Export: Generate KLayout tech file.
    set sc_process [dict get $sc_cfg option pdk]
    set sc_stackup [dict get $sc_cfg pdk $sc_process stackup]
    set base_lyt [dict get $sc_cfg pdk $sc_process layermap klayout def gds $sc_stackup]
    set base_lyp [dict get $sc_cfg pdk $sc_process display klayout $sc_stackup]
    set tlef [dict get $sc_cfg library $::env(PLATFORM) model layout lef $sc_stackup]
    set replace_str "<lef-files>$tlef</lef-files>"
    if {[info exists ::env(ADDITIONAL_LEFS)]} {
        foreach f $::env(ADDITIONAL_LEFS) {
            set replace_str "$replace_str<lef-files>$f</lef-files>"
        }
    }

    # Put KLayout tech files in job dir root to avoid modifying klayout.tcl
    # klayout.lyt = base_lyt w/ lef-files tag replaced.
    exec sed "s,<lef-files>.*</lef-files>,$replace_str,g" $base_lyt > ../../klayout.lyt
    # klayout.lyp = base_lyp
    file copy -force $base_lyp ../../klayout.lyp
}

# Copy from inputs/ into OpenROAD work directory
file mkdir $results_dir
foreach f [glob -directory inputs/ -tails -nocomplain *] {
    file copy -force inputs/$f $results_dir
    lappend inputs $f
}

# Determine OR script name based on step name
if {$sc_step == "export"} {
    # export is special case
    set script "klayout.tcl"
} elseif {$sc_step == "or_tdms_place" && [info exists ::env(MACRO_PLACEMENT)]} {
    # Skip TDMS placement step if MACRO_PLACEMENT is set.
    set script ""
} else {
    # strip or_ prefix
    set script [string replace $sc_step 0 2 ""].tcl
}

# Run script
if {$script != ""} {
    source $sc_refdir/$script
}

# Copy anything from work dir that was not an input into outputs/
foreach f [glob -directory $results_dir -tails -nocomplain *] {
    if {[lsearch $inputs $f] == -1} {
        file copy -force $results_dir/$f outputs/
    }
}

# Step-specific post-processing step(s)
if {$sc_step == "or_yosys"} {
    # Synthesis: Copy RTL/SDC files
    file copy -force outputs/1_1_yosys.v outputs/1_synth.v
    foreach f $inputs {
        if {[string last ".sdc" $f] == [expr [string length $f] - 4]} {
            file copy -force "inputs/$f" outputs/1_synth.sdc
        }
    }
} elseif {$sc_step == "or_tdms_place" && [info exists ::env(MACRO_PLACEMENT)]} {
    # TDMS Placement: copy .odb input if this step was skipped.
    foreach f $inputs {
        puts $f
    }
    file copy -force inputs/2_2_floorplan_io.odb outputs/2_3_floorplan_tdms.odb
} elseif {$sc_step == "or_pdn"} {
    # Last floorplan step: copy .odb file.
    file copy -force outputs/2_6_floorplan_pdn.odb outputs/2_floorplan.odb
} elseif {$sc_step == "or_detail_place"} {
    # Last placement step: copy .odb and .sdc files.
    file copy -force outputs/3_5_place_dp.odb outputs/3_place.odb
    foreach f $inputs {
        if {[string last ".sdc" $f] == [expr [string length $f] - 4]} {
            file copy -force "inputs/$f" outputs/3_place.sdc
        }
    }
} elseif {$sc_step == "or_cts"} {
    # First CTS step: copy/rename SDC file for compatibility with following step.
    file copy -force outputs/4_cts.sdc outputs/3_place.sdc
} elseif {$sc_step == "or_fillcell"} {
    # Last CTS step: copy .odb file.
    file copy -force outputs/4_2_cts_fillcell.odb outputs/4_cts.odb
} elseif {$sc_step == "or_detail_route"} {
    # Last routing step: copy .odb and .sdc files.
    file copy -force outputs/5_route.odb outputs/6_1_fill.odb
    foreach f $inputs {
        if {[string last ".sdc" $f] == [expr [string length $f] - 4]} {
            file copy -force "inputs/$f" outputs/5_route.sdc
            file copy -force "inputs/$f" outputs/6_1_fill.sdc
        }
    }
}
