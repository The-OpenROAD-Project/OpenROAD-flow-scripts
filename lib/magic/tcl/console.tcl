# console.tcl:
#
#  Defines Procedures which should be defined within the console
#  (master) interpreter (i.e., tkcon, if it is executed as a separate
#  interpreter).  Note that this can always be worked around via the
#  "tkcon master" or "tkcon slave" commands, but this method organizes
#  things in a more natural way.

wm geometry . 120x16+150-50

proc gettext {{prompt {}} {response {}}} {

   # Differentiate between console command-line and button execution
   # (Determines whether to prompt before or after execution)
   if {[.text index output] == [.text index end]} {
      ::tkcon::Prompt
      set mode 1
   } else {
      set mode 0
   }

   replaceprompt "?"
   if {$prompt != {}} {
      .text insert end $prompt {stdout}
   }
   if {$response != {}} {
      set result [tkcon congets $response]
   } else {
      set result [tkcon congets]
   }
   tkcon set ::tkcon::OPT(prompt1) "% "
   if {$mode == 0} {
      ::tkcon::Prompt
   } else {
      .text mark set output end
      tkcon console see output	;# adjust view to encompass newline
      update idletasks
   }
   return $result
}

slave alias magic::dialog gettext
slave alias magic::consolegeometry wm geometry .
slave alias magic::consolefocus focus -force .text
slave alias magic::suspendout rename temp_puts puts
slave alias magic::resumeout rename puts temp_puts

# Ensure that destroying the console window queries for saving
# modified layouts rather than forcing an immediate exit.

wm protocol . WM_DELETE_WINDOW {tkcon slave slave magic::quit}

proc temp_puts { args } {
    # null procedure;  output is suspended.
}

proc magiccolor { ch } {
    tkcon slave slave magic::magiccolor $ch
}

proc replaceprompt { ch } {
    tkcon set ::tkcon::OPT(prompt1) "$ch "
    .text delete prompt.last-2c
    .text insert [.text index prompt.last-1c] $ch {prompt}
    .text mark set output [.text index output-1c]
}

# This procedure repaints the magic console to match the magic colormap.
# It's only called if magic is run in 8-bit (PseudoColor) visual mode.
# This is called from inside magic (graphics/grTk1.c).

proc repaintconsole {} {
    puts stdout "Repainting console in magic layout window colors"

# Because the console invokes a slave interpreter, we have to evaluate
# magic command "magiccolor" in the slave interpreter.  Note that all of
# these colors are short names from the ".dstyle6" file.  Long names are
# also acceptable.

    ::set yellow [interp eval $::tkcon::OPT(exec) magiccolor yellow2]
    ::set black [interp eval $::tkcon::OPT(exec) magiccolor black]
    ::set gray [interp eval $::tkcon::OPT(exec) magiccolor gray2]
    ::set green [interp eval $::tkcon::OPT(exec) magiccolor green3]
    ::set purple [interp eval $::tkcon::OPT(exec) magiccolor purple1]
    ::set border [interp eval $::tkcon::OPT(exec) magiccolor window_border]
    ::set blue [interp eval $::tkcon::OPT(exec) magiccolor blue2]
    ::set red [interp eval $::tkcon::OPT(exec) magiccolor red3]
    ::set bgcolor [interp eval $::tkcon::OPT(exec) magiccolor no_color_at_all]

    tkcon set ::tkcon::COLOR(bg) $bgcolor
    tkcon set ::tkcon::COLOR(blink) $yellow
    tkcon set ::tkcon::COLOR(cursor) $black
    tkcon set ::tkcon::COLOR(disabled) $gray
    tkcon set ::tkcon::COLOR(proc) $green
    tkcon set ::tkcon::COLOR(var) $purple
    tkcon set ::tkcon::COLOR(prompt) $border
    tkcon set ::tkcon::COLOR(stdin) $black
    tkcon set ::tkcon::COLOR(stdout) $blue
    tkcon set ::tkcon::COLOR(stderr) $red

    .text configure -background $bgcolor
    .text configure -foreground $black
    .text configure -insertbackground $black

    .text tag configure var -background  $bgcolor
    .text tag configure blink -background  $bgcolor
    .text tag configure find -background  $bgcolor
    .text tag configure stdout -background  $bgcolor
    .text tag configure stderr -background  $bgcolor
    .text tag configure proc -background  $bgcolor
    .text tag configure prompt -background  $bgcolor

    .text tag configure var -foreground $purple
    .text tag configure blink -foreground $yellow
    .text tag configure find -foreground $yellow
    .text tag configure stdout -foreground $blue
    .text tag configure stderr -foreground $red
    .text tag configure proc -foreground $green
    .text tag configure prompt -foreground $border

    .sy configure -background $bgcolor
}

# Rewrite the ::tkcon::New procedure so that it does not attempt to
# load a second version of magic into the interpreter, which is fatal.

rename ::tkcon::New ::tkcon::NewConsole

proc ::tkcon::New {} {
   global argv0 argc argv

   set argc 1 
   list set argv $argv0   
   ::tkcon::NewConsole 
}
