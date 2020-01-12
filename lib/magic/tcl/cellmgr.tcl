#------------------------------------------------------
# Script for generating the "cell manager" window.
#
# Written by Daniel Bearden and Tim Edwards, 2009-2010
#------------------------------------------------------

global Opts

if {$::tk_version >= 8.5} {

set Opts(cellmgr) 0

magic::tag select   "magic::mgrselect %R"
magic::tag load     "catch {magic::clearstack}; magic::cellmanager"
magic::tag getcell  "magic::cellmanager"

# Callback to the cell manager

proc magic::instcallback {command} {
   global Opts

   set rpath [ split [.cellmgr.box.view focus] "/"]
   set rootdef [lindex $rpath 0]
   set cellpath [lrange $rpath 1 end]
   set celldef [lrange $rpath end end]

   if { $Opts(target) == "default" } {
      set winlist [magic::windownames layout]
      set winname [lindex $winlist 0]
   } else {
      set winname $Opts(target)
   }

   if { $cellpath == {} } {
      switch $command {
	 load {$winname load $rootdef}
	 default {
	    magic::select top cell
	    switch $command {
	       edit {$winname expand; $winname edit}
	       expand {$winname expand}
	       zoom {$winname view}
	    }
	 }
      }
   } else {
      set celluse [join $cellpath "/"]
      set curpath [$winname windowcaption]
      set curname [lindex $curpath 2]
      set curroot [lindex $curpath 0]

      switch $command {
         load {$winname load $celldef}
         default {
	    # Here: need to check first for the select cell belonging to the
	    # current loaded root cell (get the first use).
	    set defpath [list $rootdef]
	    foreach i $cellpath {
	       lappend defpath [magic::instance list celldef $i]
	    }
	    set rootpos [lsearch $defpath $curroot]
	    if {$rootpos < 0} {
	       $winname load $rootdef
	       set rootpos 0
	    }
	    # set usepath [join [lrange $cellpath $rootpos end] "/"]

	    set usepath [magic::findinstance .cellmgr.box.view \
			[.cellmgr.box.view selection]]
	    $winname select cell ${usepath}

	    switch $command {
	       edit {$winname expand; $winname edit}
	       expand {$winname expand toggle}
	       zoom {$winname findbox zoom}
	    }
	 }
      }
   }
}

# The cell manager

proc magic::makecellmanager { mgrpath } {

   toplevel ${mgrpath}
   wm withdraw ${mgrpath}
   frame ${mgrpath}.actionbar
   frame ${mgrpath}.box
   frame ${mgrpath}.target

   ttk::treeview ${mgrpath}.box.view -show tree -selectmode browse \
		-yscrollcommand "${mgrpath}.box.vert set" \
		-xscrollcommand "${mgrpath}.box.vert set" \
		-columns 1
   scrollbar ${mgrpath}.box.vert -orient vertical -command "${mgrpath}.box.view yview"

   pack ${mgrpath}.actionbar -side top -fill x
   pack ${mgrpath}.box.view -side left -fill both -expand true
   pack ${mgrpath}.box.vert -side right -fill y
   pack ${mgrpath}.box -side top -fill both -expand true
   pack ${mgrpath}.target -side top -fill x

   button ${mgrpath}.actionbar.done -text "Zoom" -command {magic::instcallback zoom}
   button ${mgrpath}.actionbar.edit -text "Edit" -command {magic::instcallback edit}
   button ${mgrpath}.actionbar.load -text "Load" -command {magic::instcallback load}
   button ${mgrpath}.actionbar.expand -text "Expand" -command \
 	   {magic::instcallback expand}

   pack ${mgrpath}.actionbar.load -side left
   pack ${mgrpath}.actionbar.edit -side left
   pack ${mgrpath}.actionbar.expand -side left
   pack ${mgrpath}.actionbar.done -side right

   label ${mgrpath}.target.name -text "Target window:"
   menubutton ${mgrpath}.target.list -text "default" \
 	   -menu ${mgrpath}.target.list.winmenu

   pack ${mgrpath}.target.name -side left -padx 2
   pack ${mgrpath}.target.list -side left

   .winmenu clone ${mgrpath}.target.list.winmenu

   #Withdraw the window when the close button is pressed
   wm protocol ${mgrpath} WM_DELETE_WINDOW  "set Opts(cellmgr) 0 ; \
		wm withdraw ${mgrpath}"

   #-------------------------------------------------
   # Callback when a treeview item is opened
   #-------------------------------------------------

   bind .cellmgr <<TreeviewOpen>> {
      set s [.cellmgr.box.view selection]
      # puts stdout "open $s"
      foreach i [.cellmgr.box.view children $s] {
	 magic::addlistset $i
         .cellmgr.box.view item $i -open false
      }
   }

   bind .cellmgr <<TreeviewClose>> {
      set s [.cellmgr.box.view selection]
      # puts stdout "close $s"
      foreach i [.cellmgr.box.view children $s] {
         foreach j [.cellmgr.box.view children $i] {
	    .cellmgr.box.view delete $j
         }
      }
   }
}

proc magic::addlistentry {parent child cinst} {
   if {$child != 0} {
      set hiername [join [list $parent $child] "/"]
      # puts stdout "listentry $hiername"
      if {[.cellmgr.box.view exists $hiername] == 0} {
         .cellmgr.box.view insert $parent end -id $hiername -text "$child"
         .cellmgr.box.view set $hiername 0 "$cinst"
      }
   }
}

proc magic::addlistset {item} {
   set cellname [.cellmgr.box.view item $item -text]
   set cd [magic::cellname list children $cellname]
   if {$cd != 0} {
      foreach i $cd {
         set inst [lindex [magic::cellname list instances $i] 0]
         magic::addlistentry $item $i $inst
      }
   }
}

#--------------------------------------------------------------
# Get the hierarchical name of the treeview item corresponding
# to the cell view in the window
#--------------------------------------------------------------

proc magic::getwindowitem {} {
   set tl [magic::cellname list window]
   if {![catch {set editstack}]} {
      set tl [concat $editstack $tl]
   }

   set pl [magic::cellname list parents [lindex $tl 0]]
   while {$pl != {}} {
      set tl [concat [lindex $pl 0] $tl]
      set pl [magic::cellname list parents [lindex $tl 0]]
   }

   set newpl ""
   set parent {}
   foreach j $tl {
      set parent $pl
      set pl "${newpl}$j"

      if {[.cellmgr.box.view exists $pl] == 0} {
         .cellmgr.box.view insert $parent end -id $pl -text "$j"
	 set inst [lindex [magic::cellname list instances $j] 0]
         .cellmgr.box.view set $pl 0 "$inst"
	 magic::addlistset $pl
      }
      .cellmgr.box.view item $pl -open true
      set newpl "${pl}/"
   }
   return $pl
}

#--------------------------------------------------------------
# The cell manager window main callback function
#--------------------------------------------------------------

proc magic::cellmanager {{option "update"}} {
   global editstack

   # Check for existence of the manager widget
   if {[catch {wm state .cellmgr}]} {
      if {$option == "create"} {
	 magic::makecellmanager .cellmgr
      } else {
	 return
      }
   } elseif { $option == "create"} {
      return
   }

   magic::suspendall

   # determine the full cell heirarchy
   set tl [magic::cellname list topcells]
   foreach i $tl {
      if {[file extension $i] == ".mag"} {
	 set nameroot [file rootname $i]
      } else {
	 set nameroot $i
      }
      set nameroot [file tail $nameroot]

      if {[.cellmgr.box.view exists $i] == 0} {
 	 .cellmgr.box.view insert {} end -id $i -text $nameroot
      }
      magic::addlistset $i
      .cellmgr.box.view item $i -open false
   }

   # Open view to current cell, generating the hierarchy as necessary.
   # Accept the first hierarchy, unless the push/pop stack has been
   # used.

   set pl [magic::getwindowitem]
   .cellmgr.box.view selection set $pl
   .cellmgr.box.view see $pl

   # Generate next level of hierarchy (not open)

   magic::addlistset $pl
   .cellmgr.box.view item $pl -open false

   magic::resumeall
}

#--------------------------------------------------------------
# Redirect and reformat Tcl output of "select" command
#--------------------------------------------------------------

proc magic::mgrselect {{sstr ""}} {
   # Make sure we have a valid option, and the cell manager exists.
   if {$sstr == ""} {
      return
   } elseif {[catch {wm state .cellmgr}]} {
      return
   }

   set savetag [magic::tag select]
   magic::tag select {}
   .cellmgr.box.view selection remove [.cellmgr.box.view selection]
   # puts stdout "selecting $sstr"

   if {[llength $sstr] == 5} {
      # sstr is "Topmost cell in the window"
      set item [magic::getwindowitem]
   } else {
      regsub -all {\[.*\]} $sstr {[^a-z]+} gsrch
      if {[catch {set item [magic::scantree .cellmgr.box.view $gsrch]}]} {
	 set item ""
      }
   }
   if {$item != ""} {
      .cellmgr.box.view item $item -open false
      .cellmgr.box.view selection set $item
      if {[wm state .cellmgr] == "normal"} { .cellmgr.box.view see $item }
      if {$sstr != ""} {
        puts stdout "Selected cell is $item ($sstr)"
      }
   }
   magic::tag select $savetag
}

#------------------------------------------------------------
# Given an item in the tree view, return a string of slash-
# separated instances that can be used by "select cell".
# This is effectively the inverse of magic::scantree
#------------------------------------------------------------

proc magic::findinstance {tree item} {
   set start [magic::getwindowitem]
   set start ${start}/
   set pathhead [string first $start $item]
   if {$pathhead >= 0} {
      set ss [expr {$pathhead -1}]
      set sb [expr {[string length $start] + $pathhead}]
      set pathtail [string range $item 0 $ss][string range $item $sb end]
      set rpath [ split [join $pathtail] "/"]
      set cinst ""
      while {$rpath != {}} {
	 set item ${start}[lindex $rpath 0]
	 set rpath [lrange $rpath 1 end]
	 if {[string length $cinst] == 0} {
	    set cinst [$tree set $item 0]
         } else {
	    set cinst ${cinst}/[$tree set $item 0]
	 }
	 set start ${item}/
      }
      return $cinst
   }
   return {}
}

#------------------------------------------------------------
# Given an item in the form of a string returned by magic's
# "select list" command (list of slash-separated instances),
# find the corresponding tree item.
#------------------------------------------------------------

proc magic::scantree {tree item} {
   set start [magic::getwindowitem]
   set rpath [ split [join $item] "/"]
   while {$rpath != {}} {
      set pathhead [lindex $rpath 0]
      set pathtail [join [lrange $rpath 1 end] "/"]
      set cellname [magic::instance list celldef $pathhead]
      set item [join [list $start [join $cellname]] "/"]
      magic::addlistset $item
      $tree set $item 0 $pathhead
      $tree item $item -open true
      set start $item
      set item $pathtail
      set rpath [ split [join $item] "/"]
   }
   $tree item $start -open false
   return $start
}

}	;# (if Tk version 8.5)

