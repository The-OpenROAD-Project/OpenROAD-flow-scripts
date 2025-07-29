proc load_lef_sky130 { } {
  set FLOW_PATH [exec pwd]
  read_lef $FLOW_PATH/../../../platforms/sky130hd/lef/sky130_fd_sc_hd.tlef
  read_lef $FLOW_PATH/../../../platforms/sky130hd/lef/sky130_fd_sc_hd_merged.lef
}
create_toolbar_button -name "Load_LEF" -text "Load_LEF" -script {load_lef_sky130} -echo
