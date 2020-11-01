yosys -import

# Read blackbox stubs of standard cells. This allows for standard cell (or
# structural netlist) support in the input verilog
# Blackbox file must have power ports
read_verilog $::env(BLACKBOX_LVS_FILE)

# Read verilog netlist
read_verilog $::env(RESULTS_DIR)/6_final.v

# Write spice netlist
write_spice $::env(RESULTS_DIR)/6_final.cdl
