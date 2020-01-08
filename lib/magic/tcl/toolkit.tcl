#-----------------------------------------------------
# Magic/TCL general-purpose toolkit procedures
#-----------------------------------------------------
# Tim Edwards
# February 11, 2007
# Revision 0
# December 15, 2016
# Revision 1
#--------------------------------------------------------------
# Sets up the environment for a toolkit.  The toolkit must
# supply a namespace that is the "library name".  For each
# parameter-defined device ("gencell") type, the toolkit must
# supply five procedures:
#
# 1. ${library}::${gencell_type}_defaults {}
# 2. ${library}::${gencell_type}_convert  {parameters}
# 3. ${library}::${gencell_type}_dialog   {parameters}
# 4. ${library}::${gencell_type}_check    {parameters}
# 5. ${library}::${gencell_type}_draw     {parameters}
#
# The first defines the parameters used by the gencell, and
# declares default parameters to use when first generating
# the window that prompts for the device parameters prior to
# creating the device.  The second converts between parameters
# in a SPICE netlist and parameters used by the dialog,
# performing units conversion and parameter name conversion as
# needed.  The third builds the dialog window for entering
# device parameters.  The fourth checks the parameters for
# legal values.  The fifth draws the device.
#
# If "library" is not specified then it defaults to "toolkit".
# Otherwise, where specified, the name "gencell_fullname"
# is equivalent to "${library}::${gencell_type}"
#
# Each gencell is defined by cell properties as created by
# the "cellname property" command.  Specific properties used
# by the toolkit are:
#
# library    --- name of library (see above, default "toolkit")
# gencell    --- base name of gencell (gencell_type, above)
# parameters --- list of gencell parameter-value pairs
#--------------------------------------------------------------

# Initialize toolkit menus to the wrapper window

global Opts

#----------------------------------------------------------------
# Add a menu button to the Magic wrapper window for the toolkit
#----------------------------------------------------------------

proc magic::add_toolkit_menu {framename button_text {library toolkit}} {
   menubutton ${framename}.titlebar.mbuttons.${library} \
		-text $button_text \
		-relief raised \
		-menu ${framename}.titlebar.mbuttons.${library}.toolmenu \
		-borderwidth 2

   menu ${framename}.titlebar.mbuttons.${library}.toolmenu -tearoff 0
   pack ${framename}.titlebar.mbuttons.${library} -side left
}

#-----------------------------------------------------------------
# Add a menu item to the toolkit menu calling the default function
#-----------------------------------------------------------------

proc magic::add_toolkit_button {framename button_text gencell_type \
		{library toolkit} args} {
   set m ${framename}.titlebar.mbuttons.${library}.toolmenu
   $m add command -label "$button_text" -command \
	"magic::gencell $library::$gencell_type {} $args"
}

#----------------------------------------------------------------
# Add a menu item to the toolkit menu that calls the provided
# function
#----------------------------------------------------------------

proc magic::add_toolkit_command {framename button_text \
		command {library toolkit} args} {
   set m ${framename}.titlebar.mbuttons.${library}.toolmenu
   $m add command -label "$button_text" -command "$command $args"
}

#----------------------------------------------------------------
# Add a separator to the toolkit menu
#----------------------------------------------------------------

proc magic::add_toolkit_separator {framename {library toolkit}} {
   set m ${framename}.titlebar.mbuttons.${library}.toolmenu
   $m add separator
}

#-----------------------------------------------------
# Add "Ctrl-P" key callback for device selection
#-----------------------------------------------------

magic::macro ^P "magic::gencell {} ; raise .params"

#-------------------------------------------------------------
# Add tag callback to select to update the gencell window
#-------------------------------------------------------------

magic::tag select "[magic::tag select]; magic::gencell_update %1"

#-------------------------------------------------------------
# gencell
#
#   Main routine to call a cell from either a menu button or
#   from a script or command line.  The name of the device
#   is required, followed by the name of the instance, followed
#   by an optional list of parameters.  Handling depends on
#   instname and args:
#
#   gencell_name is either the name of an instance or the name
#   of the gencell in the form <library>::<device>.
#
#   name        args      action
#-----------------------------------------------------------------
#   none        empty     interactive, new device w/defaults
#   none        specified interactive, new device w/parameters
#   instname    empty     interactive, edit device
#   instname    specified non-interactive, change device
#   device      empty     non-interactive, new device w/defaults
#   device	specified non-interactive, new device w/parameters
#
#-------------------------------------------------------------
# Also, if instname is empty and gencell_name is not specified,
# and if a device is selected in the layout, then gencell
# behaves like line 3 above (instname exists, args is empty).
# Note that macro Ctrl-P calls gencell this way.  If gencell_name
# is not specified and nothing is selected, then gencell{}
# does nothing.
#
# "args" must be a list of the cell parameters in key:value pairs,
# and an odd number is not legal;  the exception is that if the
# first argument is "-spice", then the list of parameters is
# expected to be in the format used in a SPICE netlist, and the
# parameter names and values will be treated accordingly.
#-------------------------------------------------------------

proc magic::gencell {gencell_name {instname {}} args} {

    # Pull "-spice" out of args, if it is the first argument
    if {[lindex $args 0] == "-spice"} {
	set spicemode 1
	set args [lrange $args 1 end]
    } else {
	set spicemode 0
    }
    set argpar [dict create {*}$args]

    if {$gencell_name == {}} { 
	# Find selected item  (to-do:  handle multiple selections)

	set wlist [what -list]
	set clist [lindex $wlist 2]
	set ccell [lindex $clist 0]
	set ginst [lindex $ccell 0]
	set gname [lindex $ccell 1]
	set library [cellname list property $gname library]
	if {$library == {}} {
	    set library toolkit
        }
	set gencell_type [cellname list property $gname gencell]
	if {$gencell_type == {}} {
	   if {![regexp {^(.*)_[0-9]*$} $gname valid gencell_type]} {
	      # Error message
	      error "No gencell device is selected!"
	   }
	}
        # need to incorporate argpar?
        set parameters [cellname list property $gname parameters]
	set parameters [magic::gencell_defaults $gencell_type $library $parameters]
	magic::gencell_dialog $ginst $gencell_type $library $parameters
    } else {
	# Parse out library name from gencell_name, otherwise default
	# library is assumed to be "toolkit".
	if {[regexp {^([^:]+)::([^:]+)$} $gencell_name valid library gencell_type] \
			== 0} {
	    set library "toolkit"
	    set gencell_type $gencell_name
	}

	if {$instname == {}} {
	    # Case:  Interactive, new device with parameters in args (if any)
	    if {$spicemode == 1} {
		# Legal not to have a *_convert routine
		if {[info commands ${library}::${gencell_type}_convert] != ""} {
		    set argpar [${library}::${gencell_type}_convert $argpar]
		}
	    }
	    set parameters [magic::gencell_defaults $gencell_type $library $argpar]
	    magic::gencell_dialog {} $gencell_type $library $parameters
	} else {
	    # Check if instance exists or not in the cell
	    set cellname [instance list celldef $instname]

	    if {$cellname != ""} {
		# Case:  Change existing instance, parameters in args (if any)
		select cell $instname
		set devparms [cellname list property $gencell_type parameters]
	        set parameters [magic::gencell_defaults $gencell_type $library $devparms]
		if {[dict exists $parameters nocell]} {
		    set arcount [array -list count]
		    set arpitch [array -list pitch]
	
		    dict set parameters nx [lindex $arcount 1]
		    dict set parameters ny [lindex $arcount 3]
		    dict set parameters pitchx $delx
		    dict set parameters pitchy $dely
		}
		if {[dict size $argpar] == 0} {
		    # No changes entered on the command line, so start dialog
		    magic::gencell_dialog $instname $gencell_type $library $parameters
		} else {
		    # Apply specified changes without invoking the dialog
		    if {$spicemode == 1} {
			set argpar [${library}::${gencell_type}_convert $argpar]
		    }
		    set parameters [dict merge $parameters $argpar]
		    magic::gencell_change $instname $gencell_type $library $parameters
		}
	    } else {
		# Case:  Non-interactive, create new device with parameters
		# in args (if any)
		if {$spicemode == 1} {
		    set argpar [${library}::${gencell_type}_convert $argpar]
		}
	        set parameters [magic::gencell_defaults $gencell_type $library $argpar]
		set inst_defaultname [magic::gencell_create \
				$gencell_type $library $parameters]
		select cell $inst_defaultname
		identify $instname
	    }
	}
    }
}

#-------------------------------------------------------------
# gencell_getparams
#
#   Go through the parameter window and collect all of the
#   named parameters and their values.  Return the result as
#   a dictionary.
#-------------------------------------------------------------

proc magic::gencell_getparams {} {
   set parameters [dict create]
   set slist [grid slaves .params.edits]
   foreach s $slist {
      if {[regexp {^.params.edits.(.*)_ent$} $s valid pname] != 0} {
	 set value [subst \$magic::${pname}_val]
      } elseif {[regexp {^.params.edits.(.*)_chk$} $s valid pname] != 0} {
	 set value [subst \$magic::${pname}_val]
      } elseif {[regexp {^.params.edits.(.*)_sel$} $s valid pname] != 0} {
	 set value [subst \$magic::${pname}_val]
      }
      dict set parameters $pname $value
   }
   return $parameters
}

#-------------------------------------------------------------
# gencell_setparams
#
#   Fill in values in the dialog from a set of parameters
#-------------------------------------------------------------

proc magic::gencell_setparams {parameters} {
   if {[catch {set state [wm state .params]}]} {return}
   set slist [grid slaves .params.edits]
   foreach s $slist {
      if {[regexp {^.params.edits.(.*)_ent$} $s valid pname] != 0} {
	 set value [dict get $parameters $pname]
         set magic::${pname}_val $value
      } elseif {[regexp {^.params.edits.(.*)_chk$} $s valid pname] != 0} {
	 set value [dict get $parameters $pname]
         set magic::${pname}_val $value
      } elseif {[regexp {^.params.edits.(.*)_sel$} $s valid pname] != 0} {
	 set value [dict get $parameters $pname]
         set magic::${pname}_val $value
      } elseif {[regexp {^.params.edits.(.*)_txt$} $s valid pname] != 0} {
	 if {[dict exists $parameters $pname]} {
	    set value [dict get $parameters $pname]
	    .params.edits.${pname}_txt configure -text $value
	 }
      }
   }
}

#-------------------------------------------------------------
# gencell_change
#
#   Redraw a gencell with new parameters.
#-------------------------------------------------------------

proc magic::gencell_change {instname gencell_type library parameters} {
    global Opts
    suspendall

    set newinstname $instname
    if {$parameters == {}} {
        # Get device defaults
	set pdefaults [${library}::${gencell_type}_defaults]
        # Pull user-entered values from dialog
        set parameters [dict merge $pdefaults [magic::gencell_getparams]]
	set newinstname [.params.title.ient get]
	if {$newinstname == "(default)"} {set newinstname $instname}
	if {$newinstname == $instname} {set newinstname $instname}
	if {[instance list exists $newinstname] != ""} {set newinstname $instname}
    }
    if {[catch {set parameters [${library}::${gencell_type}_check $parameters]} \
		checkerr]} {
	puts stderr $checkerr
    }
    magic::gencell_setparams $parameters

    set gname [instance list celldef $instname]

    # Guard against instance having been deleted
    if {$gname == ""} {
	resumeall
        return
    }

    set snaptype [snap list]
    snap internal
    set savebox [box values]

    catch {setpoint 0 0 $Opts(focus)}
    if [dict exists $parameters nocell] {
        select cell $instname
	delete
	if {[catch {set newinst [${library}::${gencell_type}_draw $parameters]} \
		drawerr]} {
	    puts stderr $drawerr
	}
        select cell $newinst
    } else {
	pushstack $gname
	select cell
	tech unlock *
	erase *
	if {[catch {${library}::${gencell_type}_draw $parameters} drawerr]} {
	    puts stderr $drawerr
	}
	property parameters $parameters
	tech revert
	popstack
        select cell $instname
    }
    identify $newinstname
    eval "box values $savebox"
    snap $snaptype
    resumeall
    redraw
}

#-------------------------------------------------------------
# Assign a unique name for a gencell
#
# Note:  This depends on the unlikelihood of the name
# existing in a cell on disk.  Only cells in memory are
# checked for name collisions.  Since the names will go
# into SPICE netlists, names must be unique when compared
# in a case-insensitive manner.  Using base-36 (alphabet and
# numbers), each gencell name with 6 randomized characters
# has a 1 in 4.6E-10 chance of reappearing.
#-------------------------------------------------------------

proc magic::get_gencell_name {gencell_type} {
    while {true} {
        set postfix ""
        for {set i 0} {$i < 6} {incr i} {
	    set pint [expr 48 + int(rand() * 36)]
	    if {$pint > 57} {set pint [expr $pint + 39]}
	    append postfix [format %c $pint]
	}   
	if {[cellname list exists ${gencell_type}_$postfix] == 0} {break}
    }
    return ${gencell_type}_$postfix
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

proc magic::gencell_create {gencell_type library parameters} {
    global Opts
    suspendall

    set newinstname ""

    # Get device defaults
    set pdefaults [${library}::${gencell_type}_defaults]
    if {$parameters == {}} {
        # Pull user-entered values from dialog
        set parameters [dict merge $pdefaults [magic::gencell_getparams]]
	set newinstname [.params.title.ient get]
	if {$newinstname == "(default)"} {set newinstname ""}
	if {[instance list exists $newinstname] != ""} {set newinstname ""}
    } else {
        set parameters [dict merge $pdefaults $parameters]
    }

    if {[catch {set parameters [${library}::${gencell_type}_check $parameters]} \
		checkerr]} {
	puts stderr $checkerr
    }
    magic::gencell_setparams $parameters

    set snaptype [snap list]
    snap internal
    set savebox [box values]

    catch {setpoint 0 0 $Opts(focus)}
    if [dict exists $parameters nocell] {
	if {[catch {set instname [${library}::${gencell_type}_draw $parameters]} \				drawerr]} {
	    puts stderr $drawerr
	}
	set gname [instance list celldef $instname]
	eval "box values $savebox"
    } else {
        set gname [magic::get_gencell_name ${gencell_type}]
	cellname create $gname
	pushstack $gname
	if {[catch {${library}::${gencell_type}_draw $parameters} drawerr]} {
	    puts stderr $drawerr
	}
	property library $library 
	property gencell $gencell_type
	property parameters $parameters
	popstack
	eval "box values $savebox"
	set instname [getcell $gname]
	expand
    }
    if {$newinstname != ""} {
	identify $newinstname
	set instname $newinstname
    }
    snap $snaptype
    resumeall
    redraw
    return $instname
}

#-----------------------------------------------------
#  Add a standard entry parameter to the gencell window 
#-----------------------------------------------------

proc magic::add_entry {pname ptext parameters} {

   if [dict exists $parameters $pname] {
        set value [dict get $parameters $pname]
   } else {
       set value ""
   }
   
   set numrows [lindex [grid size .params.edits] 1]
   label .params.edits.${pname}_lab -text $ptext
   entry .params.edits.${pname}_ent -background white -textvariable magic::${pname}_val
   grid .params.edits.${pname}_lab -row $numrows -column 0 \
	-sticky ens -ipadx 5 -ipady 2
   grid .params.edits.${pname}_ent -row $numrows -column 1 \
	-sticky ewns -ipadx 5 -ipady 2
   .params.edits.${pname}_ent insert end $value
   set magic::${pname}_val $value
}

#----------------------------------------------------------
# Default entry callback, without any dependencies.  Each 
# parameter changed 
#----------------------------------------------------------

proc magic::add_check_callbacks {gencell_type library} {
    set wlist [winfo children .params.edits]
    foreach w $wlist {
        if {[regexp {\.params\.edits\.(.+)_ent} $w valid pname]} {
	    # Add callback on enter or focus out
	    bind $w <Return> \
			"magic::update_dialog {} $pname $gencell_type $library"
	    bind $w <FocusOut> \
			"magic::update_dialog {} $pname $gencell_type $library"
	}
    }
}

#----------------------------------------------------------
# Add a dependency between entries.  When one updates, the
# others will be recomputed according to the callback
# function.
#
# The callback function is passed the value of all
# parameters for the device, overridden by the values
# in the dialog.  The routine computes the dependent
# values and writes them back to the parameter dictionary.
# The callback function must return the modified parameters
# dictionary.
#
# Also handle dependencies on checkboxes and selection lists
#----------------------------------------------------------

proc magic::add_dependency {callback gencell_type library args} {
    if {[llength $args] == 0} {
	# If no arguments are given, do for all parameters
	set parameters ${library}::${gencell_type}_defaults
	magic::add_dependency $callback $gencell_type $library \
			{*}[dict keys $parameters]
	return
    }
    set clist [winfo children .params.edits]
    foreach pname $args {
        if {[lsearch $clist .params.edits.${pname}_ent] >= 0} {
	    # Add callback on enter or focus out
	    bind .params.edits.${pname}_ent <Return> \
			"magic::update_dialog $callback $pname $gencell_type $library"
	    bind .params.edits.${pname}_ent <FocusOut> \
			"magic::update_dialog $callback $pname $gencell_type $library"
	} elseif {[lsearch $clist .params.edits.${pname}_chk] >= 0} {
	    # Add callback on checkbox change state
	    .params.edits.${pname}_chk configure -command \
			"magic::update_dialog $callback $pname $gencell_type $library"
	} elseif {[lsearch $clist .params.edits.${pname}_sel] >= 0} {
	    set smenu .params.edits.${pname}_sel.menu
	    set sitems [${smenu} index end]
	    for {set idx 0} {$idx <= $sitems} {incr idx} {
		set curcommand [${smenu} entrycget $idx -command]
		${smenu} entryconfigure $idx -command "$curcommand ; \
		magic::update_dialog $callback $pname $gencell_type $library"
	    }
	}
    }
}

#----------------------------------------------------------
# Execute callback procedure, then run bounds checks
#----------------------------------------------------------

proc magic::update_dialog {callback pname gencell_type library} {
    set pdefaults [${library}::${gencell_type}_defaults]
    set parameters [dict merge $pdefaults [magic::gencell_getparams]]
    if {$callback != {}} {
       set parameters [$callback $pname $parameters]
    }
    if {[catch {set parameters [${library}::${gencell_type}_check $parameters]} \
		checkerr]} {
	puts stderr $checkerr
    }
    magic::gencell_setparams $parameters
}

#----------------------------------------------------------
#  Add a standard checkbox parameter to the gencell window 
#----------------------------------------------------------

proc magic::add_checkbox {pname ptext parameters} {

   if [dict exists $parameters $pname] {
        set value [dict get $parameters $pname]
   } else {
       set value ""
   }
   
   set numrows [lindex [grid size .params.edits] 1]
   label .params.edits.${pname}_lab -text $ptext
   checkbutton .params.edits.${pname}_chk -variable magic::${pname}_val
   grid .params.edits.${pname}_lab -row $numrows -column 0 -sticky ens
   grid .params.edits.${pname}_chk -row $numrows -column 1 -sticky wns
   set magic::${pname}_val $value
}

#----------------------------------------------------------
# Add a message box (informational, not editable) to the
# gencell window.  Note that the text does not have to be
# in the parameter list, as it can be upated through the
# textvariable name.
#----------------------------------------------------------

proc magic::add_message {pname ptext parameters {color blue}} {

   if [dict exists $parameters $pname] {
      set value [dict get $parameters $pname]
   } else {
      set value ""
   }
   
   set numrows [lindex [grid size .params.edits] 1]
   label .params.edits.${pname}_lab -text $ptext
   label .params.edits.${pname}_txt -text $value \
		-foreground $color -textvariable magic::${pname}_val
   grid .params.edits.${pname}_lab -row $numrows -column 0 -sticky ens
   grid .params.edits.${pname}_txt -row $numrows -column 1 -sticky wns
}

#----------------------------------------------------------
#  Add a selectable-list parameter to the gencell window 
#----------------------------------------------------------

proc magic::add_selectlist {pname ptext all_values parameters} {

   if [dict exists $parameters $pname] {
        set value [dict get $parameters $pname]
   } else {
       set value ""
   }

   set numrows [lindex [grid size .params.edits] 1]
   label .params.edits.${pname}_lab -text $ptext
   menubutton .params.edits.${pname}_sel -menu .params.edits.${pname}_sel.menu \
		-relief groove -text ${value} 
   grid .params.edits.${pname}_lab -row $numrows -column 0 -sticky ens
   grid .params.edits.${pname}_sel -row $numrows -column 1 -sticky wns
   menu .params.edits.${pname}_sel.menu -tearoff 0
   foreach item ${all_values} {
       .params.edits.${pname}_sel.menu add radio -label $item \
	-variable magic::${pname}_val -value $item \
	-command ".params.edits.${pname}_sel configure -text $item"
   }
   set magic::${pname}_val $value
}

#-------------------------------------------------------------
# gencell_defaults ---
#
# Set all parameters for a device.  Start by calling the base
# device's default value list to generate a dictionary.  Then
# parse all values passed in 'parameters', overriding any
# defaults with the passed values.
#-------------------------------------------------------------

proc magic::gencell_defaults {gencell_type library parameters} {
    set basedict [${library}::${gencell_type}_defaults]
    set newdict [dict merge $basedict $parameters]
    return $newdict
}

#-------------------------------------------------------------
# Command tag callback on "select".  "select cell" should
# cause the parameter dialog window to update to reflect the
# selected cell.  If a cell is unselected, then revert to the
# default 'Create' window.
#-------------------------------------------------------------

proc magic::gencell_update {{command {}}} {
    if {[info level] <= 1} {
        if {![catch {set state [wm state .params]}]} {
	    if {[wm state .params] == "normal"} {
		if {$command == "cell"} {
		    # If multiple devices are selected, choose the first in
		    # the list returned by "what -list".
		    set instname [lindex [lindex [lindex [what -list] 2] 0] 0]
		    magic::gencell_dialog $instname {} {} {}
		}
	    }
	}
    }
}

#-------------------------------------------------------------
# gencell_dialog ---
#
# Create the dialog window for entering device parameters.  The
# general procedure then calls the dialog setup for the specific
# device.
#
# 1) If gname is NULL and gencell_type is set, then we
#    create a new cell of type gencell_type.
# 2) If gname is non-NULL, then we edit the existing
#    cell of type $gname.
# 3) If gname is non-NULL and gencell_type or library
#    is NULL or unspecified, then we derive the gencell_type
#    and library from the existing cell's property strings
#
# The device setup should be built using the API that defines
# these procedures:
#
# magic::add_entry	 Single text entry window
# magic::add_checkbox    Single checkbox
# magic::add_selectlist  Pull-down menu with list of selections
#
#-------------------------------------------------------------

proc magic::gencell_dialog {instname gencell_type library parameters} {
   if {$gencell_type == {}} {
       # Revert to default state for the device that was previously
       # shown in the parameter window.
       if {![catch {set state [wm state .params]}]} {
          if {$instname == {}} {
	     set devstr [.params.title.lab1 cget -text]
	     if {$devstr == "Edit device:"} {
		 set gencell_type [.params.title.lab2 cget -text]
		 set library [.params.title.lab4 cget -text]
	     } else {
	         return
	     }
	  }
       }
   }

   if {$instname != {}} {
      # Remove any array component of the instance name
      set instname [string map {\\ ""} $instname]
      if {[regexp {^(.*)\[[0-9,]+\]$} $instname valid instroot]} {
	 set instname $instroot
      }
      set gname [instance list celldef [subst $instname]]
      if {$gencell_type == {}} {
	 set gencell_type [cellname list property $gname gencell]
      }
      if {$library == {}} {
	 set library [cellname list property $gname library]
      }
      if {$parameters == {}} {
	 set parameters [cellname list property $gname parameters]
      }
      if {$gencell_type == {} || $library == {}} {return}

      if {$parameters == {}} {
	 set parameters [${library}::${gencell_type}_defaults]
      }

      # If the default parameters contain "nocell", then set the
      # standard parameters for fixed devices from the instance
      if {[dict exists $parameters nocell]} {
	 select cell $instname
	 set arcount [array -list count]
	 set arpitch [array -list pitch]

	 dict set parameters nx [expr [lindex $arcount 1] - [lindex $arcount 0] + 1]
	 dict set parameters ny [expr [lindex $arcount 3] - [lindex $arcount 2] + 1]
	 dict set parameters pitchx [lindex $arpitch 0]
	 dict set parameters pitchy [lindex $arpitch 1]
      }
      set ttext "Edit device"
      set itext $instname
   } else {
      set parameters [magic::gencell_defaults $gencell_type $library $parameters]
      set gname "(default)"
      set itext "(default)"
      set ttext "New device"
   }

   # Destroy children, not the top-level window, or else window keeps
   # bouncing around every time something is changed.
   if {[catch {toplevel .params}]} {
       .params.title.lab1 configure -text "${ttext}:"
       .params.title.lab2 configure -text "$gencell_type"
       .params.title.lab4 configure -text "$library"
       .params.title.glab configure -foreground blue -text "$gname"
       .params.title.ient delete 0 end
       .params.title.ient insert 0 "$itext"
       foreach child [winfo children .params.edits] {
	  destroy $child
       }
       foreach child [winfo children .params.buttons] {
	  destroy $child
       }
   } else {
       frame .params.title
       label .params.title.lab1 -text "${ttext}:"
       label .params.title.lab2 -foreground blue -text "$gencell_type"
       label .params.title.lab3 -text "Library:"
       label .params.title.lab4 -foreground blue -text "$library"
       label .params.title.clab -text "Cellname:"
       label .params.title.glab -foreground blue -text "$gname"
       label .params.title.ilab -text "Instance:"
       entry .params.title.ient -foreground brown -background white
       .params.title.ient insert 0 "$itext"
       ttk::separator .params.sep
       frame .params.edits
       frame .params.buttons

       grid .params.title.lab1 -padx 5 -row 0 -column 0
       grid .params.title.lab2 -padx 5 -row 0 -column 1 -sticky w
       grid .params.title.lab3 -padx 5 -row 0 -column 2
       grid .params.title.lab4 -padx 5 -row 0 -column 3 -sticky w

       grid .params.title.clab -padx 5 -row 1 -column 0
       grid .params.title.glab -padx 5 -row 1 -column 1 -sticky w
       grid .params.title.ilab -padx 5 -row 1 -column 2
       grid .params.title.ient -padx 5 -row 1 -column 3 -sticky ew
       grid columnconfigure .params.title 3 -weight 1

       pack .params.title -fill x -expand true
       pack .params.sep -fill x -expand true
       pack .params.edits -side top -fill both -expand true -ipadx 5
       pack .params.buttons -fill x

       grid columnconfigure .params.edits 1 -weight 1
   }

   if {$instname == {}} {
	button .params.buttons.apply -text "Create" -command \
		[subst {set inst \[magic::gencell_create \
		$gencell_type $library {}\] ; \
		magic::gencell_dialog \$inst $gencell_type $library {} }]
	button .params.buttons.okay -text "Create and Close" -command \
		[subst {set inst \[magic::gencell_create \
		$gencell_type $library {}\] ; \
		magic::gencell_dialog \$inst $gencell_type $library {} ; \
		destroy .params}]
   } else {
	button .params.buttons.apply -text "Apply" -command \
		"magic::gencell_change $instname $gencell_type $library {}"
	button .params.buttons.okay -text "Okay" -command \
		"magic::gencell_change $instname $gencell_type $library {} ;\
		 destroy .params"
   }
   button .params.buttons.reset -text "Reset" -command \
		"magic::gencell_dialog {} ${gencell_type} ${library} {}"
   button .params.buttons.close -text "Close" -command {destroy .params}

   pack .params.buttons.apply -padx 5 -ipadx 5 -ipady 2 -side left
   pack .params.buttons.okay  -padx 5 -ipadx 5 -ipady 2 -side left
   pack .params.buttons.close -padx 5 -ipadx 5 -ipady 2 -side right
   pack .params.buttons.reset -padx 5 -ipadx 5 -ipady 2 -side right

   # Invoke the callback procedure that creates the parameter entries

   ${library}::${gencell_type}_dialog $parameters

   # Add standard callback to all entry fields to run parameter bounds checks
   magic::add_check_callbacks $gencell_type $library

   # Make sure the window is raised
   raise .params
}

#-------------------------------------------------------------
