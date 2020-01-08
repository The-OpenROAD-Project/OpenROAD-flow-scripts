# Text helper window

set textdefaults [dict create \
	text "" \
	font "FreeSans" \
	size "1" \
	just "center" \
	rotate "0" \
	offset "0 0" \
	port "0" \
]
	
proc magic::make_texthelper { mgrpath } {
   global typedflt typesticky typeport
   toplevel ${mgrpath}
   wm withdraw ${mgrpath}

   frame ${mgrpath}.title
   frame ${mgrpath}.text
   frame ${mgrpath}.font
   frame ${mgrpath}.size
   frame ${mgrpath}.just
   frame ${mgrpath}.rotate
   frame ${mgrpath}.offset
   frame ${mgrpath}.layer
   frame ${mgrpath}.port

   frame ${mgrpath}.buttonbar

   label ${mgrpath}.title.tlab -text "New label: "

   label ${mgrpath}.text.tlab -text "Text string: "
   label ${mgrpath}.font.tlab -text "Font: "
   label ${mgrpath}.size.tlab -text "Size (um): "
   label ${mgrpath}.just.tlab -text "Justification: "
   label ${mgrpath}.rotate.tlab -text "Rotation: "
   label ${mgrpath}.offset.tlab -text "Offset from reference: "
   label ${mgrpath}.layer.tlab -text "Attach to layer: "
   label ${mgrpath}.port.tlab -text "Port: "

   entry ${mgrpath}.text.tent -background white
   entry ${mgrpath}.size.tent -background white
   entry ${mgrpath}.rotate.tent -background white
   entry ${mgrpath}.offset.tent -background white
   entry ${mgrpath}.layer.tent -background white
   entry ${mgrpath}.port.tent -background white

   set typedflt 1
   set typesticky 0
   set typeport 0
   checkbutton ${mgrpath}.layer.btn1 -text "default" -variable typedflt \
	-command [subst {if {\$typedflt} {pack forget ${mgrpath}.layer.tent \
		} else {pack forget ${mgrpath}.layer.btn2; \
		pack ${mgrpath}.layer.tent -side left -fill x -expand true; \
		pack ${mgrpath}.layer.btn2 -side left}}]
   checkbutton ${mgrpath}.layer.btn2 -text "sticky" -variable typesticky
   checkbutton ${mgrpath}.port.btn -text "enable" -variable typeport \
	-command [subst {if {\$typeport} {
		${mgrpath}.port.tent delete 0 end; \
		${mgrpath}.port.tent insert 0 \[expr {\[port last\] + 1}\]; \
		pack ${mgrpath}.port.tent \
		-side left -fill x -expand true } else { pack forget \
		${mgrpath}.port.tent }}]

   menubutton ${mgrpath}.just.btn -text "default" -menu ${mgrpath}.just.btn.menu
   menubutton ${mgrpath}.font.btn -text "default" -menu ${mgrpath}.font.btn.menu
   
   button ${mgrpath}.buttonbar.cancel -text "Cancel" -command "wm withdraw ${mgrpath}"
   button ${mgrpath}.buttonbar.apply -text "Apply"
   button ${mgrpath}.buttonbar.okay -text "Okay"

   pack ${mgrpath}.title.tlab
   pack ${mgrpath}.text.tlab -side left
   pack ${mgrpath}.text.tent -side right -fill x -expand true
   pack ${mgrpath}.font.tlab -side left
   pack ${mgrpath}.font.btn -side left
   pack ${mgrpath}.size.tlab -side left
   pack ${mgrpath}.size.tent -side right -fill x -expand true
   pack ${mgrpath}.just.tlab -side left
   pack ${mgrpath}.just.btn -side left
   pack ${mgrpath}.rotate.tlab -side left
   pack ${mgrpath}.rotate.tent -side right -fill x -expand true
   pack ${mgrpath}.offset.tlab -side left
   pack ${mgrpath}.offset.tent -side right -fill x -expand true
   pack ${mgrpath}.layer.tlab -side left
   pack ${mgrpath}.layer.btn1 -side left
   pack ${mgrpath}.layer.btn2 -side left
   pack ${mgrpath}.port.tlab -side left
   pack ${mgrpath}.port.btn -side left

   pack ${mgrpath}.buttonbar.apply -side left
   pack ${mgrpath}.buttonbar.okay -side left
   pack ${mgrpath}.buttonbar.cancel -side right

   pack ${mgrpath}.title -side top
   pack ${mgrpath}.text -side top -anchor w -expand true
   pack ${mgrpath}.font -side top -anchor w
   pack ${mgrpath}.size -side top -anchor w -expand true
   pack ${mgrpath}.just -side top -anchor w
   pack ${mgrpath}.rotate -side top -anchor w -expand true
   pack ${mgrpath}.offset -side top -anchor w -expand true
   pack ${mgrpath}.layer -side top -anchor w -expand true
   pack ${mgrpath}.port -side top -anchor w -expand true
   pack ${mgrpath}.buttonbar -side bottom -fill x -expand true

   # Create menus for Font and Justification records

   menu ${mgrpath}.just.btn.menu -tearoff 0
   menu ${mgrpath}.font.btn.menu -tearoff 0

   ${mgrpath}.just.btn.menu add command -label "default" -command \
		"${mgrpath}.just.btn config -text default"
   ${mgrpath}.just.btn.menu add command -label "N" -command \
		"${mgrpath}.just.btn config -text N"
   ${mgrpath}.just.btn.menu add command -label "NE" -command \
		"${mgrpath}.just.btn config -text NE"
   ${mgrpath}.just.btn.menu add command -label "E" -command \
		"${mgrpath}.just.btn config -text E"
   ${mgrpath}.just.btn.menu add command -label "SE" -command \
		"${mgrpath}.just.btn config -text SE"
   ${mgrpath}.just.btn.menu add command -label "S" -command \
		"${mgrpath}.just.btn config -text S"
   ${mgrpath}.just.btn.menu add command -label "SW" -command \
		"${mgrpath}.just.btn config -text SW"
   ${mgrpath}.just.btn.menu add command -label "W" -command \
		"${mgrpath}.just.btn config -text W"
   ${mgrpath}.just.btn.menu add command -label "NW" -command \
		"${mgrpath}.just.btn config -text NW"
   ${mgrpath}.just.btn.menu add command -label "center" -command \
		"${mgrpath}.just.btn config -text center"

   set flist [magic::setlabel fontlist]
   ${mgrpath}.font.btn.menu add command -label default -command \
		"${mgrpath}.font.btn config -text default"
   foreach i $flist {
      ${mgrpath}.font.btn.menu add command -label $i -command \
		"${mgrpath}.font.btn config -text $i"
   }

   # Set up tag callbacks

   magic::tag select "[magic::tag select]; magic::update_texthelper"
}

# For all editable selected labels, fill in entries in the
# texthelper window

proc magic::analyze_labels {} {
   global typedflt typesticky typeport

   # Pick up values from the first entry returned

   set tval [lindex [setlabel text] 0]
   set jval [lindex [setlabel justify] 0]
   set fval [lindex [setlabel font] 0]
   set rval [lindex [setlabel rotate] 0]
   set oval [lindex [setlabel offset] 0]
   set lval [lindex [setlabel layer] 0]
   set kval [lindex [setlabel sticky] 0]
   set isport [lindex [port exists] 0]
   if {$isport} {
       set pval [lindex [port index] 0]
   } else {
       set pval -1
   }

   # Rescale internal units to microns
   set sval [lindex [setlabel size] 0]
   set sscale [cif scale out]
   set tmp_pre $::tcl_precision
   set ::tcl_precision 3
   set sval [expr $sscale * $sval]
   set ::tcl_precision $tmp_pre

   .texthelper.text.tent delete 0 end
   .texthelper.text.tent insert 0 $tval
   set jbtn [string map {NORTH N WEST W SOUTH S EAST E CENTER center} $jval]
   .texthelper.just.btn.menu invoke $jbtn
   .texthelper.font.btn.menu invoke $fval
   .texthelper.size.tent delete 0 end
   .texthelper.size.tent insert 0 $sval
   .texthelper.offset.tent delete 0 end
   .texthelper.offset.tent insert 0 [join $oval]
   .texthelper.rotate.tent delete 0 end
   .texthelper.rotate.tent insert 0 $rval
   .texthelper.layer.tent delete 0 end
   .texthelper.layer.tent insert 0 $lval
   if {${pval} >= 0} {
      set typeport 1
      .texthelper.port.tent delete 0 end
      .texthelper.port.tent insert 0 $pval
      pack .texthelper.port.tent -side left -fill x -expand true
   } else {
      set typeport 0
      .texthelper.port.tent delete 0 end
      pack forget .texthelper.port.tent
   }

   set typesticky $kval
   if {$lval == ""} {
       set typedflt 1
       pack forget .texthelper.layer.tent
   } else {
       set typedflt 0
       pack forget .texthelper.layer.btn2
       pack .texthelper.layer.tent -side left -fill x -expand true
       pack .texthelper.layer.btn2 -side left
   }
}


proc magic::change_label {} {
   global typedflt typesticky typeport

   # Check to see if there really was a selection, or if
   # something got unselected

   if {[setlabel text] == ""} {
      magic::make_new_label
      return
   }

   set ltext [.texthelper.text.tent get]
   set lfont [.texthelper.font.btn cget -text]
   set lsize [.texthelper.size.tent get]
   set lrot  [.texthelper.rotate.tent get]
   set loff  [.texthelper.offset.tent get]
   set ljust [.texthelper.just.btn cget -text]
   set ltype [.texthelper.layer.tent get]
   set lport [.texthelper.port.tent get]

   if {$ltext != ""} {
      setlabel text $ltext
   }
   if {$lfont != ""} {
      if {$lfont == "default"} {
         setlabel font -1
      } else {
         setlabel font $lfont
      }
   }
   if {$ljust != ""} {
      if {$ljust == "default"} {
         setlabel justify -1
      } else {
         setlabel justify $ljust
      }
   }
   if {$lsize != ""} {
      setlabel size ${lsize}um
   }
   if {$loff != ""} {
      set oldsnap [snap list]
      snap internal
      setlabel offset [join $loff]
      snap $oldsnap
   }
   if {$lrot != ""} {
      setlabel rotate $lrot
   }
   if {$ltype != ""} {
      setlabel layer $ltype
   }
   setlabel sticky $typesticky

   if {$typeport == 1 && $lport != ""} {
      if {[port exists] == 0} {
	 port make $lport
      } else {
	 port index $lport
      }
   } else {
      if {[port exists] == 1} {
         port remove
      }
   }
}

proc magic::make_new_label {} {
   global typedflt typesticky textdefaults typeport

   set ltext [.texthelper.text.tent get]
   set lfont [.texthelper.font.btn cget -text]
   set lsize [.texthelper.size.tent get]
   set lrot  [.texthelper.rotate.tent get]
   set loff  [.texthelper.offset.tent get]
   set ljust [.texthelper.just.btn cget -text]
   set ltype [.texthelper.layer.tent get]
   set lport [.texthelper.port.tent get]

   # Apply values back to window defaults
   dict set textdefaults text $ltext
   dict set textdefaults font $lfont
   dict set textdefaults size $lsize
   dict set textdefaults rotate $lrot
   dict set textdefaults offset $loff
   dict set textdefaults just $ljust

   if {$ltext == ""} return	;# don't generate null label strings!

   if {$lfont == {} || $lfont == "default"} {
      label $ltext $ljust
      return
   }

   if {$lsize == "0" || $lsize == ""} {set lsize 1}
   if {$lrot == ""} {set lrot 0}
   if {$loff == ""} {set loff "0 0"}

   if {$typedflt == 1 || $ltype == ""} {
      if {$ljust == "default"} {
         label $ltext $lfont ${lsize}um $lrot [join $loff]
      } else {
         label $ltext $lfont ${lsize}um $lrot [join $loff] $ljust
      }
   } else {
      if {$typesticky == 1} {set ltype "-$ltype"}
      if {$ljust == "default"} {
         label $ltext $lfont ${lsize}um $lrot [join $loff] center $ltype
      } else {
         label $ltext $lfont ${lsize}um $lrot [join $loff] $ljust $ltype
      }
   }
   if {$typeport == 1 && $lport != ""} {
      port make $lport
      # Auto-increment the value to the next available port.
      set pval [port last]
      incr pval
      .texthelper.port.tent delete 0 end
      .texthelper.port.tent insert 0 $pval
   } else {
      port remove
   }

   # puts stdout "label $ltext $lfont $lsize $lrot $loff $ljust"
}

#--------------------------------------------------------------------
# Update and redisplay the text helper
#--------------------------------------------------------------------

proc magic::update_texthelper {} {
   global CAD_ROOT
   global textdefaults

   if {[info level] > 1} {
      return
   }
   if {[catch {set tstate [wm state .texthelper]}]} {
      magic::make_texthelper .texthelper
   } else {
      if {$tstate == "withdrawn"} {return}
   }

   # Update:  Determine if a label has been selected or not.  If so,
   # analyze the label list to determine which properties are common
   # to all the selected labels

   set splist [lindex [what -list] 1]

   # Reduce list to what's editable
   set slist []
   foreach sitem $splist {
      set scell [lindex $sitem 2] 
      if {$scell == {}} {
         lappend slist $sitem
      }
   }

   if {$slist == {}} {
      .texthelper.title.tlab configure -text "New label: "
      .texthelper.text.tent delete 0 end
      .texthelper.text.tent insert 0 [dict get $textdefaults text]

      set deffont [dict get $textdefaults font]
      set found 0
      for {set i 0} {$i <= [.texthelper.font.btn.menu index end]} {incr i} {
	 set btnname [.texthelper.font.btn.menu entrycget $i -label]
         if {$btnname == $deffont} {.texthelper.font.btn.menu invoke $i}
         set found 1
      }
      if {$found == 0} {.texthelper.font.btn.menu invoke 0}

      set defjust [dict get $textdefaults just]
      set found 0
      for {set i 0} {$i <= [.texthelper.just.btn.menu index end]} {incr i} {
	 set btnname [.texthelper.just.btn.menu entrycget $i -label]
         if {$btnname == $defjust} {.texthelper.just.btn.menu invoke $i}
         set found 1
      }
      if {$found == 0} {.texthelper.just.btn.menu invoke 0}

      .texthelper.size.tent delete 0 end
      .texthelper.size.tent insert 0 [dict get $textdefaults size]
      .texthelper.rotate.tent delete 0 end
      .texthelper.rotate.tent insert 0 [dict get $textdefaults rotate]
      .texthelper.offset.tent delete 0 end
      .texthelper.offset.tent insert 0 [dict get $textdefaults offset]
      set pval [port last]
      incr pval
      .texthelper.port.tent delete 0 end
      .texthelper.port.tent insert 0 $pval
      .texthelper.buttonbar.apply configure -command magic::make_new_label
      .texthelper.buttonbar.okay configure -command \
		"magic::make_new_label ; wm withdraw .texthelper"
   } else {
      if {[llength $slist] == 1} {
         .texthelper.title.tlab configure -text "Selected label: "
      } else {
         .texthelper.title.tlab configure -text "Selected labels: "
      }
      magic::analyze_labels
      .texthelper.buttonbar.apply configure -command magic::change_label
      .texthelper.buttonbar.okay configure -command \
		"magic::change_label ; wm withdraw .texthelper"
   }
}

