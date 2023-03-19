utl::set_metrics_stage "cts__{}"
source $::env(SCRIPTS_DIR)/load.tcl
load_design 3_place.odb 3_place.sdc "Starting CTS"

# Clone clock tree inverters next to register loads
# so cts does not try to buffer the inverted clocks.
repair_clock_inverters

set_routing_layers -clock M3-M5
#set_wire_rc -clock -layer M7
#set_wire_rc -clock -layer M6
set_wire_rc -clock -layer M5
set_wire_rc -clock -layer M4
set_wire_rc -clock -layer M3

remove_buffers
repair_design

# Run CTS
#set CTS_BUF_CELL {CKINVDCx10_ASAP7_75t_R CKINVDCx11_ASAP7_75t_R CKINVDCx12_ASAP7_75t_R CKINVDCx16_ASAP7_75t_R CKINVDCx20_ASAP7_75t_R CKINVDCx6p67_ASAP7_75t_R}
#set CTS_BUF_CELL {CKINVDCx5p33_ASAP7_75t_SL CKINVDCx6p67_ASAP7_75t_SL CKINVDCx8_ASAP7_75t_SL CKINVDCx9p33_ASAP7_75t_SL}
#set CTS_BUF_CELL {CKINVDCx5p33_ASAP7_75t_SL CKINVDCx6p67_ASAP7_75t_SL CKINVDCx8_ASAP7_75t_SL CKINVDCx9p33_ASAP7_75t_SL CKINVDCx10_ASAP7_75t_SL CKINVDCx11_ASAP7_75t_SL CKINVDCx12_ASAP7_75t_SL CKINVDCx14_ASAP7_75t_SL CKINVDCx16_ASAP7_75t_SL CKINVDCx20_ASAP7_75t_SL}
#set CTS_BUF_CELL {CKINVDCx12_ASAP7_75t_SL CKINVDCx5p33_ASAP7_75t_SL CKINVDCx6p67_ASAP7_75t_SL}
set CTS_BUF_CELL {CKINVDCx12_ASAP7_75t_SL CKINVDCx5p33_ASAP7_75t_SL CKINVDCx6p67_ASAP7_75t_SL}
#set CTS_BUF_CELL CKINVDCx6p67_ASAP7_75t_SL
#set CTS_BUF_CELL CKINVDCx12_ASAP7_75t_SL
#set CTS_BUF_CELL CKINVDCx11_ASAP7_75t_SL
set ROOT_BUF CKINVDCx20_ASAP7_75t_SL
#set ROOT_BUF CKINVDCx20_ASAP7_75t_R
set cluster_size 10
set cluster_diameter 30

#clock_tree_synthesis -root_buf $ROOT_BUF -buf_list $CTS_BUF_CELL \
#                     -sink_clustering_enable \
#                     -sink_clustering_size $cluster_size \
#                     -sink_clustering_max_diameter $cluster_diameter \
#                     -balance_levels
#
clock_tree_synthesis -root_buf $ROOT_BUF -buf_list $CTS_BUF_CELL \
                     -sink_clustering_enable \
                     -sink_clustering_size $cluster_size \
                     -sink_clustering_max_diameter $cluster_diameter \
		     -balance_levels


set_propagated_clock [all_clocks]

set_dont_use $::env(DONT_USE_CELLS)

utl::push_metrics_stage "cts__{}__pre_repair"
source $::env(SCRIPTS_DIR)/report_metrics.tcl

repair_design
estimate_parasitics -placement
report_metrics "cts pre-repair"
utl::pop_metrics_stage

repair_clock_nets
repair_design

utl::push_metrics_stage "cts__{}__post_repair"
estimate_parasitics -placement
report_metrics "cts post-repair"
utl::pop_metrics_stage

set_placement_padding -global \
    -left $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT) \
    -right $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT)
detailed_placement

estimate_parasitics -placement
repair_design

puts "Repair setup and hold violations..."

# process user settings
set additional_args ""
if { [info exists ::env(SETUP_SLACK_MARGIN)] && $::env(SETUP_SLACK_MARGIN) > 0.0} {
  puts "Setup slack margin $::env(SETUP_SLACK_MARGIN)"
  append additional_args " -setup_margin $::env(SETUP_SLACK_MARGIN)"
}
if { [info exists ::env(HOLD_SLACK_MARGIN)] && $::env(HOLD_SLACK_MARGIN) > 0.0} {
  puts "Hold slack margin $::env(HOLD_SLACK_MARGIN)"
  append additional_args " -hold_margin $::env(HOLD_SLACK_MARGIN)"
}

############ Modified to number of violating paths to repair ###############

if { [info exists ::env(REPAIR_TNS)] && $::env(REPAIR_TNS) > 0.0 } {
	puts "Total percentage of violating paths to repair repair $::env(REPAIR_TNS)"
	append additional_args " -repair_tns $::env(REPAIR_TNS)"
}

############################################################################

repair_timing {*}$additional_args
repair_design

detailed_placement
check_placement -verbose

report_metrics "cts final"

if { [info exists ::env(POST_CTS_TCL)] } {
  source $::env(POST_CTS_TCL)
}

if {![info exists save_checkpoint] || $save_checkpoint} {
  if {[info exists ::env(GALLERY_REPORT)]  && $::env(GALLERY_REPORT) != 0} {
      write_def $::env(RESULTS_DIR)/4_1_cts.def
  }
  write_db $::env(RESULTS_DIR)/4_1_cts.odb
  write_sdc $::env(RESULTS_DIR)/4_cts.sdc
}

