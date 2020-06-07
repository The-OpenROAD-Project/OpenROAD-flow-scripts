#!/bin/sh
# the next line restarts using tclsh \
exec tclsh "$0" ${1+"$@"}

package require wrapper
package require lefdef

if {[set idx [lsearch -exact $argv {-cfg}]] > -1} {
  set cfg_file [lindex $argv [expr $idx + 1]]
  set argv [lreplace $argv $idx [expr $idx + 1]]

  wrapper information 0 "Loading config file $cfg_file"
  source $cfg_file
} else {
  wrapper critical 2 "no configuration data loaded"
}

if {[lindex $argv 0] == "-macro"} {
  set lef_files [lrange $argv 1 end]
  set cells {}
  foreach file_name $lef_files {
    puts "  Reading $file_name"
    set cells [concat $cells [wrapper macro $file_name]]
  }
  wrapper information 2 "Generated wrappers for"
  foreach cell $cells {
    puts "  $cell"
  }
} else {
  wrapper critical 1 "Unexpected argument [lindex $argv 0] - should be -macro"
}
