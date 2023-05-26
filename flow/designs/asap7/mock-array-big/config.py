import os

# number of Elements in row and column, user can set via environment variable
rows = int(os.environ.get("MOCK_ARRAY_HEIGHT"))
cols = int(os.environ.get("MOCK_ARRAY_WIDTH"))

# Element placement pitch can be control by user
pitch_scale = int(os.environ.get("MOCK_ARRAY_PITCH_SCALE"))

if pitch_scale < 1:
  raise Exception("Element placement pitch must be greater than 1")

# Routing pitches for relevant metal layers.
#  For x, this is M5; for y, this is M4.
#  Pitches are specified in OpenROAD-flow-scripts/flow/platforms/asap7/lef/asap7_tech_1x_201209.lef.
#  For asap7, x and y pitch is the same.
#
# make_tracks M5 -x_offset 0.012 -x_pitch 0.048 -y_offset 0.012 -y_pitch 0.048
#
# the macro needs to be on a multiple of the track pattern
routing_pitch = 0.048

placement_grid_x = routing_pitch
placement_grid_y = routing_pitch

# historically pitch_scale 2 was ca 13 um
ce_width    = int(3 * 2.16 / placement_grid_x) * placement_grid_x * pitch_scale
ce_height   = int(3 * 2.16 / placement_grid_y) * placement_grid_y * pitch_scale
ce_margin_x = placement_grid_x * 8
ce_margin_y = placement_grid_y * 8

# top level core offset 
margin_x    = int(2.16 / placement_grid_x) * placement_grid_x
margin_y    = int(2.16 / placement_grid_y) * placement_grid_y

channel = 12 # int(os.environ.get("MACRO_PLACE_CHANNEL").split()[0])

# Element placement, can be controlled by user
ce_pitch_x  = ce_width + int((channel * 2) / placement_grid_x) * placement_grid_x
ce_pitch_y  = ce_height + int((channel * 2) / placement_grid_y) * placement_grid_y

# top level core size
core_width  = ce_pitch_x * cols + ce_width
core_height = ce_pitch_y * rows + ce_height

die_width = core_width + (2 * margin_x)
die_height = core_height + (2 * margin_y)
