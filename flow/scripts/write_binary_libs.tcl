# Fill the binary liberty (.blib) cache with the libraries the OpenROAD stages read
source $::env(SCRIPTS_DIR)/util.tcl

set lib_files {}
if { [env_var_exists_and_non_empty CORNERS] } {
  foreach corner $::env(CORNERS) {
    lappend lib_files {*}$::env([string toupper $corner]_LIB_FILES)
  }
} else {
  lappend lib_files {*}$::env(LIB_FILES)
}

set written 0
set cached 0
array set seen {}
foreach lib_file $lib_files {
  # Libraries the flow has not generated yet are converted on a later run
  if { ![file exists $lib_file] } {
    continue
  }
  set blib [binary_lib_path $lib_file]
  if { [info exists seen($blib)] } {
    continue
  }
  set seen($blib) 1
  if { [binary_lib_usable $blib] } {
    incr cached
    continue
  }
  # Publish with a rename, so concurrent flows never read a partial file
  set tmp "$blib.tmp.[info hostname].[pid]"
  if {
    [catch {
      file mkdir [file dirname $blib]
      log_cmd write_liberty_binary $lib_file $tmp
      file rename -force $tmp $blib
    } msg]
  } {
    file delete -force $tmp
    puts "Could not write $blib: $msg"
    continue
  }
  incr written
}
puts "Binary liberty files: $written written, $cached already cached"
