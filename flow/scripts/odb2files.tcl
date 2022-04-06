read_db $::env(ODB_FILE)
write_def $::env(DEF_FILE)

if { [info exists ::env(VERILOG_FILE)] } {
    write_verilog $::env(VERILOG_FILE)
}

exit
