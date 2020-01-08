#-------------------------------------------------------
# Useful tools for the Tcl-based version of magic
#-------------------------------------------------------
# This file is included by wrapper.tcl if it is found
# in the magic install directory.
#-------------------------------------------------------

# Suspend and resume drawing in windows
# Modified 8/17/04 so that calls to suspendall and resumeall
# may nest.
# Modified 11/23/16
# Modified 12/30/16 to add automatic button accelerator text

proc magic::suspendall {} {
   global Winopts
   if {[info commands winfo] != ""} {
      foreach window [magic::windownames layout] {
         set framename [winfo toplevel $window]
         if {$framename == "."} {
	    set framename $window
         }
         if {[incr Winopts(${framename},suspend)] == 1} {
	    $window update suspend
         }
      }
   }
}

proc magic::resumeall {} {
   global Winopts
   if {[info commands winfo] != ""} {
      foreach window [magic::windownames layout] {
         set framename [winfo toplevel $window]
         if {$framename == "."} {
	    set framename $window
         }
         if {$Winopts($framename,suspend) <= 0} {
      	    error "resume called without suspend"
         } else {
	    incr Winopts($framename,suspend) -1
	    if { $Winopts(${framename},suspend) <= 0 } {
	       unset Winopts(${framename},suspend)
	       $window update resume
	    }
	 }
      }
   }
}

#--------------------------------------------------------------------------
# Crash backups.  Create a new crash recovery backup every 10 minutes, or
# at the interval specified by Opts(backupinterval)
#--------------------------------------------------------------------------

proc magic::makecrashbackup {} {
   global Opts

   crash save
   if {$Opts(backupinterval) > 0} {
      after $Opts(backupinterval) magic::makecrashbackup
   }
}

proc magic::crashbackups {{option start}} {
   global Opts

   switch -exact $option {
      start {
         if {[catch set Opts(backupinterval)]} {
            set Opts(backupinterval) 600000
         }
         after $Opts(backupinterval) magic::makecrashbackup
      }
      stop -
      cancel {
         after cancel magic::makecrashbackup
      }
   }
}

#--------------------------------------------------------------------------
# Push and Pop---Treat the edit hierarchy like a stack.
#--------------------------------------------------------------------------

proc magic::pushstack {{name ""}} {
   global editstack  
   if {$name == ""} {
      # no cell selected, so see if we can select one
      set selected [what -list]
      if {[llength [lindex $selected 2]] == 0} {
	 pushbox
	 select cell
	 popbox
      }
      set name [cellname list self]
   }

   if {$name == ""} {
       error "No cell to push!"
   } elseif {[llength $name] > 1} {
       error "Too many cells selected!"
   }
   if {[catch {lindex $editstack end}]} {
      set editstack {}
   }
   lappend editstack [view get]
   lappend editstack [cellname list window]
   set ltag [tag load]
   tag load {}
   load $name
   catch {magic::cellmanager}
   catch {magic::captions}
   tag load $ltag
   return
}

proc magic::popstack {} {
   global editstack
   if {[llength $editstack] == 0} {
      error "No subcell stack!"
   } else {
      set ltag [tag load]
      tag load {}
      load [lindex $editstack end]             
      view [lindex $editstack end-1]             
      tag load $ltag
      set editstack [lrange $editstack 0 end-2]
      catch {magic::cellmanager}
      catch {magic::captions}
   }
   return
}

proc magic::clearstack {} {
   global editstack
   set editstack {}
}

# More stacking stuff---stacked box values

#---------------------------------------------------------------------
# pushbox --
#       Remember the current box values
#
#---------------------------------------------------------------------

proc magic::pushbox {{values {}}} {
   global boxstack
   set snaptype [snap list]
   snap internal
   if {[catch {set boxstack}]} {
      set boxstack {}
   }
   if {$values == {}} {
      lappend boxstack [box values]
   } else {
      lappend boxstack $values
   }
   snap $snaptype
   return
}

#---------------------------------------------------------------------
# popbox --
#       Recall the last pushed box position
#
# Option "type" may be empty, or "size" or "position" to pop a specific
# box size or position without affecting the other box parameters.
#---------------------------------------------------------------------

proc magic::popbox {{type values}} {
   global boxstack
   set snaptype [snap list]
   snap internal
   if {[catch {set boxstack}]} {
      error "No stack"
   } elseif {$boxstack == {}} {
      error "Empty stack"
   }
   set b [lindex $boxstack end]
   switch -exact $type {
      values {
        box values [lindex $b 0] [lindex $b 1] [lindex $b 2] [lindex $b 3]
      }
      size {
        box size [expr {[lindex $b 2] - [lindex $b 0]}] \
                  [expr {[lindex $b 3] - [lindex $b 1]}]
      }
      position {
        box position [lindex $b 0] [lindex $b 1]
      }
   }
   set boxstack [lrange $boxstack 0 end-1]
   snap $snaptype
   return $b
}

#---------------------------------------------------------------------
# peekbox --
#       Shell procedure that calls popbox but follows by pushing the
#       popped value back onto the stack, resulting in a "peek" mode.
#
# Options are the same as for "popbox" (see above).
#---------------------------------------------------------------------

proc magic::peekbox {{type values}} {
   global bidx
   if {![catch {set b [magic::popbox $type]}]} {
      magic::pushbox $b
   } else {
      error "No stack"
   }
   return $b
}

#---------------------------------------------------------------------
# Automatic handling of menu button accelerator text
#---------------------------------------------------------------------

proc magic::button_auto_bind_text {framename} {
    set macrolist [string trimleft [string trimright \
		[string map {magic:: {}} [macro list -reverse]]]]
    set macrodict [dict create {*}${macrolist}]
    set menutop [winfo children ${framename}.titlebar.mbuttons]
    foreach menub $menutop {
	set menuw [lindex [winfo children $menub] 0]
	set items [$menuw index end]
        for {set i 0} {$i <= $items} {incr i} {
	    set itype [$menuw type $i]
	    if {$itype == "command"} {
		set icmd [string trimleft [string trimright \
			[string map {magic:: {}} [$menuw entrycget $i -command]]]]
		if {![catch {set keyname [dict get $macrodict $icmd]}]} {
 		    set canonname [string map \
				{Control_ ^ XK_ {} less < more > comma , question ?}\
				$keyname]
		    $menuw entryconfigure $i -accelerator "(${canonname})"
		} else {
		    $menuw entryconfigure $i -accelerator ""
		}
	    }
	}
    }
}

#---------------------------------------------------------------------
# Text auto-increment and auto-decrement
#---------------------------------------------------------------------

proc magic::autoincr {{amount 1}} {
   set mtext [macro list .]
   set num [regexp -inline {[+-]*[[:digit:]]+} $mtext]
   if {$num != ""} {
      incr num $amount
      regsub {[+-]*[[:digit:]]+} $mtext $num mtext
      eval $mtext
      macro . "$mtext"
   }
}

magic::macro XK_plus {magic::autoincr 1}
magic::macro XK_minus {magic::autoincr -1}

#---------------------------------------------------------------------
# The following several routines are designed to aid in generating
# documentation for technology files, or to generate design rule
# documents using magic layout windows in a Tk tabbed-window
# framework.
#---------------------------------------------------------------------

#---------------------------------------------------------------------
# Ruler generation using the "element" command
# A line with arrows is drawn showing the dimension of the cursor box.
# The text of "text", if non-NULL, is placed in the middle of the
# ruler area.  The orientation of "orient" describes whether the
# ruler is a vertical or horizontal measurement.  By default, the
# longest dimension of the box is the orientation.
#---------------------------------------------------------------------

proc magic::ruler {{text {}} {orient auto}} {
   global Opts

   if {[catch {set Opts(rulers)}]} {
      set Opts(rulers) 0
   } else {
      incr Opts(rulers)
   }

   set bv [box values]
   set llx [lindex $bv 0]
   set lly [lindex $bv 1]
   set urx [lindex $bv 2]
   set ury [lindex $bv 3]

   set width [expr {[lindex $bv 2] - [lindex $bv 0]}]
   set height [expr {[lindex $bv 3] - [lindex $bv 1]}]
   if {$orient == "auto"} {
      if {$width > $height} {
	 set orient "horizontal"
      } else {
	 set orient "vertical"
      }
   }

   if {[llength $text] > 0} {
      if {$orient == "horizontal"} {
         set tclr 4
      } else {
         set tclr 2
      }
   } else {
      set tclr 0
   }

   set mmx [expr {($llx + $urx) / 2}]
   set mmy [expr {($lly + $ury) / 2}]

   if {$orient == "horizontal"} {
      element add line l1_$Opts(rulers) black $llx $lly $llx $ury
      element add line l4_$Opts(rulers) black $urx $lly $urx $ury

      set mmx1 [expr {$mmx - $tclr}]
      set mmx2 [expr {$mmx + $tclr}]
      if {$mmx1 == $llx} {set mmx1 [expr {$llx - 2}]}
      if {$mmx2 == $urx} {set mmx2 [expr {$urx + 2}]}

      element add line l2_$Opts(rulers) black $llx $mmy $mmx1 $mmy
      element add line l3_$Opts(rulers) black $mmx2 $mmy $urx $mmy

      if {$tclr > 0} {
         element add text t_$Opts(rulers) black $mmx $mmy $text
      }
      if {$llx < $mmx1} {
	  element configure l2_$Opts(rulers) flags arrowleft
      } else {
	  element configure l2_$Opts(rulers) flags arrowright
      }
      if {$urx > $mmx2} {
	  element configure l3_$Opts(rulers) flags arrowright
      } else {
	  element configure l3_$Opts(rulers) flags arrowleft
      }

   } else {
      element add line l1_$Opts(rulers) black $llx $lly $urx $lly
      element add line l4_$Opts(rulers) black $llx $ury $urx $ury

      set mmy1 [expr {$mmy - $tclr}]
      set mmy2 [expr {$mmy + $tclr}]
      if {$mmy1 == $lly} {set mmy1 [expr {$lly - 2}]}
      if {$mmy2 == $ury} {set mmy2 [expr {$ury + 2}]}

      element add line l2_$Opts(rulers) black $mmx $lly $mmx $mmy1
      element add line l3_$Opts(rulers) black $mmx $mmy2 $mmx $ury

      if {$tclr > 0} {
         element add text t_$Opts(rulers) black $mmx $mmy $text
      }
      if {$lly < $mmy1} {
	  element configure l2_$Opts(rulers) flags arrowbottom
      } else {
	  element configure l2_$Opts(rulers) flags arrowtop
      }
      if {$ury > $mmy2} {
	  element configure l3_$Opts(rulers) flags arrowtop
      } else {
	  element configure l3_$Opts(rulers) flags arrowbottom
      }
   }
}

#---------------------------------------------------------------------
# Automatic measurement ruler
#---------------------------------------------------------------------

proc magic::measure {{orient auto}} {

   set scale [cif scale out]

   set bv [box values]
   set llx [lindex $bv 0]
   set lly [lindex $bv 1]
   set urx [lindex $bv 2]
   set ury [lindex $bv 3]

   set width [expr {[lindex $bv 2] - [lindex $bv 0]}]
   set height [expr {[lindex $bv 3] - [lindex $bv 1]}]
   if {$orient == "auto"} {
      if {$width > $height} {
	 set orient "horizontal"
      } else {
	 set orient "vertical"
      }
   }

   if {$orient == "horizontal"} {
      set tval [expr {$scale * $width}]
   } else {
      set tval [expr {$scale * $height}]
   }
   set text [format "%g um" $tval]
   ruler $text $orient
}

#---------------------------------------------------------------------
# Remove all rulers (this should probably be refined to remove
# just the rulers under the box).
#---------------------------------------------------------------------

proc magic::unmeasure {} {
   set blist [element inbox]
   set mlist {}
   foreach m $blist {
      switch -regexp $m {
	 l[1-4]_[0-9] {
	    lappend mlist [string range $m 3 end]
	 }
	 t_[0-9] {
	    lappend mlist [string range $m 2 end]
         }
      }
   }
   set blist [lsort -unique $mlist]
   foreach m $blist {
      element delete t_$m
      element delete l1_$m
      element delete l2_$m
      element delete l3_$m
      element delete l4_$m
   }
}

#---------------------------------------------------------------------
# Key generation for annotating layouts.
#---------------------------------------------------------------------

proc magic::genkey {layer {keysize 4}} {
   global Opts

   box size $keysize $keysize
   paint $layer
   if {[catch {set Opts(keys)}]} {
      set Opts(keys) 0
   } else {
      incr Opts(keys)
   }
   # eval "element add rectangle keyrect$Opts(keys) subcircuit [box values]"

   box move e $keysize
   set bv [box values]
   set cx [expr {([lindex $bv 2] + [lindex $bv 0]) / 2}]
   set cy [expr {([lindex $bv 3] + [lindex $bv 1]) / 2}]
   element add text key$Opts(keys) white $cx $cy $layer
   element configure key$Opts(keys) flags east
}

#---------------------------------------------------------------------
# Because this file is read prior to setting the magic command
# names in Tcl, we cannot run the magic commands here.  Create
# a procedure to enable the commands, then run that procedure
# from the system .magic script.
#---------------------------------------------------------------------

proc magic::enable_tools {} {
   global Opts

   # Set keystrokes for push and pop
   magic::macro XK_greater {magic::pushstack [cellname list self]}
   magic::macro XK_less {magic::popstack}
 
   # Set keystrokes for the "tool" command.
   magic::macro space		{magic::tool}
   magic::macro Shift_space	{magic::tool box}

   set Opts(tool) box
   set Opts(motion) {}
   set Opts(origin) {0 0}
   set Opts(backupinterval) 60000
   magic::crashbackups start
}

#---------------------------------------------------------------------
# routine which tracks wire generation
#---------------------------------------------------------------------

proc magic::trackwire {window {option {}}} {
   global Opts

   if {$Opts(motion) == {}} {
      if {$option == "done"} {
	 wire switch
      } elseif {$option == "pick"} {
	 puts stdout $window
	 wire type
	 set Opts(motion) [bind ${window} <Motion>]
	 bind ${window} <Motion> [subst {$Opts(motion); *bypass wire show}]
	 if {$Opts(motion) == {}} {set Opts(motion) "null"}
	 cursor 21
      }
   } else {
      if {$option != "cancel"} {
         wire leg
      }
      if {$option == "done" || $option == "cancel"} {
	 select clear
	 if {$Opts(motion) == "null"} {
            bind ${window} <Motion> {}
	 } else {
            bind ${window} <Motion> "$Opts(motion)"
	 }
         set Opts(motion) {}
         cursor 19
      }
   }
}

#---------------------------------------------------------------------
# routine which tracks a selection pick
#---------------------------------------------------------------------

proc magic::keepselect {window} {
   global Opts
   if {$Opts(motion) == {}} {
      box move bl cursor
   } else {
      select keep
   }
}

proc magic::startselect {window {option {}}} {
   global Opts
   if {$Opts(motion) == {}} {
      if {$option == "pick"} {
         select pick
      } else {
	 set slist [what -list]
	 if {$slist == {{} {} {}}} {
	    select nocycle
	 }
      }
      set Opts(origin) [cursor]
      set Opts(motion) [bind ${window} <Motion>]
      bind ${window} <Motion> [subst {$Opts(motion); set p \[cursor\]; \
	set x \[expr {\[lindex \$p 0\] - [lindex $Opts(origin) 0]}\]i; \
	set y \[expr {\[lindex \$p 1\] - [lindex $Opts(origin) 1]}\]i; \
	*bypass select move \${x} \${y}}]
      if {$Opts(motion) == {}} {set Opts(motion) "null"}
      cursor 21
   } else {
      if {$Opts(motion) == "null"} {
         bind ${window} <Motion> {}
      } else {
         bind ${window} <Motion> "$Opts(motion)"
      }
      copy center 0
      set Opts(motion) {}
      cursor 22
   }
}

proc magic::cancelselect {window} {
   global Opts
   if {$Opts(motion) == {}} {
      box corner ur cursor
   } else {
      if {$Opts(motion) == "null"} {
         bind ${window} <Motion> {}
      } else {
         bind ${window} <Motion> "$Opts(motion)"
      }
      select clear
      set Opts(motion) {}
      cursor 22
   }
}

#---------------------------------------------------------------------
# tool --- A scripted replacement for the "tool"
# command, as handling of button events has been modified
# to act like the handling of key events, so the "tool"
# command just swaps macros for the buttons.
#
# Added By NP 10/27/2004
#---------------------------------------------------------------------

proc magic::tool {{type next}} {
   global Opts

   # Don't attempt to switch tools while a selection drag is active
   if {$Opts(motion) != {}} {
      return
   }

   if {$type == "next"} {
      switch $Opts(tool) {
	 box { set type wiring }
	 wiring { set type netlist }
	 netlist { set type pick }
	 pick { set type box }
      }
   }
   switch $type {
      info {
	 # print information about the current tool.
	 puts stdout "Current tool is $Opts(tool)."
	 puts stdout "Button command bindings:"
	 if {[llength [macro Button1]] > 0} {
	    macro Button1
	 }
	 if {[llength [macro Button2]] > 0} {
	    macro Button2
	 }
	 if {[llength [macro Button3]] > 0} {
	    macro Button3
	 }
	 if {[llength [macro Shift_Button1]] > 0} {
	    macro Shift_Button1
	 }
	 if {[llength [macro Shift_Button2]] > 0} {
	    macro Shift_Button2
	 }
	 if {[llength [macro Shift_Button3]] > 0} {
	    macro Shift_Button3
	 }
	 if {[llength [macro Control_Button1]] > 0} {
	    macro Control_Button1
	 }
	 if {[llength [macro Control_Button2]] > 0} {
	    macro Control_Button2
	 }
	 if {[llength [macro Control_Button3]] > 0} {
	    macro Control_Button3
	 }
      }
      box {
	 puts stdout {Switching to BOX tool.}
	 set Opts(tool) box
	 cursor 0	;# sets the cursor
	 macro  Button1          "box move bl cursor; magic::boxview %W %1"
	 macro  Shift_Button1    "box corner bl cursor; magic::boxview %W %1"
	 macro  Button2          "paint cursor"
	 macro  Shift_Button2    "erase cursor"
	 macro  Button3          "box corner ur cursor"
	 macro  Shift_Button3    "box move ur cursor; magic::boxview %W %1"
	 macro  Button4 "scroll u .05 w; magic::boxview %W %1"
	 macro  Button5 "scroll d .05 w; magic::boxview %W %1"
	 macro  Shift_XK_Pointer_Button4 "scroll r .05 w; magic::boxview %W %1"
	 macro  Shift_XK_Pointer_Button5 "scroll l .05 w; magic::boxview %W %1"

      }
      wiring {
	 puts stdout {Switching to WIRING tool.}
	 set Opts(tool) wiring
	 cursor 19 	;# sets the cursor
	 macro  Button1          "magic::trackwire %W pick"
	 macro  Button2          "magic::trackwire %W done"
	 macro  Button3          "magic::trackwire %W cancel"
         macro  Shift_Button1    "wire incr type ; wire show"
	 macro  Shift_Button2    "wire switch"
	 macro  Shift_Button3    "wire decr type ; wire show"
	 macro  Button4 "wire incr width ; wire show"
	 macro  Button5 "wire decr width ; wire show"
	
      }
      netlist {
	 puts stdout {Switching to NETLIST tool.}
	 set Opts(tool) netlist
	 cursor 18	;# sets the cursor
         macro  Button1          "netlist select"
	 macro  Button2          "netlist join"
	 macro  Button3          "netlist terminal"
         # Remove shift-button bindings
         macro  Shift_Button1    ""
	 macro  Shift_Button2    ""
	 macro  Shift_Button3    ""
	 macro  Button4 "scroll u .05 w"
	 macro  Button5 "scroll d .05 w"
      }
      pick {
	 puts stdout {Switching to PICK tool.}
	 set Opts(tool) pick
	 cursor 22	;# set the cursor
         macro  Button1          "magic::keepselect %W"
	 macro  Shift_Button2    "magic::startselect %W copy"
	 macro  Button2          "magic::startselect %W pick"
	 macro  Button3          "magic::cancelselect %W"
	 macro  Shift_Button1    "box corner bl cursor"
	 macro  Shift_Button3    "box move ur cursor"
	 macro  Button4 "scroll u .05 w"
	 macro  Button5 "scroll d .05 w"
      }
   }

   # Update window captions with the new tool info
   catch {magic::captions}
   return
}
