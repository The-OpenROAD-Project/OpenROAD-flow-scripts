#########################################################################
# "sc_apr.tcl"
# This is a wrapper script which sits between SiliconCompiler and the
# TCL scripts which get called by the OpenROAD-flow-scripts Makefile.
#
# This wrapper script simplifies the implementation of some pre-
# and post-processing steps, such as copying files between steps
# or modifying default liberty/tech/etc files.
#
# Although it is located in 'scripts/sc/tools/openroad', this script is
# also run through yosys during the synthesis step.
#########################################################################

# Populate $sc_cfg value with the current sc manifest.
source sc_manifest.tcl

# Set widely-used variables related to the current task.
set sc_step [dict get $sc_cfg arg step]
set sc_index [dict get $sc_cfg arg index]
set sc_tool [dict get $sc_cfg flowgraph orflow $sc_step $sc_index tool]
set sc_refdir [dict get $sc_cfg tool $sc_tool refdir $sc_step $sc_index]
set sc_design [dict get $sc_cfg design]

set results_dir $::env(RESULTS_DIR)
set inputs [list]

# Step-specific pre-processing step(s)
#if {$sc_step == "or_synth_hier_report"} {
if {$sc_step == "or_synth"} {
    # Pre-synthesis: mark dont-use cells in liberty files, and merge them.
    foreach f [split $::env(LIB_FILES)] {
        exec $::env(UTILS_DIR)/markDontUse.py -p $::env(DONT_USE_CELLS) -i $f -o "../../[file tail $f]-mod.lib"
    }
    set merge_cmd $::env(UTILS_DIR)/mergeLib.pl
    lappend merge_cmd $::env(PLATFORM)_merged
    foreach ff [regexp -all -inline {\S+} $::env(DONT_USE_LIBS)] {
        lappend merge_cmd $ff
    }
    exec {*}$merge_cmd > ../../merged.lib
} elseif {$sc_step == "or_detail_route"} {
    # Pre-export: Generate KLayout tech file with references to all LEFs in the design..
    set sc_process [dict get $sc_cfg option pdk]
    set sc_stackup [dict get $sc_cfg pdk $sc_process stackup]
    set base_lyt [dict get $sc_cfg pdk $sc_process layermap klayout def gds $sc_stackup]
    set base_lyp [dict get $sc_cfg pdk $sc_process display klayout $sc_stackup]
    set llib [dict get $sc_cfg asic logiclib]
    set tlef [dict get $sc_cfg library $llib model layout lef $sc_stackup]
    set replace_str "<lef-files>$tlef</lef-files>"
    if {[info exists ::env(ADDITIONAL_LEFS)]} {
        foreach f $::env(ADDITIONAL_LEFS) {
            set replace_str "$replace_str<lef-files>$f</lef-files>"
        }
    }

    # Put KLayout tech files in job dir root to avoid modifying original tech file.
    # klayout.lyt = base_lyt w/ lef-files tag replaced.
    exec sed "s,<lef-files>.*</lef-files>,$replace_str,g" $base_lyt > ../../klayout.lyt
    # klayout.lyp = base_lyp
    file copy -force $base_lyp ../../klayout.lyp
}

# Pre-run: copy from inputs/ into OpenROAD work directory
file mkdir $results_dir
foreach f [glob -directory inputs/ -tails -nocomplain *] {
    file copy -force inputs/$f $results_dir
    lappend inputs $f
}

# Determine OR script name based on step name
if {$sc_step == "or_tdms_place" && [info exists ::env(MACRO_PLACEMENT)]} {
    # Skip TDMS placement step if MACRO_PLACEMENT is set.
    set script ""
} else {
    # Strip or_ prefix to get the name of the script to run.
    set script ../../../[string replace $sc_step 0 2 ""].tcl
}

# Run the script for this step.
if {$script != ""} {
    source $sc_refdir/$script
}

# Post-run: copy anything from work dir that was not an input into outputs/
foreach f [glob -directory $results_dir -tails -nocomplain *] {
    if {[lsearch $inputs $f] == -1} {
        file copy -force $results_dir/$f outputs/$f
    }
}

# Step-specific post-processing step(s)
if {$sc_step == "or_synth_hier_report"} {
    # Copy inputs forward.
    foreach f $inputs {
        file copy -force "inputs/$f" "outputs/$f"
    }
} elseif {$sc_step == "or_synth"} {
    # Synthesis: Copy/rename RTL/SDC files
    file copy -force outputs/1_1_yosys.v outputs/1_synth.v
    file copy -force [lindex [dict get $sc_cfg input sdc] 0] outputs/1_synth.sdc
} elseif {$sc_step == "or_tdms_place" && [info exists ::env(MACRO_PLACEMENT)]} {
    # TDMS Placement: copy .odb input if this step was skipped.
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
    file copy -force outputs/5_2_route.odb outputs/6_1_fill.odb
    foreach f $inputs {
        if {[string last ".sdc" $f] == [expr [string length $f] - 4]} {
            file copy -force "inputs/$f" outputs/5_route.sdc
            file copy -force "inputs/$f" outputs/6_1_fill.sdc
        }
    }
}
