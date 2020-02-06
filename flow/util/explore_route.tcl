# Read process files
foreach libFile $::env(LIB_FILES) {
  read_liberty $libFile
}
read_lef $::env(OBJECTS_DIR)/merged_padded.lef
read_def $::env(RESULTS_DIR)/4_cts.def


## Setup
set id "$::env(min_routing_layer)_$::env(max_routing_layer)_$::env(capacity_adjustment)_$::env(unidirectional_routing)_$::env(layers_adjustment1)_$::env(layers_adjustment2)_$::env(layers_adjustment3)_$::env(layers_adjustment4)_$::env(layers_adjustment5)_$::env(layers_adjustment6)_$::env(layers_adjustment7)"
puts "Run ID: $id"

file delete -force $::env(RESULTS_DIR)/explore/$id
file mkdir $::env(RESULTS_DIR)/explore/$id

## global_routing
set_wire_rc -layer $::env(WIRE_RC_LAYER)
fastroute -output_file $::env(RESULTS_DIR)/explore/$id/route.guide \
  -min_routing_layer $::env(min_routing_layer) \
  -max_routing_layer $::env(max_routing_layer) \
  -capacity_adjustment $::env(capacity_adjustment) \
  -unidirectional_routing $::env(unidirectional_routing) \
  -layers_adjustment [list "1 $::env(layers_adjustment1)" \
                           "2 $::env(layers_adjustment2)" \
                           "3 $::env(layers_adjustment3)" \
                           "4 $::env(layers_adjustment4)" \
                           "5 $::env(layers_adjustment5)" \
                           "6 $::env(layers_adjustment6)" \
                           "7 $::env(layers_adjustment7)"]

## Create Param File
set paramFile [open "$::env(RESULTS_DIR)/explore/$id/TritonRoute.param" w]

puts $paramFile "lef:$::env(TRITON_ROUTE_LEF)"
puts $paramFile "def:$::env(RESULTS_DIR)/4_cts.def"
puts $paramFile "guide:$::env(RESULTS_DIR)/explore/$id/route.guide"
puts $paramFile "output:$::env(RESULTS_DIR)/explore/$id/5_route.def"
puts $paramFile "outputTA:$::env(RESULTS_DIR)/explore/$id/5_route_TA.def"
puts $paramFile "outputguide:$::env(RESULTS_DIR)/explore/$id/output_guide.mod"
puts $paramFile "outputDRC:$::env(RESULTS_DIR)/explore/$id/5_route_drc.rpt"
puts $paramFile "outputMaze:$::env(RESULTS_DIR)/explore/$id/maze.log"
puts $paramFile "threads:1"
puts $paramFile "cpxthreads:1"
puts $paramFile "verbose:1"
puts $paramFile "gap:0"
puts $paramFile "timeout:2400"
close $paramFile

## TritonRoute
exec TritonRoute $::env(RESULTS_DIR)/explore/$id/TritonRoute.param


## Innovus DRC Checking
exec innovus -no_gui -no_logv -execute "loadLefFile $::env(OBJECTS_DIR)/merged.lef ; \
                                       loadDefFile $::env(RESULTS_DIR)/explore/$id/5_route.def; \
                                       verify_drc -limit 10000 -report $::env(RESULTS_DIR)/explore/$id/drc.rpt; \
                                       exit"


exit
