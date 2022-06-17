source sc_manifest.tcl

set sc_tool "openroad"
set sc_step [dict get $sc_cfg arg step]
set sc_index [dict get $sc_cfg arg index]
set sc_refdir [dict get $sc_cfg tool $sc_tool refdir $sc_step $sc_index]

set results_dir $::env(RESULTS_DIR)
set inputs [list]

file mkdir $results_dir
foreach f [glob -directory inputs/ -tails -nocomplain *] {
    file copy -force inputs/$f $results_dir
    lappend inputs $f
}

if {$sc_step == "export"} {
    set script "klayout.tcl"
} else {
    set script [string replace $sc_step 0 2 ""].tcl
}

source $sc_refdir/$script

foreach f [glob -directory $results_dir -tails -nocomplain *] {
    if {[lsearch $inputs $f] == -1} {
        file copy -force $results_dir/$f outputs/
    }
}
