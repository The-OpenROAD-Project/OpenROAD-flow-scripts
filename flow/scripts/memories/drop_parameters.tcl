# AUTO_MEMORIES: the instances of a parameterized memory module (Sram
# #(NUM_ENTRIES)) keep their parameters when the module becomes a black
# box. The netlist then writes them out (`Sram #(.NUM_ENTRIES(32)) u0`),
# and OpenROAD's Verilog reader stops on a parameterized instance of a
# macro (STA-0171). The macro is the module at the widths detection
# sized it: drop the parameters from its instances. Run after the
# sources are read; `names` is the blackboxes.txt list.
proc auto_memories_drop_parameters { names } {
  foreach m $names {
    set dump [tee -q -s result.string dump t:$m]
    set params {}
    foreach {- name} [regexp -all -inline -- {parameter \\(\S+)} $dump] {
      lappend params $name
    }
    # once per name: dump lists it once per instance
    foreach name [lsort -unique $params] {
      setparam -unset $name t:$m
    }
  }
}
