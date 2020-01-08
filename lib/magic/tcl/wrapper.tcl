# This is the "Magic wrapper".
# It's main purpose is to redefine the "openwindow" command in magic so that
# opening a new window creates a window wrapped by a GUI interface.
#
# Written by Tim Edwards, August 23, 2002.

# revision A: proof-of-concept.  Add whatever you want to this basic wrapper.
# revision B: Adds Tk scrollbars and caption
# revision C: Adds a layer manager toolbar on the left side
# revision D: Adds a menubar on top with cell and tech manager tools

global lwindow
global tk_version
global Glyph
global Opts
global Winopts

set tk_version $::tk_version
# Simple console commands (like TkCon, but much simpler)

if {[lsearch [namespace children] ::tkshell] < 0} {
   catch {source ${CAD_ROOT}/magic/tcl/tkshell.tcl}
}

# Button images

set Glyph(up) [image create bitmap \
	-file ${CAD_ROOT}/magic/tcl/bitmaps/up.xbm \
	-background gray -foreground steelblue]
set Glyph(down) [image create bitmap \
	-file ${CAD_ROOT}/magic/tcl/bitmaps/down.xbm \
	-background gray -foreground steelblue]
set Glyph(left) [image create bitmap \
	-file ${CAD_ROOT}/magic/tcl/bitmaps/left.xbm \
	-background gray -foreground steelblue]
set Glyph(right) [image create bitmap \
	-file ${CAD_ROOT}/magic/tcl/bitmaps/right.xbm \
	-background gray -foreground steelblue]
set Glyph(zoom) [image create bitmap \
	-file ${CAD_ROOT}/magic/tcl/bitmaps/zoom.xbm \
	-background gray -foreground steelblue]
set Glyph(lock) [image create bitmap \
	-file ${CAD_ROOT}/magic/tcl/bitmaps/lock.xbm \
	-background gray80 -foreground steelblue4]

# Menu button callback functions

proc magic::promptload {type} {
   global CAD_ROOT

   switch $type {
      cif { set Layoutfilename [ tk_getOpenFile -filetypes \
		{{CIF {.cif {.cif}}} {"All files" {*}}}]
	    if {$Layoutfilename != ""} {
		set cifname [file tail [file root $Layoutfilename]]
		magic::cellname create cif_temp
		magic::load cif_temp
		magic::cif read [file root $Layoutfilename]
		set childcells [magic::cellname list children cif_temp]
		magic::load [lindex $childcells 0]
		magic::cellname delete cif_temp -noprompt
		if {[llength $childcells] > 1} {
		   puts stdout "Cells read from GDS file: $childcells"
		}
	     }
	  }
      gds { set Layoutfilename [ tk_getOpenFile -filetypes \
		{{GDS {.gds .strm .cal {.gds .strm .cal}}} {"All files" {*}}}]
	    if {$Layoutfilename != ""} {
		set origlist [magic::cellname list top]
		magic::gds read [file root $Layoutfilename]
		set newlist [magic::cellname list top]

		# Find entries in newlist that are not in origlist.
		# If there's only one, load it into the window.

		set newtopcells {}
		foreach n $newlist {
		   if {[lsearch $origlist $n] < 0} {
		      lappend newtopcells $n
		   }
		}
		if {[llength $newtopcells] == 1} {
		   magic::load [lindex $newtopcells 0]
		} elseif {[llength $newtopcells] != 0} {
		   puts stdout "Top-level cells read from GDS file: $newtopcells"
		}
	    }
	  }
      magic { set Layoutfilename [ tk_getOpenFile -filetypes \
		{{Magic {.mag {.mag}}} {"All files" {*}}}]
	    if {$Layoutfilename != ""} {
		magic::load [file root $Layoutfilename]
	    }
	  }

      getcell { set Layoutfilename [ tk_getOpenFile -filetypes \
		{{Magic {.mag {.mag}}} {"All files" {*}}}]
	    if {$Layoutfilename != ""} {
		set fdir [file dirname $Layoutfilename]
		set lidx [lsearch [path search] $fdir]
		if {$lidx < 0} {path search +$fdir}
		magic::getcell [file tail $Layoutfilename]

		# Append path to cell search path if it's not there already

		if {[string index $Layoutfilename 0] != "/"} {
		   set $Layoutfilename "./$Layoutfilename"
		}
		set sidx [string last "/" $Layoutfilename]
		if {$sidx > 0} {
		   set cellpath [string range $Layoutfilename 0 $sidx]
		   magic::path cell +$cellpath
		}
	    }
	  }
   }
}

proc magic::promptsave {type} {
   global CAD_ROOT

   switch $type {
      cif { set Layoutfilename [ tk_getSaveFile -filetypes \
		{{CIF {.cif {.cif}}} {"All files" {*}}}]
	    if {$Layoutfilename != ""} {
	       magic::cif write $Layoutfilename
	    }
	  }
      gds { set Layoutfilename [ tk_getSaveFile -filetypes \
		{{GDS {.gds .strm .cal {.gds .strm .cal}}} {"All files" {*}}}]
	    if {$Layoutfilename != ""} {
		magic::gds write $Layoutfilename
	    }
	  }
      force -
      magic {
	    set CellList [ magic::cellname list window ]
	    if {[lsearch $CellList "(UNNAMED)"] >= 0} {
	       set Layoutfilename [ tk_getSaveFile -filetypes \
		   {{Magic {.mag {.mag}}} {"All files" {*}}} \
		   -title "Save cell (UNNAMED) as:" ]
	       if {$Layoutfilename != ""} {
		   set cellpath [file dirname $Layoutfilename]
		   if {$cellpath == [pwd]} {
		      set Layoutfilename [file tail $Layoutfilename]
		   } else {
		      magic::path cell +$cellpath
		   }
		   magic::save $Layoutfilename
	       }
	    }
	    if {$type == "force"} {
	       magic::writeall force
	    } else {
	       magic::writeall
	    }
	  }
   }
}

# Window to prompt for a new cell

proc magic::prompt_dialog { type } {
   global Opts

   if {[catch {toplevel .dialog}]} {
      foreach child [winfo children .dialog] {
         destroy $child
      }
   }

   frame .dialog.titlebar
   frame .dialog.text
   frame .dialog.bbar

   switch $type {
      new {
         label .dialog.titlebar.title -text "Create new cell" -foreground blue
         button .dialog.bbar.okay -text "Okay" -command {load $Opts(cell_name); \
		lower .dialog}
         set Opts(cell_name) "(UNNAMED)"
      }
      save {
         label .dialog.titlebar.title -text "Save cell as..." -foreground blue
         button .dialog.bbar.okay -text "Okay" -command {save $Opts(cell_name); \
		lower .dialog}
         set Opts(cell_name) [cellname list window]
      }
   }
   pack .dialog.titlebar.title

   label .dialog.text.tlabel -text "Cell name:" -foreground brown
   entry .dialog.text.tentry -background white -textvariable Opts(cell_name)

   pack .dialog.text.tlabel -side left
   pack .dialog.text.tentry -side left

   button .dialog.bbar.cancel -text "Cancel" -command "lower .dialog"

   pack .dialog.bbar.okay -side left
   pack .dialog.bbar.cancel -side right

   pack .dialog.titlebar -side top -ipadx 2 -ipady 2
   pack .dialog.text -side top -fill both -expand true
   pack .dialog.bbar -side top -fill x -ipadx 5

   bind .dialog.text.tentry <Return> {.dialog.bbar.okay invoke}

   raise .dialog
}

# Callback functions used by the DRC.

proc magic::drcupdate { option } {
   global Opts
   if {[info level] <= 1} {
      switch $option {
         on {set Opts(drc) 1}
         off {set Opts(drc) 0}
      }
   }
}

proc magic::drcstate { status } {
   set winlist [*bypass windownames layout]
   foreach lwin $winlist {
      set framename [winfo parent $lwin]
      if {$framename == "."} {return}
      switch $status {
         idle { 
		set dct [*bypass drc list count total]
		if {$dct > 0} {
	           ${framename}.titlebar.drcbutton configure -selectcolor red
		} else {
	           ${framename}.titlebar.drcbutton configure -selectcolor green
		}
	        ${framename}.titlebar.drcbutton configure -text "DRC=$dct"
	      }
         busy { ${framename}.titlebar.drcbutton configure -selectcolor yellow }
      }
   }
}

# Create the menu of windows.  This is kept separate from the cell manager,
# and linked into it by the "clone" command.

menu .winmenu -tearoff 0

proc magic::setgrid {gridsize} {
   set techlambda [magic::tech lambda]
   set tech1 [lindex $techlambda 1]
   set tech0 [lindex $techlambda 0]
   set tscale [expr {$tech1 / $tech0}]
   set lambdaout [expr {[magic::cif scale output] * $tscale}]
   set gridlambda [expr {$gridsize/$lambdaout}]
   magic::grid ${gridlambda}l
   magic::snap on
}

# Technology manager callback functions

proc magic::techparseunits {} {
   set techlambda [magic::tech lambda]
   set tech1 [lindex $techlambda 1]
   set tech0 [lindex $techlambda 0]

   set target0 [.techmgr.lambda1.lval0 get]
   set target1 [.techmgr.lambda1.lval1 get]

   set newval0 [expr {$target0 * $tech0}]
   set newval1 [expr {$target1 * $tech1}]

   magic::scalegrid $newval1 $newval0
   magic::techmanager update
}

# The technology manager

proc magic::maketechmanager { mgrpath } {
   toplevel $mgrpath
   wm withdraw $mgrpath

   frame ${mgrpath}.title
   label ${mgrpath}.title.tlab -text "Technology: "
   menubutton ${mgrpath}.title.tname -text "(none)" -foreground red3 \
	-menu ${mgrpath}.title.tname.menu
   label ${mgrpath}.title.tvers -text "" -foreground blue
   label ${mgrpath}.subtitle -text "" -foreground sienna4

   frame ${mgrpath}.lambda0
   label ${mgrpath}.lambda0.llab -text "Microns per lambda (CIF): "
   label ${mgrpath}.lambda0.lval -text "1" -foreground blue

   frame ${mgrpath}.lambda1
   label ${mgrpath}.lambda1.llab -text "Internal units per lambda: "
   entry ${mgrpath}.lambda1.lval0 -foreground red3 -background white -width 3
   label ${mgrpath}.lambda1.ldiv -text " / "
   entry ${mgrpath}.lambda1.lval1 -foreground red3 -background white -width 3

   frame ${mgrpath}.cif0
   label ${mgrpath}.cif0.llab -text "CIF input style: "
   menubutton ${mgrpath}.cif0.lstyle -text "" -foreground blue \
	-menu ${mgrpath}.cif0.lstyle.menu
   label ${mgrpath}.cif0.llab2 -text " Microns/lambda="
   label ${mgrpath}.cif0.llambda -text "" -foreground red3

   frame ${mgrpath}.cif1
   label ${mgrpath}.cif1.llab -text "CIF output style: "
   menubutton ${mgrpath}.cif1.lstyle -text "" -foreground blue \
	-menu ${mgrpath}.cif1.lstyle.menu
   label ${mgrpath}.cif1.llab2 -text " Microns/lambda="
   label ${mgrpath}.cif1.llambda -text "" -foreground red3

   frame ${mgrpath}.extract
   label ${mgrpath}.extract.llab -text "Extract style: "
   menubutton ${mgrpath}.extract.lstyle -text "" -foreground blue \
	-menu ${mgrpath}.extract.lstyle.menu

   frame ${mgrpath}.drc
   label ${mgrpath}.drc.llab -text "DRC style: "
   menubutton ${mgrpath}.drc.lstyle -text "" -foreground blue \
	-menu ${mgrpath}.drc.lstyle.menu

   pack ${mgrpath}.title.tlab -side left
   pack ${mgrpath}.title.tname -side left
   pack ${mgrpath}.title.tvers -side left
   pack ${mgrpath}.lambda0.llab -side left
   pack ${mgrpath}.lambda0.lval -side left
   pack ${mgrpath}.lambda1.llab -side left
   pack ${mgrpath}.lambda1.lval0 -side left
   pack ${mgrpath}.lambda1.ldiv -side left
   pack ${mgrpath}.lambda1.lval1 -side left
   pack ${mgrpath}.cif0.llab -side left
   pack ${mgrpath}.cif0.lstyle -side left
   pack ${mgrpath}.cif0.llab2 -side left
   pack ${mgrpath}.cif0.llambda -side left
   pack ${mgrpath}.cif1.llab -side left
   pack ${mgrpath}.cif1.lstyle -side left
   pack ${mgrpath}.cif1.llab2 -side left
   pack ${mgrpath}.cif1.llambda -side left
   pack ${mgrpath}.extract.llab -side left
   pack ${mgrpath}.extract.lstyle -side left
   pack ${mgrpath}.drc.llab -side left
   pack ${mgrpath}.drc.lstyle -side left

   pack ${mgrpath}.title -side top -fill x
   pack ${mgrpath}.subtitle -side top -fill x
   pack ${mgrpath}.lambda0 -side top -fill x
   pack ${mgrpath}.lambda1 -side top -fill x
   pack ${mgrpath}.cif0 -side top -fill x
   pack ${mgrpath}.cif1 -side top -fill x
   pack ${mgrpath}.extract -side top -fill x

   bind ${mgrpath}.lambda1.lval0 <Return> magic::techparseunits
   bind ${mgrpath}.lambda1.lval1 <Return> magic::techparseunits

   #Withdraw the window when the close button is pressed
   wm protocol ${mgrpath} WM_DELETE_WINDOW  "set Opts(techmgr) 0 ; wm withdraw ${mgrpath}"
}

# Generate the cell manager

catch {source ${CAD_ROOT}/magic/tcl/cellmgr.tcl}

# Generate the library manager

catch {source ${CAD_ROOT}/magic/tcl/libmgr.tcl}

# Generate the text helper

catch {source ${CAD_ROOT}/magic/tcl/texthelper.tcl}

# Create or redisplay the technology manager

proc magic::techmanager {{option "update"}} {
   global CAD_ROOT

   if {[catch {wm state .techmgr}]} {
      if {$option == "create"} {
	 magic::maketechmanager .techmgr
      } else {
	 return
      }
   } elseif { $option == "create"} {
      return
   }

   if {$option == "create"} {
      menu .techmgr.title.tname.menu -tearoff 0
      menu .techmgr.cif0.lstyle.menu -tearoff 0
      menu .techmgr.cif1.lstyle.menu -tearoff 0
      menu .techmgr.extract.lstyle.menu -tearoff 0
      menu .techmgr.drc.lstyle.menu -tearoff 0
    
   }

   if {$option == "init"} {
	.techmgr.title.tname.menu delete 0 end
	.techmgr.cif0.lstyle.menu delete 0 end
	.techmgr.cif1.lstyle.menu delete 0 end
	.techmgr.extract.lstyle.menu delete 0 end
	.techmgr.drc.lstyle.menu delete 0 end
   }

   if {$option == "init" || $option == "create"} {
      set tlist [magic::cif listall istyle]
      foreach i $tlist {
	 .techmgr.cif0.lstyle.menu add command -label $i -command \
		"magic::cif istyle $i ; \
		 magic::techmanager update"
      }

      set tlist [magic::cif listall ostyle]
      foreach i $tlist {
	 .techmgr.cif1.lstyle.menu add command -label $i -command \
		"magic::cif ostyle $i ; \
		 magic::techmanager update"
      }

      set tlist [magic::extract listall style]
      foreach i $tlist {
	 .techmgr.extract.lstyle.menu add command -label $i -command \
		"magic::extract style $i ; \
		 magic::techmanager update"
      }

      set tlist [magic::drc listall style]
      foreach i $tlist {
	 .techmgr.drc.lstyle.menu add command -label $i -command \
		"magic::drc style $i ; \
		 magic::techmanager update"
      }

      set dirlist [subst [magic::path sys]]
      set tlist {}
      foreach i $dirlist {
	 lappend tlist [glob -nocomplain ${i}/*.tech]
	 lappend tlist [glob -nocomplain ${i}/*.tech27]
      }
      foreach i [join $tlist] {
	 set j [file tail [file rootname ${i}]]
	 .techmgr.title.tname.menu add command -label $j -command \
		"magic::tech load $j ; \
		 magic::techmanager update"
      }
   }

   set techlambda [magic::tech lambda]
   set tech1 [lindex $techlambda 1]
   set tech0 [lindex $techlambda 0]
   set tscale [expr {$tech1 / $tech0}]

   .techmgr.title.tname configure -text [magic::tech name]
   set techstuff [magic::tech version]
   .techmgr.title.tvers configure -text "(version [lindex $techstuff 0])"
   .techmgr.subtitle configure -text [lindex $techstuff 1]
   set lotext [format "%g" [expr {[magic::cif scale output] * $tscale}]]
   .techmgr.lambda0.lval configure -text $lotext
   .techmgr.cif0.lstyle configure -text [magic::cif list istyle]
   set litext [format "%g" [expr {[magic::cif scale input] * $tscale}]]
   .techmgr.cif0.llambda configure -text $litext
   .techmgr.cif1.lstyle configure -text [magic::cif list ostyle]
   .techmgr.cif1.llambda configure -text $lotext
   .techmgr.extract.lstyle configure -text [magic::extract list style]
   .techmgr.drc.lstyle configure -text [magic::drc list style]

   .techmgr.lambda1.lval0 delete 0 end
   .techmgr.lambda1.lval1 delete 0 end
   .techmgr.lambda1.lval0 insert end $tech1
   .techmgr.lambda1.lval1 insert end $tech0
}

proc magic::captions {{subcommand {}}} {
   global Opts

   if {$subcommand != {} && $subcommand != "writeable" && $subcommand != "load"} {
      return
   }
   set winlist [magic::windownames layout]
   foreach winpath $winlist {
      set framename [winfo parent $winpath]
      set caption [$winpath windowcaption]
      set subcaption1 [lindex $caption 0]
      set techname [tech name]
      if {[catch {set Opts(tool)}]} {
         set Opts(tool) unknown
      }
      if {[lindex $caption 1] == "EDITING"} {
         set subcaption2 [lindex $caption 2]
      } else {
         # set subcaption2 [join [lrange $caption 1 end]]
         set subcaption2 $caption
      }
      ${framename}.titlebar.caption configure -text \
	   "Loaded: ${subcaption1} Editing: ${subcaption2} Tool: $Opts(tool) \
	   Technology: ${techname}"
   }
}

# Allow captioning in the title window by tagging the "load" and "edit" commands
# Note that the "box" tag doesn't apply to mouse-button events, so this function
# is duplicated by Tk binding of mouse events in the layout window.

magic::tag load "[magic::tag load]; magic::captions"
magic::tag edit "magic::captions"
magic::tag save "magic::captions"
magic::tag down "magic::captions"
magic::tag box "magic::boxview %W %1"
magic::tag move "magic::boxview %W"
magic::tag scroll "magic::scrollupdate %W"
magic::tag view "magic::scrollupdate %W"
magic::tag zoom "magic::scrollupdate %W"
magic::tag findbox "magic::scrollupdate %W"
magic::tag see "magic::toolupdate %W %1 %2"
magic::tag tech "magic::techrebuild %W %1; magic::captions %1"
magic::tag drc "magic::drcupdate %1"
magic::tag path "[magic::tag path]; magic::techmanager update"
magic::tag cellname "magic::mgrupdate %W %1"
magic::tag cif      "magic::mgrupdate %W %1"
magic::tag gds      "magic::mgrupdate %W %1"

# This should be a list. . . do be done later
set lwindow 0
set owindow 0

set Opts(techmgr) 0
set Opts(target)  default
set Opts(netlist) 0
set Opts(colormap) 0
set Opts(wind3d) 0
set Opts(crosshair) 0
set Opts(hidelocked) 0
set Opts(hidespecial) 0
set Opts(toolbar) 0
set Opts(drc) 1
set Opts(autobuttontext) 1

# Update cell and tech managers in response to a cif or gds read command

proc magic::mgrupdate {win {cmdstr ""}} {
   if {${cmdstr} == "read"} {
      catch {magic::cellmanager}
      magic::captions
      magic::techmanager update
   } elseif {${cmdstr} == "delete" || ${cmdstr} == "rename"} {
      catch {magic::cellmanager}
      magic::captions
   } elseif {${cmdstr} == "writeable"} {
      magic::captions
   }
}

# Set default width and height to be 3/4 of the screen size.
set Opts(geometry) \
"[expr {3 * [winfo screenwidth .] / 4}]x[expr {3 * [winfo screenheight .] \
/ 4}]+100+100"

# Procedures for the layout scrollbars, which are made from canvas
# objects to avoid the problems associated with Tk's stupid scrollbar
# implementation.

# Repainting function for scrollbars, title, etc., to match the magic
# Change the colormap (most useful in 8-bit PseudoColor)

proc magic::repaintwrapper { win } {
   set bgcolor [magic::magiccolor -]
   ${win}.xscroll configure -background $bgcolor
   ${win}.xscroll configure -highlightbackground $bgcolor
   ${win}.xscroll configure -highlightcolor [magic::magiccolor K]

   ${win}.yscroll configure -background $bgcolor
   ${win}.yscroll configure -highlightbackground $bgcolor
   ${win}.yscroll configure -highlightcolor [magic::magiccolor K]

   ${win}.titlebar.caption configure -background [magic::magiccolor w]
   ${win}.titlebar.caption configure -foreground [magic::magiccolor c]

   ${win}.titlebar.message configure -background [magic::magiccolor w]
   ${win}.titlebar.message configure -foreground [magic::magiccolor c]

   ${win}.titlebar.pos configure -background [magic::magiccolor w]
   ${win}.titlebar.pos configure -foreground [magic::magiccolor c]

}

# Coordinate display callback function
# Because "box" calls "box", use the "info level" command to avoid
# infinite recursion.

proc magic::boxview {win {cmdstr ""}} {
   if {${cmdstr} == "exists" || ${cmdstr} == "help" || ${cmdstr} == ""} {
      # do nothing. . . informational only, no change to the box
   } elseif {[info level] <= 1} {
      # For NULL window, find all layout windows and apply update to each.
      if {$win == {}} {
         set winlist [magic::windownames layout]
         foreach lwin $winlist {
	    magic::boxview $lwin
         }
         return
      }

      set framename [winfo parent $win]
      if {$framename == "."} {return}
      if {[catch {set cr [cif scale out]}]} {return}
      set bval [${win} box values]
      set bllx [expr {[lindex $bval 0] * $cr }]
      set blly [expr {[lindex $bval 1] * $cr }]
      set burx [expr {[lindex $bval 2] * $cr }]
      set bury [expr {[lindex $bval 3] * $cr }]
      if {[expr {$bllx == int($bllx)}]} {set bllx [expr {int($bllx)}]}
      if {[expr {$blly == int($blly)}]} {set blly [expr {int($blly)}]}
      if {[expr {$burx == int($burx)}]} {set burx [expr {int($burx)}]}
      if {[expr {$bury == int($bury)}]} {set bury [expr {int($bury)}]}
      set titletext [format "box (%+g %+g) to (%+g %+g) microns" \
			$bllx $blly $burx $bury]
      ${framename}.titlebar.pos configure -text $titletext
   }
}

proc magic::cursorview {win} {
   global Opts
   if {$win == {}} {
      return
   }
   set framename [winfo parent $win]
   if {[catch {set cr [cif scale out]}]} {return}
   if {$cr == 0} {return}
   set olst [${win} cursor internal]

   set olstx [lindex $olst 0]
   set olsty [lindex $olst 1]

   if {$Opts(crosshair)} {
      *bypass crosshair ${olstx}i ${olsty}i
   }

   # Use catch, because occasionally this fails on startup
   if {[catch {
      set olstx [expr {$olstx * $cr}]
      set olsty [expr {$olsty * $cr}]
   }]} {return}

   if {[${win} box exists]} {
      set dlst [${win} box position]
      set dx [expr {$olstx - ([lindex $dlst 0]) * $cr }]
      set dy [expr {$olsty - ([lindex $dlst 1]) * $cr }]
      if {[expr {$dx == int($dx)}]} {set dx [expr {int($dx)}]}
      if {[expr {$dy == int($dy)}]} {set dy [expr {int($dy)}]}
      set titletext [format "(%+g %+g) %+g %+g microns" $olstx $olsty $dx $dy]
      ${framename}.titlebar.pos configure -text $titletext
   } else {
      set titletext [format "(%+g %+g) microns" $olstx $olsty]
      ${framename}.titlebar.pos configure -text $titletext
   }
}

proc magic::toolupdate {win {yesno "yes"} {layerlist "none"}} {
   global Winopts

   if {$win == {}} {
      set win [magic::windownames]
   }

   # Wind3d has a "see" function, so make sure this is not a 3d window
   if {$win == [magic::windownames wind3d]} {
      return
   }

   set topname [winfo toplevel $win]
   set framename [winfo parent $win]

   # Don't do anything if toolbar is not present
   if { $Winopts(${topname},toolbar) == 0 } { return }

   if {$layerlist == "none"} {
	set layerlist $yesno
	set yesno "yes"
   }
   if {$layerlist == "*"} {
      set layerlist [magic::tech layer "*"]
   }

   # Change from comma-separated list to Tcl list
   set layerlist [string map {, " "} $layerlist]

   foreach layer $layerlist {
      switch $layer {
	 none {set canon ""}
	 allSame {set canon ""}
	 "*" {set canon ""}
	 "$" {set canon ""}
	 connect {set canon ""}
	 errors {set canon $layer}
	 subcell {set canon $layer}
	 labels {set canon $layer}
	 default {set canon [magic::tech layer $layer]}
      }

      # Layers may not be in the toolbar if "hidelocked" or
      # "hidespecial" is used, so catch each configure command.

      if {$canon != ""} {
         if {$yesno == "yes"} {
	    catch {${framename}.toolbar.b$canon configure -image img_$canon}
	    catch {${framename}.toolbar.p$canon configure -image pale_$canon}
         } else {
	    catch {${framename}.toolbar.b$canon configure -image img_space}
	    catch {${framename}.toolbar.p$canon configure -image img_space}
	 }
      }
   }
}

# Generate the toolbar images for a technology

proc magic::maketoolimages {} {

   # Generate a layer image for "space" that will be used when layers are
   # invisible.

   image create layer img_space -name none

   set all_layers [concat {errors labels subcell} [magic::tech layer "*"]]

   foreach layername $all_layers {
      image create layer img_$layername -name $layername
      image create layer pale_$layername -name $layername \
		-disabled true -icon 23
    }
}

# Generate the toolbar for the wrapper

proc magic::maketoolbar { framename } {
   global Opts
   global Winopts

   # Don't do anything if in suspend mode
   set topname [winfo toplevel $framename]
   if {[info exists Winopts(${topname},suspend)]} {
      if { $Winopts(${topname},suspend) > 0} { return }
   }

   if {$Opts(toolbar) == 0} {
      magic::maketoolimages
      set Opts(toolbar) 1
   }

   # Destroy any existing toolbar before starting
   set alltools [winfo children ${framename}.toolbar]
   foreach i $alltools {
      destroy $i
   }

   # All toolbar commands will be passed to the appropriate window
   set win ${framename}.magic

   # Generate layer images and buttons for toolbar
   if {$Opts(hidespecial) == 0} {
       set special_layers {errors labels subcell}
   } else {
       set special_layers {}
   }

   if {$Opts(hidelocked) == 0} {
       set all_layers [concat $special_layers [magic::tech layer "*"]]
   } else {
       set all_layers [concat $special_layers [magic::tech unlocked]]
   }
   foreach layername $all_layers {
      button ${framename}.toolbar.b$layername -image img_$layername -command \
		"$win see $layername"

      # Bindings:  Entering the button puts the canonical layer name in the 
      # message window.
      bind ${framename}.toolbar.b$layername <Enter> \
		[subst {focus %W ; ${framename}.titlebar.message configure \
		 -text "$layername"}]
      bind ${framename}.toolbar.b$layername <Leave> \
		[subst {${framename}.titlebar.message configure -text ""}]

      # 3rd mouse button makes layer invisible; 1st mouse button restores it.
      # 2nd mouse button paints the layer color.  Key "p" also does paint, esp.
      # for users with 2-button mice.  Key "e" erases, as does Shift-Button-2.

      bind ${framename}.toolbar.b$layername <ButtonPress-2> \
		"$win paint $layername"
      bind ${framename}.toolbar.b$layername <KeyPress-p> \
		"$win paint $layername"
      bind ${framename}.toolbar.b$layername <Shift-ButtonPress-2> \
		"$win erase $layername"
      bind ${framename}.toolbar.b$layername <KeyPress-e> \
		"$win erase $layername"
      bind ${framename}.toolbar.b$layername <ButtonPress-3> \
		"$win see no $layername"
      bind ${framename}.toolbar.b$layername <KeyPress-s> \
		"$win select more area $layername"
      bind ${framename}.toolbar.b$layername <KeyPress-S> \
		"$win select less area $layername"
   }

   # Create an additional set of layers and buttons in the "disabled" style
   # These buttons can be swapped in place of the regular buttons when the
   # layer is locked.  They define no bindings except "u" for "unlock",
   # and the button bindings (see, see no)

   foreach layername $all_layers {
      button ${framename}.toolbar.p$layername -image pale_$layername -command \
		"$win see $layername"
      bind ${framename}.toolbar.p$layername <ButtonPress-3> \
		"$win see no $layername"
      bind ${framename}.toolbar.p$layername <Enter> \
		[subst {focus %W ; ${framename}.titlebar.message configure \
		 -text "$layername (locked)"}]
      bind ${framename}.toolbar.p$layername <Leave> \
		[subst {${framename}.titlebar.message configure -text ""}]
   }

   # Figure out how many columns we need to fit all the layer buttons inside
   # the toolbar without going outside the window area.

   set locklist [tech locked]
   set ncols 0
   while {1} {
      incr ncols
      set i 0
      set j 0
      foreach layername $all_layers {
	 if {[lsearch $locklist $layername] >= 0} {
            grid ${framename}.toolbar.p$layername -row $i -column $j -sticky news
	 } else {
            grid ${framename}.toolbar.b$layername -row $i -column $j -sticky news
	 }
	 bind ${framename}.toolbar.p$layername <KeyPress-u> \
		"$win tech unlock $layername ; \
		grid forget ${framename}.toolbar.p$layername ; \
		grid ${framename}.toolbar.b$layername \
		-row $i -column $j -sticky news"
	 bind ${framename}.toolbar.b$layername <KeyPress-l> \
		"$win tech lock $layername ; \
		grid forget ${framename}.toolbar.b$layername ; \
		grid ${framename}.toolbar.p$layername \
		-row $i -column $j -sticky news"
         incr j
         if {$j == $ncols} {
	    set j 0
	    incr i
         }
      }

      # Make sure that window has been created so we will get the correct
      # height value.

      update idletasks
      set winheight [expr {[winfo height ${framename}] - \
		[winfo height ${framename}.titlebar]}]
      set toolheight [lindex [grid bbox ${framename}.toolbar] 3]
      if {$toolheight <= $winheight} {break}
   }
}

# Delete and rebuild the toolbar buttons in response to a "tech load"
# command.

proc magic::techrebuild {winpath {cmdstr ""}} {
   global Opts

   # For NULL window, find all layout windows and apply update to each.
   if {$winpath == {}} {
      set winlist [magic::windownames layout]
      foreach lwin $winlist {
	 magic::techrebuild $lwin $cmdstr
      }
      return
   }

   set framename [winfo parent $winpath]
   if {${cmdstr} == "load"} {
      set Opts(toolbar) 0
      maketoolbar ${framename}
      magic::techmanager init
   } elseif {${cmdstr} == "lock" || ${cmdstr} == "unlock" || ${cmdstr} == "revert"} {
      maketoolbar ${framename}
   }
}

# Scrollbar callback procs

# Procedure to return the effective X and Y scrollbar bounds for the
# current view in magic (in pixels)

proc magic::setscrollvalues {win} {
   set svalues [${win} view get]
   set bvalues [${win} view bbox]

   set framename [winfo parent ${win}]
   if {$framename == "."} {return}

   set bwidth [expr {[lindex $bvalues 2] - [lindex $bvalues 0]}]
   set bheight [expr {[lindex $bvalues 3] - [lindex $bvalues 1]}]

   set wwidth [winfo width ${framename}.xscroll.bar]  ;# horizontal scrollbar
   set wheight [winfo height ${framename}.yscroll.bar]  ;# vertical scrollbar

   # Note that adding 0.0 here forces floating-point

   set xscale [expr {(0.0 + $wwidth) / $bwidth}]
   set yscale [expr {(0.0 + $wheight) / $bheight}]

   set xa [expr {$xscale * ([lindex $svalues 0] - [lindex $bvalues 0]) }]
   set xb [expr {$xscale * ([lindex $svalues 2] - [lindex $bvalues 0]) }]
   set ya [expr {$yscale * ([lindex $svalues 1] - [lindex $bvalues 1]) }]
   set yb [expr {$yscale * ([lindex $svalues 3] - [lindex $bvalues 1]) }]

   # Magic's Y axis is inverted with respect to X11 window coordinates
   set ya [expr { $wheight - $ya }]
   set yb [expr { $wheight - $yb }]

   ${framename}.xscroll.bar coords slider $xa 2 $xb 15
   ${framename}.yscroll.bar coords slider 2 $ya 15 $yb

   set xb [expr { 1 + ($xa + $xb) / 2 }]
   set xa [expr { $xb - 2 }]
   ${framename}.xscroll.bar coords centre $xa 4 $xb 13

   set yb [expr { 1 + ($ya + $yb) / 2 }]
   set ya [expr { $yb - 2 }]
   ${framename}.yscroll.bar coords centre 4 $ya 13 $yb
}

# Procedure to update scrollbars in response to an internal command
# "view" calls "view", so avoid infinite recursion.

proc magic::scrollupdate {win} {

   if {[info level] <= 1} {

      # For NULL window, find current window
      if {$win == {}} {
	 set win [magic::windownames]
      }

      # Make sure we're not a 3D window, which doesn't take window commands
      # This is only necessary because the 3D window declares a "view"
      # command, too.

      if {$win != [magic::windownames wind3d]} {
 	 magic::setscrollvalues $win
      }
   }
}

# scrollview:  update the magic display to match the
# scrollbar positions.

proc magic::scrollview { w win orient } {
   global scale
   set v1 $scale($orient,origin)
   set v2 $scale($orient,update)
   set delta [expr {$v2 - $v1}]

   set bvalues [${win} view bbox]
   set wvalues [${win} windowpositions]

   # Note that adding 0.000 in expression forces floating-point

   if {"$orient" == "x"} {

      set bwidth [expr {[lindex $bvalues 2] - [lindex $bvalues 0]}]
      set wwidth [expr {0.000 + [lindex $wvalues 2] - [lindex $wvalues 0]}]
      set xscale [expr {$bwidth / $wwidth}]
      ${win} scroll e [expr {$delta * $xscale}]i

   } else {

      set bheight [expr {[lindex $bvalues 3] - [lindex $bvalues 1]}]
      set wheight [expr {0.000 + [lindex $wvalues 3] - [lindex $wvalues 1]}]
      set yscale [expr {$bheight / $wheight}]
      ${win} scroll s [expr {$delta * $yscale}]i
   }
}

# setscroll: get the current cursor position and save it as a
# reference point.

proc magic::setscroll { w v orient } {
   global scale
   set scale($orient,origin) $v
   set scale($orient,update) $v
}

proc magic::dragscroll { w v orient } {
   global scale
   set v1 $scale($orient,update)
   set scale($orient,update) $v
   set delta [expr {$v - $v1}]

   if { "$orient" == "x" } {
      $w move slider $delta 0
      $w move centre $delta 0
   } else {
      $w move slider 0 $delta
      $w move centre 0 $delta
   }
}

# Scrollbar generator for the wrapper window

proc magic::makescrollbar { fname orient win } {
   global scale
   global Glyph

   set scale($orient,update) 0
   set scale($orient,origin) 0

   # To be done:  add glyphs for the arrows

   if { "$orient" == "x" } {
      canvas ${fname}.bar -height 13 -relief sunken -borderwidth 1
      button ${fname}.lb -image $Glyph(left) -borderwidth 1 \
		-command "${win} scroll left .1 w"
      button ${fname}.ub -image $Glyph(right) -borderwidth 1 \
		-command "${win} scroll right .1 w"
      pack ${fname}.lb -side left
      pack ${fname}.bar -fill $orient -expand true -side left
      pack ${fname}.ub -side right
   } else {
      canvas ${fname}.bar -width 13 -relief sunken -borderwidth 1
      button ${fname}.lb -image $Glyph(down) -borderwidth 1 \
		-command "${win} scroll down .1 w"
      button ${fname}.ub -image $Glyph(up) -borderwidth 1 \
		-command "${win} scroll up .1 w"
      pack ${fname}.ub
      pack ${fname}.bar -fill $orient -expand true
      pack ${fname}.lb
   }

   # Create the bar which controls the scrolling and bind actions to it
   ${fname}.bar create rect 2 2 15 15 -fill steelblue -width 0 -tag slider
   ${fname}.bar bind slider <Button-1> "magic::setscroll %W %$orient $orient"
   ${fname}.bar bind slider <ButtonRelease-1> "magic::scrollview %W $win $orient"
   ${fname}.bar bind slider <B1-Motion> "magic::dragscroll %W %$orient $orient"

   # Create a small mark in the center of the scrolling rectangle which aids
   # in determining how much the window is being scrolled when the full
   # scrollbar extends past the window edges.
   ${fname}.bar create rect 4 4 13 13 -fill black -width 0 -tag centre
   ${fname}.bar bind centre <Button-1> "magic::setscroll %W %$orient $orient"
   ${fname}.bar bind centre <ButtonRelease-1> "magic::scrollview %W $win $orient"
   ${fname}.bar bind centre <B1-Motion> "magic::dragscroll %W %$orient $orient"
}

# Save all and quit.  If something bad happens like an attempt to
# write cells into an unwriteable directory, then "cellname list modified"
# will contain a list of cells, so prompt to quit with the option to cancel.
# If there are no remaining modified and unsaved cells, then just exit.
# Because cell "(UNNAMED)" is not written by "writeall force", if that is
# the only modified cell, then prompt to change its name and save; then quit.

proc magic::saveallandquit {} {
   magic::promptsave force
   set modlist [magic::cellname list modified]
   if {$modlist == {}} {
      magic::quit -noprompt
   } else {
      magic::quit
   }
}

# Create the wrapper and open up a layout window in it.

proc magic::openwrapper {{cell ""} {framename ""}} {
   global lwindow
   global owindow
   global tk_version
   global Glyph
   global Opts
   global Winopts
   
   # Disallow scrollbars and title caption on windows---we'll do these ourselves

   if {$lwindow == 0} {
      windowcaption off
      windowscrollbars off
      windowborder off
   }

   if {$framename == ""} {
      incr lwindow 
      set framename .layout${lwindow}
   }
   set winname ${framename}.pane.top.magic
   
   toplevel $framename
   tkwait visibility $framename

   # Resize the window
   if {[catch {wm geometry ${framename} $Winopts(${framename},geometry)}]} {
      catch {wm geometry ${framename} $Opts(geometry)}
   }

   # Create a paned window top--bottom inside the top level window to accomodate
   # a resizable command entry window at the bottom.  Sashwidth is zero by default
   # but is resized by enabling the command entry window.

   panedwindow ${framename}.pane -orient vertical -sashrelief groove -sashwidth 6

   frame ${framename}.pane.top
   frame ${framename}.pane.bot

   set layoutframe ${framename}.pane.top

   ${framename}.pane add ${framename}.pane.top
   ${framename}.pane add ${framename}.pane.bot
   ${framename}.pane paneconfigure ${framename}.pane.top -stretch always
   ${framename}.pane paneconfigure ${framename}.pane.bot -hide true

   pack ${framename}.pane -side top -fill both -expand true

   frame ${layoutframe}.xscroll -height 13
   frame ${layoutframe}.yscroll -width 13

   magic::makescrollbar ${layoutframe}.xscroll x ${winname}
   magic::makescrollbar ${layoutframe}.yscroll y ${winname}
   button ${layoutframe}.zb -image $Glyph(zoom) -borderwidth 1 -command "${winname} zoom 2"

   # Add bindings for mouse buttons 2 and 3 to the zoom button
   bind ${layoutframe}.zb <Button-3> "${winname} zoom 0.5"
   bind ${layoutframe}.zb <Button-2> "${winname} view"

   frame ${layoutframe}.titlebar
   label ${layoutframe}.titlebar.caption -text "Loaded: none Editing: none Tool: box" \
	-foreground white -background sienna4 -anchor w -padx 15
   label ${layoutframe}.titlebar.message -text "" -foreground white \
	-background sienna4 -anchor w -padx 5
   label ${layoutframe}.titlebar.pos -text "" -foreground white \
	-background sienna4 -anchor w -padx 5

   # Menu buttons
   frame ${layoutframe}.titlebar.mbuttons

# File
   menubutton ${layoutframe}.titlebar.mbuttons.file -text File -relief raised \
		-menu ${layoutframe}.titlebar.mbuttons.file.toolmenu -borderwidth 2
# Edit
   menubutton ${layoutframe}.titlebar.mbuttons.edit -text Edit -relief raised \
		-menu ${layoutframe}.titlebar.mbuttons.edit.toolmenu -borderwidth 2
# Cell
   menubutton ${layoutframe}.titlebar.mbuttons.cell -text Cell -relief raised \
		-menu ${layoutframe}.titlebar.mbuttons.cell.toolmenu -borderwidth 2
# Window
   menubutton ${layoutframe}.titlebar.mbuttons.win -text Window -relief raised \
		-menu ${layoutframe}.titlebar.mbuttons.win.toolmenu -borderwidth 2
# Layers
   menubutton ${layoutframe}.titlebar.mbuttons.layers -text Layers -relief raised \
		-menu ${layoutframe}.titlebar.mbuttons.layers.toolmenu -borderwidth 2
# DRC
   menubutton ${layoutframe}.titlebar.mbuttons.drc -text Drc -relief raised \
		-menu ${layoutframe}.titlebar.mbuttons.drc.toolmenu -borderwidth 2
# Netlist
#   menubutton ${layoutframe}.titlebar.mbuttons.netlist -text Neltist -relief raised \
#		-menu ${layoutframe}.titlebar.mbuttons.netlist.netlistmenu -borderwidth 2
# Help
#   menubutton ${layoutframe}.titlebar.mbuttons.help -text Help -relief raised \
#		-menu ${layoutframe}.titlebar.mbuttons.help.helpmenu -borderwidth 2
# Options
   menubutton ${layoutframe}.titlebar.mbuttons.opts -text Options -relief raised \
		-menu ${layoutframe}.titlebar.mbuttons.opts.toolmenu -borderwidth 2
   pack ${layoutframe}.titlebar.mbuttons.file   -side left
   pack ${layoutframe}.titlebar.mbuttons.edit   -side left
   pack ${layoutframe}.titlebar.mbuttons.cell   -side left
   pack ${layoutframe}.titlebar.mbuttons.win    -side left
   pack ${layoutframe}.titlebar.mbuttons.layers -side left
   pack ${layoutframe}.titlebar.mbuttons.drc    -side left
#   pack ${layoutframe}.titlebar.mbuttons.netlist -side left
#   pack ${layoutframe}.titlebar.mbuttons.help    -side left
   pack ${layoutframe}.titlebar.mbuttons.opts    -side left

   # DRC status button
   checkbutton ${layoutframe}.titlebar.drcbutton -text "DRC" -anchor w \
	-borderwidth 2 -variable Opts(drc) \
	-foreground white -background sienna4 -selectcolor green \
	-command [subst { if { \$Opts(drc) } { drc on } else { drc off } }]

   magic::openwindow $cell $winname

   # Create toolbar frame.  Make sure it has the same visual and depth as
   # the layout window, so there will be no problem using the GCs from the
   # layout window to paint into the toolbar.
   frame ${layoutframe}.toolbar \
	-visual "[winfo visual ${winname}] [winfo depth ${winname}]"

   # Repaint to magic colors
   magic::repaintwrapper ${layoutframe}

   grid ${layoutframe}.titlebar -row 0 -column 0 -columnspan 3 -sticky news
   grid ${layoutframe}.yscroll -row 1 -column 0 -sticky ns
   grid $winname -row 1 -column 1 -sticky news
   grid ${layoutframe}.zb -row 2 -column 0
   grid ${layoutframe}.xscroll -row 2 -column 1 -sticky ew
   # The toolbar is not attached by default

   grid rowconfigure ${layoutframe} 1 -weight 1
   grid columnconfigure ${layoutframe} 1 -weight 1

   grid ${layoutframe}.titlebar.mbuttons -row 0 -column 0 -sticky news
   grid ${layoutframe}.titlebar.drcbutton -row 0 -column 1 -sticky news
   grid ${layoutframe}.titlebar.caption -row 0 -column 2 -sticky news
   grid ${layoutframe}.titlebar.message -row 0 -column 3 -sticky news
   grid ${layoutframe}.titlebar.pos -row 0 -column 4 -sticky news
   grid columnconfigure ${layoutframe}.titlebar 2 -weight 1

   bind $winname <Enter> "focus %W ; set Opts(focus) $framename"

   # Note: Tk binding bypasses the event proc, so it is important to
   # set the current point;  otherwise, the cursor will report the
   # wrong position and/or the wrong window.  HOWEVER we should wrap
   # this command with the "bypass" command such that it does not
   # reset any current input redirection to the terminal.

   bind ${winname} <Motion> "*bypass setpoint %x %y ${winname}; \
	magic::cursorview ${winname}"

   set Winopts(${framename},toolbar) 1
   set Winopts(${framename},cmdentry) 0

# #################################
# File
# #################################
   set m [menu ${layoutframe}.titlebar.mbuttons.file.toolmenu -tearoff 0]
   $m add command -label "Open..."      -command {magic::promptload magic}
   # $m add command -label "Save"       -command {magic::save }
   $m add command -label "Save..."      -command {magic::promptsave magic}
   # $m add command -label "Save as..." -command {echo "not implemented"}
   # $m add command -label "Save selection..." -command {echo "not implemented"}
   $m add separator
   $m add command -label "Flush changes" -command {magic::flush}
   $m add separator
   # $m add command -label "Read CIF" -command {magic::promptload cif}
   $m add command -label "Read GDS"    -command {magic::promptload gds}
   # $m add separator
   # $m add command -label "Write CIF" -command {magic::promptsave cif}
   $m add command -label "Write GDS"   -command {magic::promptsave gds}
   # $m add separator
   # $m add command -label "Print..."  -command {echo "not implemented"}
   $m add separator
   $m add command -label "Save All and Quit" -command {magic::saveallandquit}
   $m add command -label "Quit"              -command {magic::quit}

# #################################
# Edit
# #################################

   set m [menu ${layoutframe}.titlebar.mbuttons.edit.toolmenu -tearoff 0]
   # $m add command -label "Cut" -command {echo "not implemented"}
   # $m add command -label "Copy" -command {echo "not implemented"}
   # $m add command -label "Paste" -command {echo "not implemented"}
   $m add command -label "Delete" -command {delete}
   $m add separator
   $m add command -label "Select Area" -command {select area}
   $m add command -label "Select Clear" -command {select clear}
   $m add separator
   $m add command -label "Undo" -command {magic::undo}
   $m add command -label "Redo" -command {magic::redo}
   # $m add command -label "Repeat Last" -command {echo "not implemented"}
   $m add separator
   $m add command -label "Rotate 90 degree" -command {magic::clock}
   $m add command -label "Mirror   Up/Down"  -command {magic::upsidedown}
   $m add command -label "Mirror Left/Right" -command {magic::sideways}
   $m add separator
   $m add command -label "Move Right" -command {move right 1}
   $m add command -label "Move Left" -command {move left 1}
   $m add command -label "Move Up" -command {move up 1}
   $m add command -label "Move Down" -command {move down 1}
   $m add separator
   $m add command -label "Stretch Right" -command {stretch right 1}
   $m add command -label "Stretch Left" -command {stretch left 1}
   $m add command -label "Stretch Up" -command {stretch up 1}
   $m add command -label "Stretch Down" -command {stretch down 1}
   $m add separator
   $m add command -label "Text ..." \
		-command [subst {magic::update_texthelper; \
		wm deiconify .texthelper ; raise .texthelper}]

# #################################
# Cell
# #################################
   set m [menu ${layoutframe}.titlebar.mbuttons.cell.toolmenu -tearoff 0]
   $m add command -label "New..." -command {magic::prompt_dialog new}
   $m add command -label "Save as..." -command {magic::prompt_dialog save}
   $m add command -label "Select" -command {magic::select cell}
   $m add command -label "Place Instance" -command {magic::promptload getcell}
   # $m add command -label "Rename" -command {echo "not implemented"}
   $m add separator
   $m add command -label "Down hierarchy" -command {magic::pushstack}
   $m add command -label "Up   hierarchy" -command {magic::popstack}
   $m add separator
   $m add command -label "Edit" -command {magic::edit}
   $m add separator
   $m add command -label "Delete" -command \
		{magic::cellname delete [magic::cellname list window]}
   $m add separator
   $m add command -label "Expand Toggle" -command {magic::expand toggle}
   $m add command -label "Expand" -command {magic::expand}
   $m add command -label "Unexpand" -command {magic::unexpand}
   $m add separator
   $m add command -label "Lock   Cell" -command {magic::instance lock}
   $m add command -label "Unlock Cell" -command {magic::instance unlock}

# #################################
# Window
# #################################
   set m [menu ${layoutframe}.titlebar.mbuttons.win.toolmenu -tearoff 0]
   $m add command -label "Clone" -command \
		{magic::openwrapper [magic::cellname list window]}
   $m add command -label "New" -command "magic::openwrapper"
   $m add command -label "Set Editable" -command \
		"pushbox ; select top cell ; edit ; popbox"
   $m add command -label "Close" -command "closewrapper ${framename}"
   $m add separator
   $m add command -label "Full View" -command {magic::view}
   $m add command -label "Redraw" -command {magic::redraw}
   $m add command -label "Zoom Out" -command {magic::zoom 2}
   $m add command -label "Zoom In" -command {magic::zoom 0.5}
   $m add command -label "Zoom Box" -command {magic::findbox zoom}
   $m add separator
   $m add command -label "Grid on" -command {magic::grid on}
   $m add command -label "Grid off" -command {magic::grid off}
   $m add command -label "Snap-to-grid on" -command {magic::snap on}
   $m add command -label "Snap-to-grid off" -command {magic::snap off}
   $m add command -label "Measure box" -command {magic::box }
   $m add separator
   $m add command -label "Set grid 0.05um" -command {magic::grid 0.05um}
   $m add command -label "Set grid 0.10um" -command {magic::grid 0.10um}
   $m add command -label "Set grid 0.50um" -command {magic::grid 0.50um}
   $m add command -label "Set grid 1.00um" -command {magic::grid 1.00um}
   $m add command -label "Set grid 5.00um" -command {magic::grid 5.00um}
   $m add command -label "Set grid 10.0um" -command {magic::grid 10.0um}
   # $m add command -label "Set grid ..." -command {echo "not implemented"}

# #################################
# Layers
# #################################
   set m [menu ${layoutframe}.titlebar.mbuttons.layers.toolmenu -tearoff 0]
   $m add command -label "Protect Base Layers" -command {magic::tech revert}
   $m add command -label "Unlock  Base Layers" -command {magic::tech unlock *}
   $m add separator
   $m add command -label "Clear Feedback" -command {magic::feedback clear}
   $m add separator

# #################################
# DRC
# #################################
   set m [menu ${layoutframe}.titlebar.mbuttons.drc.toolmenu -tearoff 0]
   # $m add command -label "DRC On" -command {drc on}
   # $m add command -label "DRC Off" -command {drc off}
   # $m add separator
   $m add command -label "DRC update" -command {drc check; drc why}
   $m add command -label "DRC report" -command {drc why}
   $m add command -label "DRC Find next error" -command {drc find; findbox zoom}
   $m add separator
   $m add command -label "DRC Fast"     -command {drc style drc(fast)}
   $m add command -label "DRC Complete" -command {drc style drc(full)}

   set m [menu ${layoutframe}.titlebar.mbuttons.opts.toolmenu -tearoff 0]
   $m add check -label "Toolbar" -variable Winopts(${framename},toolbar) \
	-command [subst {if { \$Winopts(${framename},toolbar) } { \
		magic::maketoolbar ${layoutframe} ; \
		grid ${layoutframe}.toolbar -row 1 -column 2 -rowspan 2 -sticky new ; \
		} else { \
		grid forget ${layoutframe}.toolbar } }]

   $m add check -label "Toolbar Hide Locked" \
	-variable Opts(hidelocked) \
	-command "magic::maketoolbar ${layoutframe}"

   .winmenu add radio -label ${framename} -variable Opts(target) -value ${winname}
   if {$tk_version >= 8.5} {
     $m add check -label "Cell Manager" -variable Opts(cellmgr) \
	-command [subst { magic::cellmanager create; \
	if { \$Opts(cellmgr) } { \
	   wm deiconify .cellmgr ; raise .cellmgr \
	} else { \
	   wm withdraw .cellmgr } }]
      .winmenu entryconfigure last -command ".cellmgr.target.list configure \
         -text ${framename}"
   }
   if {$tk_version >= 8.5} {
     $m add check -label "Library Manager" -variable Opts(libmgr) \
	-command [subst { magic::libmanager create; \
	if { \$Opts(libmgr) } { \
	   wm deiconify .libmgr ; raise .libmgr \
	} else { \
	   wm withdraw .libmgr } }]
      .winmenu entryconfigure last -command ".libmgr.target.list configure \
         -text ${framename}"
   }
   $m add check -label "Tech Manager" -variable Opts(techmgr) \
	-command [subst { magic::techmanager create; \
		if { \$Opts(techmgr) } { \
		wm deiconify .techmgr ; raise .techmgr \
		} else { \
		wm withdraw .techmgr } }]

   $m add check -label "Netlist Window" -variable Opts(netlist) \
	-command [subst { if { \[windownames netlist\] != {}} { \
		   set Opts(netlist) 0 ; closewindow \[windownames netlist\] \
		} else { \
		   set Opts(netlist) 1 ; specialopen netlist \
		} }]

   $m add check -label "Colormap Window" -variable Opts(colormap) \
	-command [subst { if { \[windownames color\] != {}} { \
		   set Opts(colormap) 0 ; closewindow \[windownames color\] \
		} else { \
		   set Opts(colormap) 1 ; specialopen color \
		} }]

   $m add check -label "3D Display" -variable Opts(wind3d) \
	-command [subst { if { \[windownames wind3d\] != {}} { \
		   set Opts(wind3d) 0 ; .render.magic closewindow ; \
		   destroy .render \
		} else { \
		   set Opts(wind3d) 1 ; \
		   magic::render3d \[${winname} cellname list window\] \
		} }]

   $m add check -label "Window Command Entry" \
	-variable Winopts(${framename},cmdentry) \
	-command [subst { if { \$Winopts(${framename},cmdentry) } { \
		addcommandentry $framename \
		} else { \
		deletecommandentry $framename } }]

   $m add check -label "Crosshair" \
	-variable Opts(crosshair) \
	-command {if {$Opts(crosshair) == 0} {crosshair off}}

   catch {addmazehelper $m}

   # Set the default view

   update idletasks
   ${winname} magic::view

   magic::captions

   # If the toolbar is turned on, invoke the toolbar button
   if { $Winopts(${framename},toolbar) == 1} {
      magic::maketoolbar ${layoutframe}
      grid ${layoutframe}.toolbar -row 1 -column 2 -rowspan 2 -sticky new
   }

   # Remove "open" and "close" macros so they don't generate non-GUI
   # windows or (worse) blow away the window inside the GUI frame

   if {[magic::macro list o] == "openwindow"} {
      magic::macro o \
	   "incr owindow ;\
	   set rpt \[cursor screen\] ;\
	   set rptx \[lindex \$rpt 0\] ;\
	   set rpty \[lindex \$rpt 1\] ;\
	   set Winopts(.owindow\$owindow,geometry) 500x500+\$rptx+\$rpty ;\
	   openwrapper \[\$Opts(focus)*.magic cellname list window\] \
	   .owindow\$owindow ;\
	   .owindow\$owindow*.magic view \[box values\]"
   }
   if {[magic::macro list O] == "closewindow"} {
      magic::macro O "closewrapper \$Opts(focus)"
   }

   # Make sure that closing from the window manager is equivalent to
   # the command "closewrapper"
   wm protocol ${framename} WM_DELETE_WINDOW "closewrapper ${framename}"

   # If the variable $Opts(callback) is defined, then attempt to execute it.
   catch {eval $Opts(callback)}

   # If the variable $Winopts(callback) is defined, then attempt to execute it.
   catch {eval $Winopts(${framename}, callback)}

   # Since one purpose of the window callback is to customize the menus,
   # run the automatic generation of accelerator key text at the end.
   # This can be subverted by setting Opts(autobuttontext) to 0, e.g.,
   # to put it at the top of the Winopts callback and then generate
   # override values for specific buttons.
   if {$Opts(autobuttontext)} {
      catch {magic::button_auto_bind_text $layoutframe}
   }
   return ${winname}
}

# Delete the wrapper and the layout window in it.

proc magic::closewrapper { framename } {
   global tk_version
   global Opts

   # Remove this window from the target list in .winmenu
   # (used by, e.g., cellmanager)

   set layoutframe ${framename}.pane.top
   if { $Opts(target) == "${layoutframe}.magic" } {
      set Opts(target) "default"
      if {$tk_version >= 8.5} {
	 if {![catch {wm state .cellmgr}]} {
	    .cellmgr.target.list configure -text "default"
         } 
      }
   }

   set idx [.winmenu index $framename]
   .winmenu delete $idx

   ${layoutframe}.magic magic::closewindow
   destroy $framename
}

# This procedure adds a command-line entry window to the bottom of
# a wrapper window (rudimentary functionality---incomplete)

proc magic::addcommandentry { framename } {
   set commandframe ${framename}.pane.bot
   if {![winfo exists ${commandframe}.eval]} {
      tkshell::YScrolled_Text ${commandframe}.eval -height 5
      tkshell::MakeEvaluator ${commandframe}.eval.text \
		"${framename}>" ${framename}.pane.top.magic
      pack ${commandframe}.eval -side top -fill both -expand true
      ${framename}.pane paneconfigure ${framename}.pane.bot -stretch never
      ${framename}.pane paneconfigure ${framename}.pane.bot -minsize 50
   }
   set entercmd [bind ${framename}.pane.top.magic <Enter>]
   set bindstr "$entercmd ; macro XK_colon \"set Opts(redirect) 1;\
		focus ${commandframe}.eval.text\";\
		alias puts tkshell::PutsTkShell"
   bind ${commandframe}.eval <Enter> \
	"focus ${commandframe}.eval.text ; set Opts(focus) $framename ;\
	catch {unset Opts(redirect)}"
   bind ${framename}.pane.top.magic <Enter> $bindstr
   # Make command entry window visible
   ${framename}.pane paneconfigure ${framename}.pane.bot -hide false
}

# Remove the command entry window from the bottom of a frame.

proc magic::deletecommandentry { framename } {
   set commandframe ${framename}.pane.bot
   ::grid forget ${commandframe}.eval
   # Remove the last bindings for <Enter>
   set bindstr [bind ${framename}.pane.top.magic <Enter>]
   set i [string first "; macro" $bindstr]
   set bindstr [string range $bindstr 0 $i-1]
   bind ${framename}.pane.top.magic <Enter> $bindstr
   # Restore the keybinding for colon
   imacro XK_colon ":"
   # Restore the alias for "puts"
   alias puts ::tkcon_puts
   # Make command entry window invisible
   ${framename}.pane paneconfigure ${framename}.pane.bot -hide true
}

namespace import magic::openwrapper
puts "Use openwrapper to create a new GUI-based layout window"
namespace import magic::closewrapper
puts "Use closewrapper to remove a new GUI-based layout window"

# Create a simple wrapper for the 3D window. . . this can be
# greatly expanded upon.

proc magic::render3d {{cell ""}} {
   global Opts

   toplevel .render
   tkwait visibility .render
   magic::specialopen wind3d $cell .render.magic
   .render.magic cutbox box
   set Opts(cutbox) 1
   wm protocol .render WM_DELETE_WINDOW "set Opts(wind3d) 0 ; \
		.render.magic closewindow ; destroy .render"

   frame .render.title
   pack .render.title -expand true -fill x -side top
   checkbutton .render.title.cutbox -text "Cutbox" -variable Opts(cutbox) \
	-foreground white -background sienna4 -anchor w -padx 15 \
	-command [subst { if { \$Opts(cutbox) } { .render.magic cutbox box \
	} else { \
	.render.magic cutbox none } }]
	
   if {$cell == ""} {set cell default}
   label .render.title.msg -text "3D Rendering window  Cell: $cell" \
	-foreground white -background sienna4 -anchor w -padx 15
   pack .render.title.cutbox -side left
   pack .render.title.msg -side right -fill x -expand true
   pack .render.magic -expand true -fill both -side bottom
   bind .render.magic <Enter> {focus %W}
}

