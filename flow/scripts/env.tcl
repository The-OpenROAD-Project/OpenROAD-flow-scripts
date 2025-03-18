# Print out make variables that have changed so that
# make can set them up.
set envfile [lindex $argv 0]
set env_vars [array get ::env]
source $envfile

foreach {var val} [array get ::env] {
  if {![dict exists $env_vars $var] || [dict get $env_vars $var] ne $val} {
    puts "export $var:=$val"
  }
}
