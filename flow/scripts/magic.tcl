if {$::env(PLATFORM) == "tsmc65lp"} {
  scalegrid 1 10
} else {
  scalegrid 1 5
}

box 0 0 0 0
drc off
snap int

# Read tech lef
lef read $::env(OBJECTS_DIR)/merged.lef


# Read gds files
gds readonly true
gds rescale false
foreach gdsFile $::env(GDS_FILES) {
  gds read $gdsFile
}


# Read def and load design
load $::env(DESIGN_NAME)
def read $::env(RESULTS_DIR)/5_route.def

# Write gds
select top cell
expand
gds write $::env(RESULTS_DIR)/6_final.gds

puts "GDS write complete"

quit -noprompt
