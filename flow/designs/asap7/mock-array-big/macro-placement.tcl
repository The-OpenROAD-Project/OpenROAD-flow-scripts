# fish out values from single source of truth: config.py
set vals [regexp -all -inline {\S+} [exec sh -c {cd designs/asap7/mock-array-big && python3 -c "import config;print(f'{config.rows} {config.cols} {config.pitch_and_margin} {config.die_offset_x} {config.die_offset_y}')"}]]
lassign $vals rows cols pitch_and_margin die_offset_x die_offset_y

set block [ord::get_db_block]
set units [$block getDefUnits]

for {set row 0} {$row < $rows} {incr row} {
  for {set col 0} {$col < $cols} {incr col} {
    set inst [$block findInst [format "ces_%d_%d" $row $col]]
    $inst setOrient R0
    set x [expr round([expr {$die_offset_x + $col * $pitch_and_margin}] * $units)]
    set y [expr round([expr {$die_offset_y + $row * $pitch_and_margin}] * $units)]

    $inst setOrigin $x $y
    $inst setPlacementStatus FIRM
  }
}
