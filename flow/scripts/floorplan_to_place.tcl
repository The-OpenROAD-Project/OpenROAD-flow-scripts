# Enable keeping variables between stages
set ::env(KEEP_VARS) 1
set ::env(WRITE_ODB_AND_SDC_EACH_STAGE) 0

# Floorplan
source $::env(SCRIPTS_DIR)/floorplan.tcl

# Macro placement
source $::env(SCRIPTS_DIR)/macro_place.tcl

# Tapcell insertion
source $::env(SCRIPTS_DIR)/tapcell.tcl

# PDN
source $::env(SCRIPTS_DIR)/pdn.tcl

# Global placement skipping IOs
source $::env(SCRIPTS_DIR)/global_place_skip_io.tcl

# IO placement
source $::env(SCRIPTS_DIR)/io_placement.tcl

# Global placement
source $::env(SCRIPTS_DIR)/global_place.tcl

# Resizing
source $::env(SCRIPTS_DIR)/resize.tcl

# Detailed placement
source $::env(SCRIPTS_DIR)/detail_place.tcl

# Repair timing after placement
source $::env(SCRIPTS_DIR)/repair_timing_post_place.tcl

write_db $::env(RESULTS_DIR)/3_6_place_repair_timing.odb
write_sdc -no_timestamp $::env(RESULTS_DIR)/3_6_place_repair_timing.sdc
