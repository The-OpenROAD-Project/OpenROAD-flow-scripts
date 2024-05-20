proc log_cmd {cmd args} {
  puts "$cmd [join $args " "]"
  $cmd {*}$args
}
