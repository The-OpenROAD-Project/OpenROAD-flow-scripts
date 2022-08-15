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
gui::set_display_controls "Instances/StdCells/*" visible true
gui::set_display_controls "Instances/Macro" visible true
gui::set_display_controls "Instances/Pads/*" visible true
gui::set_display_controls "Instances/Physical/*" visible true
gui::set_display_controls "Pin Markers" visible true
gui::set_display_controls "Misc/Instances/names" visible true
gui::set_display_controls "Misc/Scale bar" visible true
gui::set_display_controls "Misc/Highlight selected" visible true
gui::set_display_controls "Misc/Detailed view" visible true

# The routing view
save_image -resolution $resolution $::env(REPORTS_DIR)/final_routing.webp

# The placement view without routing
gui::set_display_controls "Layers/*" visible false
gui::set_display_controls "Instances/Physical/*" visible false
save_image -resolution $resolution $::env(REPORTS_DIR)/final_placement.webp

if {[info exist ::env(PWR_NETS_VOLTAGES)]} {
#  gui::set_display_controls "Heat Maps/IR Drop" visible true
#  gui::set_heatmap IRDrop Layer $::env(IR_DROP_LAYER)
#  save_image -resolution $resolution $::env(REPORTS_DIR)/final_ir_drop.webp
#  gui::set_display_controls "Heat Maps/IR Drop" visible false
}

# The clock view: all clock nets and buffers
gui::set_display_controls "Layers/*" visible true
gui::set_display_controls "Nets/*" visible false
gui::set_display_controls "Nets/Clock" visible true
gui::set_display_controls "Instances/*" visible false
gui::set_display_controls "Instances/StdCells/Clock tree/*" visible true
select -name "clk*" -type Inst
save_image -resolution $resolution $::env(REPORTS_DIR)/final_clocks.webp
gui::clear_selections

# The resizer view: all instances created by the resizer grouped
gui::set_display_controls "Layers/*" visible false
gui::set_display_controls "Instances/*" visible true
gui::set_display_controls "Instances/Physical/*" visible false
select -name "hold*" -type Inst -highlight 0       ;# green
select -name "input*" -type Inst -highlight 1      ;# yellow
select -name "output*" -type Inst -highlight 1
select -name "repeater*" -type Inst -highlight 3   ;# magenta
select -name "fanout*" -type Inst -highlight 3
select -name "load_slew*" -type Inst -highlight 3
select -name "max_cap*" -type Inst -highlight 3
select -name "max_length*" -type Inst -highlight 3
select -name "wire*" -type Inst -highlight 3
select -name "rebuffer*" -type Inst -highlight 4   ;# red
select -name "split*" -type Inst -highlight 5      ;# dark green

save_image -resolution $resolution $::env(REPORTS_DIR)/final_resizer.webp
for {set i 0} {$i <= 5} {incr i} {
    gui::clear_highlights $i
}
gui::clear_selections

gui::restore_display_controls
