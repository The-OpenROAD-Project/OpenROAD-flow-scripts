set sdc_version 2.0

# Set the current design
current_design jpeg_encoder

create_clock -name "clk" -period 1200.0 -waveform {0.0 600.0} [get_ports clk]
