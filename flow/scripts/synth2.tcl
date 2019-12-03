yosys -import


# Reading blackbox implementation of standard cells (treated as blackboxes)
read_verilog $::env(BLACKBOX_V_FILE)

# read verilog files
foreach file $::env(VERILOG_FILES) {
  read_verilog $file
}

# Mapping required for memory macros treated as blackboxes
hierarchy -generate tsmc65lp_* o:Q o:QA o:QB \
                               i:CLK i:CLKA i:CLKB \
                               i:CEN i:CENA i:CENB \
                               i:GWEN \
                               i:A i:AA i:AB \
                               i:D i:DB \
                               i:WEN i:WENA i:WENB\
                               i:STOV \
                               i:EMA i:EMAA i:EMAB \
                               i:EMAW i:EMAS i:RET1N \
                               i:SE i:TEN o:CENY o:WENY o:AY \
                               o:SO i:SI i:TCEN i:TWEN i:TA i:TD \
                               i:DFTRAMBYP i:PGEN i:KEN i:BEN i:TQ

# generic synthesis
synth  -top $::env(DESIGN_NAME)
opt_clean -purge

# mapping for Registers
dfflibmap -liberty $::env(OBJECTS_DIR)/merged.lib


# mapping for technology
abc -D [expr $::env(CLOCK_PERIOD) * 1000] \
    -constr "$::env(SDC_FILE)" \
    -liberty $::env(OBJECTS_DIR)/merged.lib

# Splitting nets resolves unwanted compound assign statements ( assign {..} = {..})
splitnets -ports; opt
hilomap -hicell {*}$::env(TIEHI_CELL_AND_PORT) -locell {*}$::env(TIELO_CELL_AND_PORT)

flatten
opt

# cleanup
clean
opt_clean -purge

# reports
tee -o $::env(REPORTS_DIR)/synth_check.txt check
tee -o $::env(REPORTS_DIR)/synth_stat.txt stat -liberty $::env(OBJECTS_DIR)/merged.lib

# write synthesized design
write_verilog -noattr -noexpr -nohex -nodec $::env(RESULTS_DIR)/1_synth.yosys.v
