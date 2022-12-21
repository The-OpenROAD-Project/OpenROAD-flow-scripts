source "helpers.tcl"
# Read final routing DB file
read_db ./5_route.odb
# Add metal density
density_fill -rules ../../../platforms/sky130hd/fill.json
# Save DB file
set mfill_odb [make_result_file 6_1_fill.odb]
set mfill_verilog [make_result_file 6_1_fill.v]
write_db $mfill_odb
write_verilog $mfill_verilog
