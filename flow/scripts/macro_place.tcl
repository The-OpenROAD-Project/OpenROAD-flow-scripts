
mplace_external mp

mp import_lef $::env(OBJECTS_DIR)/merged_padded.lef

mp import_def $::env(RESULTS_DIR)/2_3_floorplan_tdms.def
mp import_verilog $::env(RESULTS_DIR)/1_synth.v
mp import_sdc $::env(RESULTS_DIR)/1_synth.sdc

# Read liberty files
foreach libFile $::env(LIB_FILES) {
  mp import_lib $libFile
}

mp import_global_config $::env(IP_GLOBAL_CFG)

mp place_macros

mp set_plot_enable true

puts "Possible Solutions: [mp get_solution_count]"
mp export_all_def $::env(OBJECTS_DIR)/$::env(DESIGN_NAME)
mp export_def $::env(RESULTS_DIR)/2_4_floorplan_macro.def

exit