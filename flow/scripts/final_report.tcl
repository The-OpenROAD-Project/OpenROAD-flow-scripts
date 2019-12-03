# Read liberty files
foreach libFile $::env(LIB_FILES) {
  read_liberty $libFile
}


# Read lef def and sdc
read_lef $::env(OBJECTS_DIR)/merged.lef
read_def $::env(RESULTS_DIR)/5_route.def
read_sdc $::env(RESULTS_DIR)/5_route.sdc


log_begin $::env(REPORTS_DIR)/6_final_report.rpt


report_checks -path_delay min
report_checks -path_delay max
report_checks -unconstrained

report_tns
report_wns


report_power

report_design_area

log_end

exit