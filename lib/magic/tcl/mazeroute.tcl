#-----------------------------------------------------------------
# mazeroute.tcl
#-----------------------------------------------------------------
# Defines procedure "mazeroute <netlist>", requiring a .net file as
# an argument.  Attempts a single-pass maze route of the contents
# of the netlist.
#-----------------------------------------------------------------

global Opts

proc mazeroute {netfile} {
   if [catch {open  $netfile r} fnet] {
      set netname [file rootname $netfile]
      if [catch {open  ${netfile}.net r} fnet] {
         puts stderr "Can't read netlist file $netfile"
	 return 1;
      }
   }
   # 1st line of the netlist file is throw-away
   gets $fnet line

   set destnet {}
   while {[gets $fnet line] >= 0} {
      if {$line == ""} {
	 set destnet {}
      } elseif {$destnet == {}} {
	 set destnet $line
      } else {
	 set startnet $line
	 iroute route -dlabel $destnet -slabel $startnet -timeout 3
	 set destnet $startnet
      }
   }
}

#-----------------------------------------------------------------
# Interactive mazerouter GUI.  Shows a list of nets from the
# selected netlist.  Allows one to select the order of routing,
# route individual nets, rip up individual nets, etc.
#
# This GUI more or less replaces the "specialopen netlist" window.
#-----------------------------------------------------------------

proc genmazehelper {} {
   global Opts
   set Opts(preproutes) 0
   set Opts(fenced) 0

   if {![catch {wm deiconify .mazehelper ; raise .mazehelper}]} {return}

   toplevel .mazehelper
   wm protocol .mazehelper WM_DELETE_WINDOW {destroy .mazehelper}

   frame .mazehelper.mazemenu
   frame .mazehelper.unrouted
   frame .mazehelper.transfer
   frame .mazehelper.routed

   pack .mazehelper.mazemenu -side top -anchor w

   button .mazehelper.mazemenu.load -text "Load" -command {loadnetlist}
   label .mazehelper.mazemenu.netlist -text "(no netlist loaded)"
   button .mazehelper.mazemenu.fence -text "Fence" -command {buildfence}
   button .mazehelper.mazemenu.sort -text "Sort" -command {sortnets}
   button .mazehelper.mazemenu.params -text "Params" -command {genmazeparams}

   pack .mazehelper.mazemenu.load -side left
   pack .mazehelper.mazemenu.netlist -side left -fill x -expand true
   pack .mazehelper.mazemenu.fence -side left
   pack .mazehelper.mazemenu.sort -side left
   pack .mazehelper.mazemenu.params -side left

   label .mazehelper.unrouted.title -text "Unrouted:"
   listbox .mazehelper.unrouted.contents -background white -selectmode extended

   label .mazehelper.routed.title -text "Routed:"
   listbox .mazehelper.routed.contents -background white -selectmode extended

   button .mazehelper.transfer.ripup -text "<--" -command {ripupnet}
   button .mazehelper.transfer.route -text "-->" -command {routenet}

   pack .mazehelper.transfer.ripup -side top
   pack .mazehelper.transfer.route -side top

   pack .mazehelper.unrouted.title -side top
   pack .mazehelper.unrouted.contents -side top -fill both -expand true

   pack .mazehelper.routed.title -side top
   pack .mazehelper.routed.contents -side top -fill both -expand true

   pack .mazehelper.unrouted -side left -fill both -expand true
   pack .mazehelper.transfer -side left
   pack .mazehelper.routed -side left -fill both -expand true

}

#-----------------------------------------------------------------
# Route parameters (to be completed)
#-----------------------------------------------------------------

proc genmazeparams {} {
   global Opts

   if {![catch {wm deiconify .mazeparams ; raise .mazeparams}]} {return}

   toplevel .mazeparams
   wm protocol .mazeparams WM_DELETE_WINDOW {destroy .mazeparams}

   set routeparams {layer active width hCost vCost jogCost hintCost overCost}
   set curRparams [iroute layers -list]

   set contparams {contact active width cost}
   set curCparams [iroute contact -list]

   set k 0
   label .mazeparams.t1 -text "Layer"
   label .mazeparams.t2 -text "Active"
   label .mazeparams.t3 -text "Width"
   label .mazeparams.t4 -text "Horizontal Cost"
   label .mazeparams.t5 -text "Vertical Cost"
   label .mazeparams.t6 -text "Jog Cost"
   label .mazeparams.t7 -text "Hint Cost"
   label .mazeparams.t8 -text "Overroute Cost"
   foreach layer $curRparams {
       incr k
       label .mazeparams.r${k}0 -text [lindex $layer 0]
       checkbox .mazeparams.r${k}1
       for {set j 2} {$j < 8} {incr j} { 
          entry .mazeparams.r${k}${j} -text [lindex $contact $j]
       }
   }
   incr k
   label .mazeparams.t1 -text "Contact"
   label .mazeparams.t2 -text "Active"
   label .mazeparams.t3 -text "Size"
   label .mazeparams.t4 -text "Cost"
   foreach contact $curCparams {
       incr k
       label .mazeparams.r${k}0 -text [lindex $contact 0]
       checkbox .mazeparams.r${k}1
       for {set j 2} {$j < 4} {incr j} { 
          entry .mazeparams.r${k}${j} -text [lindex $contact $j]
       }
   }
}

#-----------------------------------------------------------------
# Load a magic-style netlist
#-----------------------------------------------------------------

proc loadnetlist { {netfile {}} } {
   global Opts

   if {$netfile == {}} {
      set netfile [ tk_getOpenFile -filetypes \
	   {{NET {.net {.net}}} {"All files" {*}}}]
   }
   
   if [catch {open  $netfile r} fnet] {
      set netname [file rootname $netfile]
      if [catch {open  ${netfile}.net r} fnet] {
         puts stderr "Can't read netlist file $netfile"
	 return 1;
      }
   }

   # Clear out the listbox contents.
   .mazehelper.unrouted.contents delete 0 end
   .mazehelper.routed.contents delete 0 end
   set $Opts(preproutes) 0

   # 1st line of the netlist file is throw-away
   gets $fnet line

   set currentnet {}
   while {[gets $fnet line] >= 0} {
      if {$line == ""} {
	 if {[llength $currentnet] > 0} {
	    .mazehelper.unrouted.contents insert end $currentnet
            set currentnet {}
	 }
      } else {
	 lappend currentnet $line
      }
   }

   # Make sure final net gets added. . .

   if {[llength $currentnet] > 0} {
     .mazehelper.unrouted.contents insert end $currentnet
   }

   .mazehelper.mazemenu.netlist configure -text [file tail $netfile]

   # Verify all unrouted nets (check if any are already routed)

   .mazehelper.unrouted.contents select set 0 end
   verifynet unrouted quiet
   .mazehelper.unrouted.contents select clear 0 end

   close $fnet
}

#-----------------------------------------------------------------
# Place a contact on each network endpoint.  Aids in preventing
# the router from routing over pins by blocking access to the
# space over every pin that will be routed to.
#
# Changed 9/25/06---contact only in subcells.
# Changed 9/26/06---use obstruction layer, not contacts
#-----------------------------------------------------------------

proc obstructendpoints {} {
   global Opts
   set Opts(preproutes) 1

   box values 0 0 0 0
   foreach net [.mazehelper.unrouted.contents get 0 end] {
      foreach endpoint $net {
	 set layer [goto $endpoint]
	 # Ignore via layers;  these are already obstructed for our purposes.
	 if {[string first metal $layer] == 0} {
	    set lnum [string range $layer 5 end]
	    incr lnum
	    set obslayer obsm${lnum}
	    set viasize [tech drc width m${lnum}c]

	    box size ${viasize}i ${viasize}i
	    paint $obslayer
	 }
      }
   }
}

#-----------------------------------------------------------------
# Free the obstruction above endpoints for each endpoint in the
# current network.
#-----------------------------------------------------------------

proc freeendpoints {net} {
   box values 0 0 0 0
   foreach endpoint $net {
      if {[string first / $endpoint] > 0} {
	 set layer [goto $endpoint]
	 if {[string first metal $layer] == 0} {
	    set lnum [string range $layer 5 end]
	    incr lnum
	    set obslayer obsm${lnum}
	    set viasize [tech drc width m${lnum}c]
	    box size ${viasize}i ${viasize}i
	    erase $obslayer
	 }
      }
   }
}

#-----------------------------------------------------------------
# Free the obstruction above each pin in the current network.
#-----------------------------------------------------------------

proc freepinobstructions {net} {
   box values 0 0 0 0
   foreach endpoint $net {
      if {[string first / $endpoint] <= 0} {
	 set layer [goto $endpoint]
	 if {[string first metal $layer] == 0} {
	    set lnum [string range $layer 5 end]
	    incr lnum
	    set obslayer obsm${lnum}
	    set viasize [tech drc width m${lnum}c]
	    box size ${viasize}i ${viasize}i
	    erase $obslayer
	 }
      }
   }
}

#-----------------------------------------------------------------
# Sorting routine for two pins---sort by leftmost pin position.
#-----------------------------------------------------------------

proc sortpinslr {pina pinb} {
   goto $pina
   set xa [lindex [box values] 0]
   goto $pinb
   set xb [lindex [box values] 0]
   if {$xa > $xb} {return 1} else {return -1}
}

#-----------------------------------------------------------------
# Sort a net so that the endpoints are ordered left to right
#-----------------------------------------------------------------

proc sortnetslr {} {
   set allnets [.mazehelper.unrouted.contents get 0 end]
   .mazehelper.unrouted.contents delete 0 end
   magic::suspendall
   foreach net $allnets {
      set netafter [lsort -command sortpinslr $net]
      .mazehelper.unrouted.contents insert 0 $netafter
   }
   magic::resumeall
}

#-----------------------------------------------------------------
# Procedure to find the leftmost point of a net.
#-----------------------------------------------------------------

proc getnetleft {net} {
   foreach endpoint $net {
      set layer [goto $endpoint]
      set xtest [lindex [box values] 0]
      if [catch {if {$xtest < $xmin} {set xmin $xtest}}] {set xmin $xtest}
   }
   return $xmin
}

#-----------------------------------------------------------------
# Procedure to compare nets according to the number of nodes
#-----------------------------------------------------------------

proc routecomp {a b} {
   set alen [llength $a]
   set blen [llength $b]
   if {$alen > $blen} {
      return -1
   } elseif {$alen < $blen} {
      return 1
   } else {
      # Sort by leftmost route.
      set aleft [getnetleft $a]
      set bleft [getnetleft $b]
      if {$aleft > $bleft} {return 1} else {return -1}
   }
}

#-----------------------------------------------------------------
# Sort unrouted nets from longest to shortest
#-----------------------------------------------------------------

proc sortnets {} {
   set listbefore [.mazehelper.unrouted.contents get 0 end]
   .mazehelper.unrouted.contents delete 0 end
   magic::suspendall
   set listafter [lsort -command routecomp $listbefore]
   foreach net $listafter {
      .mazehelper.unrouted.contents insert end $net
   }
   magic::resumeall
}

#-----------------------------------------------------------------
# Disassemble all networks into 2-point routes
#-----------------------------------------------------------------

proc disassemble {} {
   set allnets [.mazehelper.unrouted.contents get 0 end]
   .mazehelper.unrouted.contents delete 0 end
   foreach net $allnets {
      for {set i 1} {$i < [llength $net]} {incr i} {
         set j $i
         incr j -1
         set newnet [lrange $net $j $i]
	 .mazehelper.unrouted.contents insert end $newnet
      }
   }
}

#-----------------------------------------------------------------
# Fence the area around the cell
#-----------------------------------------------------------------

proc buildfence {} {
   global Opts

   pushbox 
   if {$Opts(fenced) == 0} {
      select top cell
      box grow c 1i
      set ibounds [box values]
      set illx [lindex $ibounds 0]
      set illy [lindex $ibounds 1]
      set iurx [lindex $ibounds 2]
      set iury [lindex $ibounds 3]
      box grow c 10i
      set obounds [box values]
      set ollx [lindex $obounds 0]
      set olly [lindex $obounds 1]
      set ourx [lindex $obounds 2]
      set oury [lindex $obounds 3]
      box values ${ollx}i ${iury}i ${ourx}i ${oury}i
      paint fence
      box values ${ollx}i ${olly}i ${ourx}i ${illy}i
      paint fence
      box values ${ollx}i ${olly}i ${illx}i ${oury}i
      paint fence
      box values ${iurx}i ${olly}i ${ourx}i ${oury}i
      paint fence
      set Opts(fenced) 1
   } else {
      select top cell
      box grow c 12i
      erase fence
      set Opts(fenced) 0
   }
   popbox
}

#-----------------------------------------------------------------
# Load a list of failed routes
#-----------------------------------------------------------------

proc loadfailed { {netfile {}} } {

   if {$netfile == {}} {
      set netfile [ tk_getOpenFile -filetypes \
	   {{FAILED {.failed {.failed}}} {"All files" {*}}}]
   }
   
   if [catch {open  $netfile r} fnet] {
      set netname [file rootname $netfile]
      if [catch {open  ${netfile}.failed r} fnet] {
         puts stderr "Can't read file of failed routes $netfile"
	 return 1;
      }
   }

   # Clear out the listbox contents.
   .mazehelper.unrouted.contents delete 0 end
   .mazehelper.routed.contents delete 0 end


   # Read each line into the "unrouted" list.
   while {[gets $fnet line] >= 0} {
      .mazehelper.unrouted.contents insert end $line
   }

   .mazehelper.mazemenu.netlist configure -text $netfile

   close $fnet
}

#-----------------------------------------------------------------
# Save the list of failed routes
#-----------------------------------------------------------------

proc savefailed { {netfile {}} } {

   set netfile [.mazehelper.mazemenu.netlist cget -text]
   if {$netfile == {}} {
      set netfile [ tk_getOpenFile -filetypes \
	   {{FAILED {.failed {.failed}}} {"All files" {*}}}]
   } else {
      set netname [file rootname $netfile]
      set netname ${netname}.failed
   }
   
   if [catch {open  $netfile w} fnet] {
      set netname [file rootname $netfile]
      if [catch {open  ${netfile}.failed w} fnet] {
         puts stderr "Can't write file of failed routes $netfile"
	 return 1;
      }
   }

   foreach net [.mazehelper.unrouted.contents get 0 end] {
      puts $fnet "$net"
   }

   close $fnet
}

#-----------------------------------------------------------------
# Get the selected network and maze route it
#-----------------------------------------------------------------

proc routenet {} {
   global Opts

   set drcstate [drc status]
   drc off

   # Prepare routes by placing an obstruction layer on each pin
   # Only do this if we have defined obstruction layers!

   if {$Opts(preproutes) == 0} {
      set allLayers [tech layers *]
      if {[lsearch $allLayers obs*] >= 0} {
         magic::suspendall
         obstructendpoints
         magic::resumeall
      }
   }

   set unroutable {}
   set sellist [.mazehelper.unrouted.contents curselection]
   set startidx [lindex $sellist 0]
   while {[llength $sellist] > 0} {
      set cidx [lindex $sellist 0]
      set rlist [.mazehelper.unrouted.contents get $cidx]
      if {$Opts(preproutes) == 1} {freeendpoints $rlist}
      for {set i 1} {$i < [llength $rlist]} {incr i} {
         set j $i
         incr j -1
         set startnet [lindex $rlist $j]
         set destnet [lindex $rlist $i]
         set rresult [iroute route -slabel $startnet -dlabel $destnet -timeout 3]

	 # break on any failure
	 if {$rresult != "Route success" && \
		$rresult != "Route best before interrupt" && \
		$rresult != "Route already routed"} {
	    break
	 } else {
	    set rresult "success"
	 }
      }

      .mazehelper.unrouted.contents delete $cidx $cidx
      if {$rresult == "success"} {
         .mazehelper.routed.contents insert end $rlist
      } else {
	 # scramble list; we may have better luck routing in a different order
	 set rfirst [lindex $rlist 0]
	 set rlist [lrange $rlist 1 end]
	 lappend rlist $rfirst
	 lappend unroutable $rlist
      }
      set sellist [.mazehelper.unrouted.contents curselection]
      if {$Opts(preproutes) == 1} {freepinobstructions $rlist}
   }
   .mazehelper.unrouted.contents selection set $startidx
   foreach badnet $unroutable {
      .mazehelper.unrouted.contents insert $startidx $badnet
   }

   if {$drcstate == 1} {drc on}
}

#-----------------------------------------------------------------
# Get the selected network and remove it
#-----------------------------------------------------------------

proc ripupnet {} {
   set sellist [.mazehelper.routed.contents curselection]
   set startidx [lindex $sellist 0]
   while {[llength $sellist] > 0} {
      set cidx [lindex $sellist 0]
      set rlist [.mazehelper.routed.contents get $cidx]
      set netname [lindex $rlist 0]
      select clear
      set layertype [goto $netname]
      select more box ${layertype},connect	;# chunk
      select more box ${layertype},connect	;# region
      select more box ${layertype},connect	;# net
      delete

      .mazehelper.routed.contents delete $cidx $cidx
      .mazehelper.unrouted.contents insert end $rlist

      set sellist [.mazehelper.routed.contents curselection]
   }
   .mazehelper.routed.contents selection set $startidx
}

#-----------------------------------------------------------------
# Get the selected network and verify the route
#-----------------------------------------------------------------

proc verifynet { {column routed} {infolevel verbose} } {
   set sellist [.mazehelper.${column}.contents curselection]
   set startidx [lindex $sellist 0]
   magic::suspendall
   while {$sellist != {}} {
      set cidx [lindex $sellist 0]
      set errors 0
      set rlist [.mazehelper.${column}.contents get $cidx]
      set netname [lindex $rlist 0]
      select clear
      set layertype [goto $netname]
      if {$layertype == {}} {
	 incr errors
      } else {
         select more box ${layertype},connect	;# chunk
         select more box ${layertype},connect	;# region
         select more box ${layertype},connect	;# net
         set sellist [what -list]
         set sellabels [lindex $sellist 1]
         set labellist {}
         foreach label $sellabels {
	    set labtext [lindex $label 0]
	    set labinst [lindex $label 2]
	    if {$labinst == {}} {
	       set labname ${labtext}
	    } else {
	       set labname ${labinst}/${labtext}
	    }
	    lappend labellist $labname
         }

         # Backslash substitute brackets prior to using lsearch, or this won't work
         # on such labels.  Hopefully this won't confuse things. . .
         set newrlist [string map {\[ < \] >} $rlist]
         set newlabellist [string map {\[ < \] >} $labellist]

         # Compare labellist to rlist---they are supposed to be the same!

         foreach entry $newlabellist {
	    if {[lsearch $newrlist $entry] < 0} {
	       if {"$infolevel" == "verbose"} {
	          puts stderr "ERROR:  Net entry $entry in layout is not in the netlist!"
	       }
	       incr errors
	    }
         }
         foreach entry $newrlist {
	    if {[lsearch $newlabellist $entry] < 0} {
	       if {"$infolevel" == "verbose"} {
	          puts stderr "ERROR:  Net entry $entry in netlist is not in the layout!"
	       }
	       incr errors
	    }
         }
         if {$errors == 0 && "$infolevel" == "verbose"} {puts stdout "VERIFIED"}
      }

      # If column is "routed" and we're not verified, move to "unrouted".
      # If column is "unrouted" and we're verified, move to "routed".

      if {"$column" == "routed"} {
         if {$errors > 0} {
            .mazehelper.routed.contents delete $cidx $cidx
            .mazehelper.unrouted.contents insert end $rlist
         } else {
	    .mazehelper.routed.contents selection clear $cidx
	    incr startidx
	 }
      } else {
         if {$errors == 0} {
	    .mazehelper.unrouted.contents delete $cidx $cidx
	    .mazehelper.routed.contents insert end $rlist
         } else {
	    .mazehelper.unrouted.contents selection clear $cidx
	    incr startidx
	 }
      }

      # Get the selection list again
      set sellist [.mazehelper.${column}.contents curselection]
   }
   magic::resumeall
   .mazehelper.${column}.contents selection set $startidx
}

#-----------------------------------------------------------------
# Reset the maze helper, deleting all routes.
#-----------------------------------------------------------------

proc resetmazehelper {} {
   .mazehelper.routed.contents delete 0 end
   .mazehelper.unrouted.contents delete 0 end
}

#-----------------------------------------------------------------
# Add the "mazehelper" function to the Magic Options
#-----------------------------------------------------------------

proc addmazehelper {optmenu} {
   global Opts
   $optmenu add check -label "Maze Router" -variable Opts(mazeroute) -command \
	{if {$Opts(mazeroute) == 0} {destroy .mazehelper} else {genmazehelper}}
}

#-----------------------------------------------------------------

