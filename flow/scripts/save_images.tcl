gui::save_display_controls

set height [[[ord::get_db_block] getBBox] getDY]
set height [ord::dbu_to_microns $height]
set resolution [expr $height / 1000]

# Show the drc markers (if any)
if {[file exists $::env(REPORTS_DIR)/5_route_drc.rpt] == 1} {
    gui::load_drc $::env(REPORTS_DIR)/5_route_drc.rpt
}

gui::clear_selections

# Setup initial visibility to avoid any previous settings
gui::set_display_controls "*" visible false
gui::set_display_controls "Layers/*" visible true
gui::set_display_controls "Nets/*" visible true
gui::set_display_controls "Instances/*" visible false
gui::set_display_controls "Instances/StdCells" visible true
gui::set_display_controls "Instances/Macros" visible true
gui::set_display_controls "Instances/Pads" visible true
gui::set_display_controls "Pin Markers" visible true
gui::set_display_controls "Misc/Instance names" visible true
gui::set_display_controls "Misc/Scale bar" visible true
gui::set_display_controls "Misc/Highlight selected" visible true
gui::set_display_controls "Misc/Detailed view" visible true

# The routing view
save_image -resolution $resolution $::env(REPORTS_DIR)/final.webp

# The placement view without routing
gui::set_display_controls "Layers/*" visible false
save_image -resolution $resolution $::env(REPORTS_DIR)/final_placement.webp

# The clock view: all clock nets and buffers
select -name "clk*" -type Inst
select -name "clk*" -type Net
save_image -resolution $resolution $::env(REPORTS_DIR)/final_clocks.webp
gui::clear_selections

# The resizer view: all instances created by the resizer grouped
select -name "hold*" -type Inst -highlight 0       ;# green
select -name "input*" -type Inst -highlight 1      ;# yellow
select -name "output*" -type Inst -highlight 2     ;# cyan
select -name "repeater*" -type Inst -highlight 3   ;# magenta
select -name "rebuffer*" -type Inst -highlight 4   ;# red
select -name "split*" -type Inst -highlight 5      ;# dark green
save_image -resolution $resolution $::env(REPORTS_DIR)/final_resizer.webp
for {set i 0} {$i <= 5} {incr i} {
    gui::clear_highlights $i
}
gui::clear_selections

gui::restore_display_controls
