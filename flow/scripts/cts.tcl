utl::set_metrics_stage "cts__{}"
source $::env(SCRIPTS_DIR)/load.tcl
load_design 3_place.odb 3_place.sdc "Starting CTS"

# Clone clock tree inverters next to register loads
# so cts does not try to buffer the inverted clocks.
repair_clock_inverters

# Run CTS
if {[info exist ::env(CTS_CLUSTER_SIZE)]} {
  set cluster_size "$::env(CTS_CLUSTER_SIZE)"
} else {
  set cluster_size 30
}
if {[info exist ::env(CTS_CLUSTER_DIAMETER)]} {
  set cluster_diameter "$::env(CTS_CLUSTER_DIAMETER)"
} else {
  set cluster_diameter 100
}

proc save_progress {stage} {
  puts "Run 'make gui_$stage.odb' to load progress snapshot"
  write_db $::env(RESULTS_DIR)/$stage.odb
  write_sdc $::env(RESULTS_DIR)/$stage.sdc
}

if {[info exist ::env(CTS_BUF_DISTANCE)]} {
  clock_tree_synthesis -root_buf "$::env(CTS_BUF_CELL)" -buf_list "$::env(CTS_BUF_CELL)" \
                      -sink_clustering_enable \
                      -sink_clustering_size $cluster_size \
                      -sink_clustering_max_diameter $cluster_diameter \
                      -distance_between_buffers "$::env(CTS_BUF_DISTANCE)" \
                      -balance_levels
} else {
  clock_tree_synthesis -root_buf "$::env(CTS_BUF_CELL)" -buf_list "$::env(CTS_BUF_CELL)" \
                      -sink_clustering_enable \
                      -sink_clustering_size $cluster_size \
                      -sink_clustering_max_diameter $cluster_diameter \
                      -balance_levels
}

if {[info exist ::env(CTS_SNAPSHOTS)]} {
  save_progress 4_1_pre_repair_clock_nets
}

set_propagated_clock [all_clocks]

set_dont_use $::env(DONT_USE_CELLS)

utl::push_metrics_stage "cts__{}__pre_repair"
source $::env(SCRIPTS_DIR)/report_metrics.tcl

estimate_parasitics -placement
report_metrics "cts pre-repair"
utl::pop_metrics_stage

repair_clock_nets

utl::push_metrics_stage "cts__{}__post_repair"
estimate_parasitics -placement
report_metrics "cts post-repair"
utl::pop_metrics_stage

set_placement_padding -global \
    -left $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT) \
    -right $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT)

proc run_detailed_placement {max_displacement} {
    if {$max_displacement eq ""} {
        set command "detailed_placement"
        try {
        detailed_placement
        puts "Command succeeded: $command"
        return 0
    } on error {errMsg} {
        puts "Command failed: $command"
        puts "Error message: $errMsg"
        return 1
    }



    } else {
        set command "detailed_placement -max_displacement $max_displacement"
    }

    

    puts "Running: detailed_placement -max_displacement $max_displacement"
    try {
        detailed_placement -max_displacement $max_displacement
        puts "Command succeeded: $command"
        return 0
    } on error {errMsg} {
        puts "Command failed: $command"
        puts "Error message: $errMsg"
        return 1
    }
}

# 初始运行detailed_placement
set success [run_detailed_placement ""]

# 如果失败，按顺序运行带有不同max_displacement值的命令
if {$success} {
    set max_displacement_values {50 100 500 1000 5000 10000}
    foreach max_displacement $max_displacement_values {
        set success [run_detailed_placement $max_displacement]
        if {!$success} {
            break
        }
    }
}

estimate_parasitics -placement

if {[info exist ::env(CTS_SNAPSHOTS)]} {
  save_progress 4_1_pre_repair_hold_setup
}

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

puts "TNS end percent $::env(TNS_END_PERCENT)"
append additional_args " -repair_tns $::env(TNS_END_PERCENT)"

if { [info exists ::env(SKIP_PIN_SWAP)] } {
  puts "Skipping pin swapping during optimization"
  append additional_args " -skip_pin_swap"
}

if { [info exists ::env(SKIP_GATE_CLONING)] } {
  puts "Skipping gate cloning during optimization"
  append additional_args " -skip_gate_cloning"
}

repair_timing {*}$additional_args



set success [run_detailed_placement ""]

# 如果失败，按顺序运行带有不同max_displacement值的命令
if {$success} {
    set max_displacement_values {50 100 500 1000 5000 10000}
    foreach max_displacement $max_displacement_values {
        set success [run_detailed_placement $max_displacement]
        if {!$success} {
            break
        }
    }
}





# set result [catch {detailed_placement} msg]
# if {$result != 0} {
#   save_progress 4_1_error
#   puts "Detailed placement failed in CTS: $msg"
#   return -code $result
# }

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
