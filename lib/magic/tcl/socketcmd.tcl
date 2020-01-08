#-------------------------------------------------------------
# socketcmd.tcl ---
#
# Method to pass commands to magic through a socket
# From the client side, use "set chan [socket 0.0.0.0 12946]"
# and pass commands with "puts $chan {magic command}" and
# "flush $chan".
#-------------------------------------------------------------

set commPort 12946

proc handleComm {chan} {
    if {[gets $chan line] >= 0} {
        puts $line
        eval $line
    }
    if {[eof $chan]} {
        close $chan
    }
}

proc acceptComm {chan addr port} {
    fconfigure $chan -blocking 0 -buffering line -translation crlf 
    fileevent $chan readable [list handleComm $chan]
}

socket -server acceptComm $commPort
