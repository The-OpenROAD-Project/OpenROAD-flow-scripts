# Runs one step's script, $STEP_TCL, for flow.sh. With WRITE_ON_FAILURE=1,
# an error anywhere in the step writes the design as it was at the failure
# to $RESULTS_DIR/failed.odb and failed.sdc, so it can be inspected without
# running the step again; the step then fails with the original error.

proc write_failure_checkpoint { } {
  if { !$::env(WRITE_ON_FAILURE) } {
    return
  }
  set chip [[ord::get_db] getChip]
  if { $chip == "NULL" || [$chip getBlock] == "NULL" } {
    puts "No design loaded, no failure checkpoint written"
    return
  }
  puts "Writing failure checkpoint $::env(RESULTS_DIR)/failed.odb"
  write_sdc -no_timestamp $::env(RESULTS_DIR)/failed.sdc
  write_db $::env(RESULTS_DIR)/failed.odb
}

if { [catch { uplevel #0 [list source $::env(STEP_TCL)] } msg opts] } {
  set info [dict get $opts -errorinfo]
  set code [dict get $opts -errorcode]
  if { [catch { write_failure_checkpoint } checkpoint_error] } {
    puts "Warning: failure checkpoint not written: $checkpoint_error"
  }
  error $msg $info $code
}
