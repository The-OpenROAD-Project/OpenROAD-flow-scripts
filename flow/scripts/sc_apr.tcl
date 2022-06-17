source sc_manifest.tcl

set sc_tool "openroad"
set sc_step [dict get $sc_cfg arg step]
set sc_index [dict get $sc_cfg arg index]
set sc_refdir [dict get $sc_cfg tool $sc_tool refdir $sc_step $sc_index]

set results_dir $::env(RESULTS_DIR)
set inputs [list]

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
} else {
    # strip or_ prefix
    set script [string replace $sc_step 0 2 ""].tcl
}

# Run script
source $sc_refdir/$script

# Copy anything from work dir that was not an input into outputs/
foreach f [glob -directory $results_dir -tails -nocomplain *] {
    if {[lsearch $inputs $f] == -1} {
        file copy -force $results_dir/$f outputs/
    }
}
