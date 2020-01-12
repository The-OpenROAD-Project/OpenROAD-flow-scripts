#-----------------------------------------------------
# Magic/TCL general-purpose toolkit procedures
#-----------------------------------------------------
# Tim Edwards
# February 11, 2007
# Revision 0
#--------------------------------------------------------------
# Sets up the environment for a toolkit.  The toolkit must
# supply a namespace that is the "library name".  For each
# parameter-defined device ("gencell") type, the toolkit must
# supply three procedures:
#
# 1. ${library}::${gencell_type}_params {gname} {...}
# 2. ${library}::${gencell_type}_check  {gname} {...}
# 3. ${library}::${gencell_type}_draw   {gname} {...}
#
# The first defines the parameters used by the gencell, and
# declares default parameters to use when first generating
# the window that prompts for the device parameters prior to
# creating the device.  The second checks the parameters for
# legal values.  The third draws the device.
#--------------------------------------------------------------

# Initialize toolkit menus to the wrapper window

global Opts

#----------------------------------------------------------------
# Add a menu button to the Magic wrapper window for the toolkit
#----------------------------------------------------------------

proc magic::add_toolkit_menu {framename button_text} {
   menubutton ${framename}.titlebar.mbuttons.toolkit \
		-text $button_text \
		-relief raised \
		-menu ${framename}.titlebar.mbuttons.toolkit.toolmenu \
		-borderwidth 2

   menu ${framename}.titlebar.mbuttons.toolkit.toolmenu -tearoff 0
   pack ${framename}.titlebar.mbuttons.toolkit -side left
}

#----------------------------------------------------------------
# Add a menu item to the toolkit menu
#----------------------------------------------------------------

proc magic::add_toolkit_button {framename button_text gencell_type library} {
   set m ${framename}.titlebar.mbuttons.toolkit.toolmenu
   $m add command -label "$button_text" -command \
	"magic::gencell_params {} $gencell_type $library"
}

#-----------------------------------------------------
# Device selection
#-----------------------------------------------------

proc magic::gen_params {} {
    
    # Find selected item  (to-do:  handle multiple selections)
    set wlist [what -list]
    set clist [lindex $wlist 2]
    set ccell [lindex $clist 0]
    set cdef [lindex $ccell 1]
    if {[regexp {^(.*_[0-9]*)$} $cdef valid gname] != 0} {
       set library [cellname property $gname library]
       if {$library == {}} {
	  error "Gencell has no associated library!"
       } else {
          regexp {^(.*)_[0-9]*$} $cdef valid gencell_type
	  magic::gencell_params $gname $gencell_type $library
       }
    } else {
       # Error message
       error "No gencell device is selected!"
    }
}

#-----------------------------------------------------
# Add "Ctrl-P" key callback for device selection
#-----------------------------------------------------

magic::macro ^P magic::gen_params

#-------------------------------------------------------------
# gencell_setparams
#
#   Go through the parameter window and collect all of the
#   named parameters and their values, and generate the
#   associated properties in celldef "$gname".
#-------------------------------------------------------------

proc magic::gencell_setparams {gname} {
   set slist [grid slaves .params.edits]
   foreach s $slist {
      if {[regexp {^.params.edits.(.*)_ent$} $s valid pname] != 0} {
	 set value [$s get]
	 cellname property $gname $pname $value
      }
   }
}

#-------------------------------------------------------------
# gencell_getparam
#
#   Go through the parameter window, find the named parameter,
#   and return its value.
#-------------------------------------------------------------

proc magic::gencell_getparam {gname pname} {
   set slist [grid slaves .params.edits]
   foreach s $slist {
      if {[regexp {^.params.edits.(.*)_ent$} $s valid ptest] != 0} {
	 if {$pname == $ptest} {
	    return [$s get]
	 }
      }
   }
}

#-------------------------------------------------------------
# gencell_change
#
#   Redraw a gencell with new parameters.
#-------------------------------------------------------------

proc magic::gencell_change {gname gencell_type library} {
    if {[cellname list exists $gname] != 0} {
	if {[eval "${library}::${gencell_type}_check $gname"]} {
	    suspendall
	    pushstack $gname
	    select cell
	    erase *
	    magic::gencell_draw $gname $gencell_type $library
	    popstack
	    resumeall
	} else {
	    error "Parameter out of range!"
	}
    } else {
	error "Cell $gname does not exist!"
    }
}

#-------------------------------------------------------------
# gencell_create
#
#   Instantiate a new gencell called $gname.  If $gname
#   does not already exist, create it by calling its
#   drawing routine.
#
#   Don't rely on pushbox/popbox since we don't know what
#   the drawing routine is going to do to the stack!
#-------------------------------------------------------------

proc magic::gencell_create {gname gencell_type library} {
    suspendall
    if {[cellname list exists $gname] == 0} {
	cellname create $gname
	set snaptype [snap list]
	snap internal
	set savebox [box values]
	pushstack $gname
	magic::gencell_draw $gname $gencell_type $library
	popstack
	eval "box values $savebox"
	snap $snaptype
    }
    getcell $gname
    expand
    resumeall
}

#-------------------------------------------------------------
#-------------------------------------------------------------

proc magic::gencell_check {gname gencell_type library} {
    return [eval "${library}::${gencell_type}_check $gname"]
}

#-------------------------------------------------------------
#-------------------------------------------------------------

proc magic::gencell_draw {gname gencell_type library} {

   # Set the parameters passed from the window text entries
   magic::gencell_setparams $gname

   # Call the draw routine
   eval "${library}::${gencell_type}_draw $gname"

   # Find the namespace of the draw procedure and set propery "library"
   cellname property $gname library $library
}

#-----------------------------------------------------
#  Add a standard parameter to the gencell window 
#-----------------------------------------------------

proc magic::add_param {gname pname ptext default_value} {

   # Check if the parameter exists.  If so, override the default
   # value with the current value.

   set value {}
   if {[cellname list exists $gname] != 0} {
      set value [cellname property $gname $pname]
   }
   if {$value == {}} {set value $default_value}
   
   set numrows [lindex [grid size .params.edits] 0]
   label .params.edits.${pname}_lab -text $ptext
   entry .params.edits.${pname}_ent -background white
   grid .params.edits.${pname}_lab -row $numrows -column 0
   grid .params.edits.${pname}_ent -row $numrows -column 1
   .params.edits.${pname}_ent insert end $value
}

#-----------------------------------------------------
# Update the properties of a cell 
#-----------------------------------------------------

proc magic::update_params {gname ptext default_value} {
}

#-------------------------------------------------------------
# gencell_params ---
# 1) If gname is NULL and gencell_type is set, then we
#    create a new cell of type gencell_type.
# 2) If gname is non-NULL, then we edit the existing
#    cell of type $gname.
# 3) If gname is non-NULL and gencell_type or library
#    is NULL or unspecified, then we derive the gencell_type
#    and library from the existing cell's property strings
#-------------------------------------------------------------

proc magic::gencell_params {gname {gencell_type {}} {library {}}} {

   if {$gname == {}} {
      set pidx 1
      while {[cellname list exists ${gencell_type}_$pidx] != 0} {
	  incr pidx
      }
      set gname ${gencell_type}_$pidx

      set ttext "New device"
      set btext "Create"
      set bcmd "magic::gencell_create $gname $gencell_type $library"
   } else {
      if {$gencell_type == {}} {
	 set gencell_type [cellname property ${gname} gencell]
      }
      if {$library == {}} {
	 set library [cellname property ${gname} library]
      }

      set ttext "Edit device"
      set btext "Apply"
      set bcmd "magic::gencell_change $gname $gencell_type $library"
   }

   catch {destroy .params}
   toplevel .params
   label .params.title -text "$ttext $gname"
   frame .params.edits
   frame .params.buttons
   pack .params.title
   pack .params.edits
   pack .params.buttons

   button .params.buttons.apply \
	-text "$btext" \
	-command [subst { $bcmd ; \
	.params.buttons.apply configure -text Apply}]
   button .params.buttons.close -text "Close" -command {destroy .params}

   pack .params.buttons.apply -padx 10 -side left
   pack .params.buttons.close -padx 10 -side right

   # Invoke the callback procedure that creates the parameter entries

   eval "${library}::${gencell_type}_params $gname"
}

#-------------------------------------------------------------
