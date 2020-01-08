#
# The long-awaited Technology File Builder Wizard
#

# Needs BLT to build tab windows
package require BLT

toplevel .techwizard
blt::tabset .techwizard.parts -relief sunken -borderwidth 2

magic::windowcaption off
magic::windowscrollbars off

frame .techwizard.parts.layers
frame .techwizard.parts.drc

magic::openwindow tech_layers .techwizard.parts.layers.layout
magic::openwindow drc_rules .techwizard.parts.drc.layout

frame .techwizard.parts.layers.funcs
label .techwizard.parts.layers.funcs.prompt -text "Add:"
label .techwizard.parts.layers.funcs.prompt2 -text "Plane:"
entry .techwizard.parts.layers.funcs.lname
menubutton .techwizard.parts.layers.funcs.planes -text "(choose one)" \
	-relief groove
pack .techwizard.parts.layers.funcs.prompt -side left -padx 5
pack .techwizard.parts.layers.funcs.lname -side left -expand true -fill x
pack .techwizard.parts.layers.funcs.prompt2 -side left -padx 5
pack .techwizard.parts.layers.funcs.planes -side left -pady 5

pack .techwizard.parts.layers.layout -side top -expand true -fill both
pack .techwizard.parts.layers.funcs -side top -fill x

frame .techwizard.parts.drc.funcs
button .techwizard.parts.drc.funcs.last -text "Last"
button .techwizard.parts.drc.funcs.next -text "Next"
pack .techwizard.parts.drc.funcs.last -side left
pack .techwizard.parts.drc.funcs.next -side left
pack .techwizard.parts.drc.layout -side top -expand true -fill both
pack .techwizard.parts.drc.funcs -side top -fill x

frame .techwizard.parts.tech
frame .techwizard.parts.tech.tinfo
label .techwizard.parts.tech.tinfo.tname -text "Technology name:" \
	-foreground sienna4
entry .techwizard.parts.tech.tinfo.tentry -width 50
bind .techwizard.parts.tech.tinfo.tentry <Return> { \
	    .techwizard.parts.tech.tinfo.tset configure -text \
	    [.techwizard.parts.tech.tinfo.tentry get]; \
	    pack forget .techwizard.parts.tech.tinfo.tentry; \
	}
button .techwizard.parts.tech.tinfo.tset -text "[magic::tech name]" \
	-relief groove \
	-foreground green4 \
	-command { \
	    pack .techwizard.parts.tech.tinfo.tentry -side left -expand true; \
	}
pack .techwizard.parts.tech.tinfo.tname -side left
pack .techwizard.parts.tech.tinfo.tset -side left
pack .techwizard.parts.tech.tinfo -side top

frame .techwizard.parts.planes
::set pnames [magic::tech planes]
::set j 0
foreach i $pnames {
   entry .techwizard.parts.planes.e$i -width 50
   bind .techwizard.parts.planes.e$i <Return> \
	".techwizard.parts.planes.p$i configure -text \
	[.techwizard.parts.planes.e$i get]; \
	::grid forget .techwizard.parts.planes.e$i"
   button .techwizard.parts.planes.p$i -text "$i" \
	-foreground green4 \
	-relief groove \
	-command "::grid .techwizard.parts.planes.e$i -row $j -column 1 -sticky news"
   ::grid .techwizard.parts.planes.p$i -row $j -column 0 -sticky news
   incr j
}
::unset pnames
::unset j

.techwizard.parts configure -tiers 2
.techwizard.parts insert end "tech" "planes" "layers" "connect" "compose" \
	"cifinput" "cifoutput" "extract" "drc" \
	"wiring" "router" "plowing" "plot"

.techwizard.parts tab configure "layers" -window .techwizard.parts.layers -fill both
.techwizard.parts tab configure "drc" -window .techwizard.parts.drc -fill both
.techwizard.parts tab configure "tech" -window .techwizard.parts.tech
.techwizard.parts tab configure "planes" -window .techwizard.parts.planes

# Add styles to layout for selection

::set i 0
::set j 0
::set k 50
while { $k <= 127 } {
   ::set rx [expr $i + 8]
   ::set ry [expr $j + 8]
   .techwizard.parts.layers.layout element add rect style$k $k $i $j $rx $ry
   incr k
   incr i 10
   if {$i >= 80} {::set i 0; incr j 10}
}
catch {.techwizard.parts.layers.layout box -100 -10 90 90}
catch {.techwizard.parts.layers.layout findbox zoom}
catch {.techwizard.parts.layers.layout box -100 -10 -10 90}

.techwizard.parts.layers.layout element add text ltitle black 40 85 "Layer Styles"

# To do:  Add all existing layers and draw their styles

pack .techwizard.parts -fill both -expand true
wm geometry .techwizard 800x500
