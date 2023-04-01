# see flow/platforms/asap7/openRoad/pdn/grid_strategy-M2-M5-M7.tcl
import os

rows = int(os.environ.get("MOCK_ARRAY_HEIGHT", "8"))
cols = int(os.environ.get("MOCK_ARRAY_WIDTH", "8"))
pitch_scale = int(os.environ.get("MOCK_ARRAY_PITCH_SCALE", "2"))

# Routing pitches for relevant metal layers.
#  For x, this is M5; for y, this is M4.
#  Pitches are specified in OpenROAD-flow-scripts/flow/platforms/asap7/lef/asap7_tech_1x_201209.lef.
#  For asap7, x and y pitch is the same.
routing_pitch = 0.048

# 0.048 * 125 = 6, which is a nice round number to work with
pitch = routing_pitch * 125 * pitch_scale
margin = routing_pitch * 125 * 2
core_offset_x = margin
core_offset_y = margin
die_offset_x = core_offset_x + margin
die_offset_y = core_offset_y + margin

pitch_and_margin = pitch + margin

core_width = cols * pitch_and_margin + core_offset_x
core_height = rows * pitch_and_margin + core_offset_y
die_width = core_width + margin * 2
die_height = core_height + margin * 2
