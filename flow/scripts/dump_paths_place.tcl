set dump_dir [expr {[info exists ::env(DUMP_DIR)] ? $::env(DUMP_DIR) : $::env(REPORTS_DIR)}]
set ::env(DUMP_STAGE_PREFIX) "3_place"
set ::env(DUMP_OUT_FILE) "$dump_dir/3_place_timing_paths.csv"
source flow/scripts/dump_paths_native.tcl
