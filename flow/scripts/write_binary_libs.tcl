# Write binary liberty (.blib) files for the OpenROAD stages
source $::env(SCRIPTS_DIR)/util.tcl

set lib_files {}
if { [env_var_exists_and_non_empty CORNERS] } {
  foreach corner $::env(CORNERS) {
    set LIBKEY "[string toupper $corner]_LIB_FILES"
    lappend lib_files {*}$::env($LIBKEY)
  }
} else {
  lappend lib_files {*}$::env(LIB_FILES)
}

set blib_dir [binary_lib_dir]
file mkdir $blib_dir

# .blib files are named after the library, so names must be unique
array set blib_sources {}
foreach lib_file [lsort -unique $lib_files] {
  set blib [binary_lib_path $lib_file]
  if { [info exists blib_sources($blib)] } {
    # The same library spelled differently, e.g. foo.lib and ./foo.lib
    if { [file normalize $blib_sources($blib)] eq [file normalize $lib_file] } {
      continue
    }
    error "Liberty files $blib_sources($blib) and $lib_file both map to $blib"
  }
  set blib_sources($blib) $lib_file
  log_cmd write_liberty_binary $lib_file $blib
}
puts "Wrote [array size blib_sources] binary liberty files to $blib_dir"
