# Runs one flow stage script (ORFS_STAGE_SCRIPT) and, unless
# SKIP_STAGE_ART, snapshots the design for util/stage_art.py: on success
# the design the stage leaves behind, on failure the design as it was
# when the error hit, which is what the failure explainers draw. The
# stage's own error is re-raised unchanged.
source $::env(SCRIPTS_DIR)/stage_art.tcl

set snapshot [expr { !$::env(SKIP_STAGE_ART) }]
if { [catch { source $::env(SCRIPTS_DIR)/$::env(ORFS_STAGE_SCRIPT) } err opts] } {
  # The stage's own error is what matters; a snapshot that fails on top
  # of it is reported, not raised.
  if { $snapshot && [catch { stage_art_snapshot $::env(ORFS_STAGE) $err } snapshot_err] } {
    puts "stage_art: failure snapshot failed: $snapshot_err"
  }
  return -options $opts $err
}
if { $snapshot } {
  stage_art_snapshot $::env(ORFS_STAGE)
}
