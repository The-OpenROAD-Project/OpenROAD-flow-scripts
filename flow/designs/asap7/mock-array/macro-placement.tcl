# fish out values from single source of truth: config.py
set vals [regexp -all -inline {\S+} [exec sh -c {cd designs/asap7/mock-array && python3 -c "import config;print(f'{config.rows} {config.cols} {config.pitch_x} {config.pitch_y} {config.margin_x} {config.margin_y} {config.placement_grid_x} {config.placement_grid_y}')"}]]
lassign $vals rows cols pitch_x pitch_y margin_x margin_y placement_grid_x placement_grid_y

set block [ord::get_db_block]
set units [$block getDefUnits]

for {set row 0} {$row < $rows} {incr row} {
  for {set col 0} {$col < $cols} {incr col} {
    set inst [$block findInst [format "ces_%d_%d" $row $col]]
    set bbox [$inst getBBox]

    set w [$bbox getDX]
    set h [$bbox getDY]

    set x [expr int((($margin_x + (($placement_grid_x * $pitch_x) * ($col + 1.0))) * $units) + ($w * $col))]
    set y [expr int((($margin_y + (($placement_grid_y * $pitch_y) * ($row + 1.0))) * $units) + ($h * $row))]

    $inst setOrient R0
    $inst setOrigin $x $y
    $inst setPlacementStatus FIRM
  }
}
