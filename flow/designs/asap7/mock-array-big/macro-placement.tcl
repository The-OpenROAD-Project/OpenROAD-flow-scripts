# fish out values from single source of truth: config.py
set vals [regexp -all -inline {\S+} [exec sh -c {cd designs/asap7/mock-array-big && python3 -c "import config;print(f'{config.rows} {config.cols} {config.x_pitch} {config.offset_x} {config.y_pitch} {config.offset_y}')"}]]
lassign $vals rows cols x_pitch offset_x y_pitch offset_y

set block [ord::get_db_block]
set units [$block getDefUnits]

for {set row 0} {$row < $rows} {incr row} {
  for {set col 0} {$col < $cols} {incr col} {
    set inst [$block findInst [format "ces_%d_%d" $row $col]]
    $inst setOrient R0
    set x [expr round([expr {$offset_x + $col * $x_pitch}] * $units)]
    set y [expr round([expr {$offset_y + $row * $y_pitch}] * $units)]

    $inst setOrigin $x $y 
    $inst setPlacementStatus FIRM
  }
}
