##############################
# Do not modify
source $env(OPDN_SRC)/src/analyze_power_grid.tcl
##############################
#
#Modify from here

read_lef $env(OBJECTS_DIR)/merged_padded.lef
read_def $env(RESULTS_DIR)/3_place.def
read_liberty $env(OBJECTS_DIR)/merged.lib
read_sdc $env(RESULTS_DIR)/3_place.sdc 


analyze_power_grid -verbose
