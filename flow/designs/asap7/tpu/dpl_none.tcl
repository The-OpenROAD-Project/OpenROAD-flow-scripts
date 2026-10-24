# The top level has no standard cell to legalize, and its macros' boxes
# overlap where the parent's notch holds the tiles: detailed placement would
# count the overlap twice and refuse (DPL-0038). With nothing movable,
# there is nothing to legalize. Sourced before each stage that legalizes.
set movable 0
foreach inst [[ord::get_db_block] getInsts] {
  if { ![[$inst getMaster] isBlock] && ![$inst isFixed] } {
    incr movable
  }
}
if { $movable == 0 } {
  utl::info FLW 1 "No movable standard cell, detailed placement skipped."
  proc detailed_placement_helper { args } { }
  proc optimize_mirroring { args } { }
  proc check_placement { args } { return 0 }
}
