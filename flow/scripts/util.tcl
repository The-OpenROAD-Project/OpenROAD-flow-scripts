proc log_cmd {cmd args} {
  puts "$cmd [join $args " "]"
  $cmd {*}$args
}

proc fast_route {} {
  if {[info exist ::env(FASTROUTE_TCL)]} {
    source $::env(FASTROUTE_TCL)
  } else {
    set_global_routing_layer_adjustment $::env(MIN_ROUTING_LAYER)-$::env(MAX_ROUTING_LAYER) $::env(ROUTING_LAYER_ADJUSTMENT)
    set_routing_layers -signal $::env(MIN_ROUTING_LAYER)-$::env(MAX_ROUTING_LAYER)
    if {[info exist ::env(MACRO_EXTENSION)]} {
      set_macro_extension $::env(MACRO_EXTENSION)
    }
  }
}

# Clean out unused environment variables so as to catch
# errors in the environment.yaml file that enumerates which
# envvars is used in which stage.
proc clean_environment_yaml {} {
  set env_file [file join $::env(SCRIPTS_FOLDER) environment.yaml]
  set env_data [yaml::load [read_file $env_file]]
  # we want only the name, not the full path of the last argument,
  # exclude the .tcl ending.
  set script [file tail [file rootname [file tail $::env(SCRIPT)]]]
  set stage [dict get $script [dict get script_stages $env_data]]
  foreach env_var [array names ::env] {
    if {![dict exists $env_data $env_var]} {
      continue
    }
    set stages [dict get $env_data $env_var]
    if {[lsearch -exact $stages $stage] == -1} {
      unset ::env($env_var)
    }
  }
}

clean_environment_yaml
