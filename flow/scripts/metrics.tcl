# Example of a custom metrics.tcl script. From within bazel-orfs, it is used
# to run metrics in parallel to the subsequent stages, thus mitigating the
# running times for creating a report for a large design.
#
# To test:
#
# make run ODB_FILE=results/nangate45/gcd/base/2_floorplan.odb METRICS_NAME=floorplan METRICS_NUMBER=2 RUN_SCRIPT=scripts/metrics.tcl
# cat logs/nangate45/gcd/base/floorplan.json


utl::set_metrics_stage $::env(METRICS_NAME)__{}
source $::env(SCRIPTS_DIR)/report_metrics.tcl
source $::env(SCRIPTS_DIR)/open.tcl
report_metrics $::env(METRICS_NUMBER) $::env(METRICS_NAME) false false
