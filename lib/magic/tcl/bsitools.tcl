######################################################################
# Visual Menu Helper Functions - Bertrand Irissou
######################################################################

###
###  Add a menu button to the Magic wrapper window for the toolkit
###
proc magic::add_menu {framename toolname button_text } {
   menubutton ${framename}.titlebar.mbuttons.${toolname} \
		-text $button_text \
		-relief raised \
		-menu ${framename}.titlebar.mbuttons.${toolname}.toolmenu \
		-borderwidth 2

   menu ${framename}.titlebar.mbuttons.${toolname}.toolmenu -tearoff 0
   pack ${framename}.titlebar.mbuttons.${toolname} -side left
}

###
###  Add a command item to the toolkit menu
###
proc magic::add_menu_command {framename toolname button_text command} {
   set m ${framename}.titlebar.mbuttons.${toolname}.toolmenu
   $m add command -label "$button_text" -command $command 
}

###
### Add a separator to a menu
###
proc magic::add_menu_separator {framename toolname} {
   set m ${framename}.titlebar.mbuttons.${toolname}.toolmenu
   $m add separator
}

