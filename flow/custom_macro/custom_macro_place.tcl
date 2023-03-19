#!/usr/bin/tclsh


#macro 0
set block [ord::get_db_block]
$block getName

set inst [$block findInst dmem/dmem0]

$inst setOrient MY



##we can change the orient also
# $inst setOrient R270

set x 20000
set y 26000

$inst setOrigin $x $y

$inst setPlacementStatus FIRM





#macro 1
set block [ord::get_db_block]
$block getName

set inst [$block findInst dmem/dmem1]

$inst setOrient R90



##we can change the orient also
# $inst setOrient R270

set x 94000
set y 100000

$inst setOrigin $x $y

$inst setPlacementStatus FIRM

##Macro 2
set block [ord::get_db_block]
$block getName

set inst [$block findInst dmem/dmem2]

$inst setOrient R0



##we can change the orient also
# $inst setOrient R270

set x 90000
set y 26000

$inst setOrigin $x $y

$inst setPlacementStatus FIRM


##Macro 3
set block [ord::get_db_block]
$block getName

set inst [$block findInst dmem/dmem3]

$inst setOrient R90



##we can change the orient also
# $inst setOrient R270

set x 94000
set y 10000

$inst setOrigin $x $y

$inst setPlacementStatus FIRM
