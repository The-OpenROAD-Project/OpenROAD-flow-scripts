import os

# Routing pitches for relevant metal layers.
#  For x, this is M5; for y, this is M4.
#  Pitches are specified in OpenROAD-flow-scripts/flow/platforms/asap7/lef/asap7_tech_1x_201209.lef.
#  For asap7, x and y pitch is the same.
#
# make_tracks M5 -x_offset 0.012 -x_pitch 0.048 -y_offset 0.012 -y_pitch 0.048
#
# the macro needs to be on a multiple of the track pattern
placement_grid_x = 0.048 * int(os.environ.get("MOCK_ARRAY_SCALE"))
placement_grid_y = 0.048 * int(os.environ.get("MOCK_ARRAY_SCALE"))

# number of Elements in row and column, can be control by user via environment variable
# MOCK_ARRAY_TABLE (rows, cols, width, height, pitch_x, pitch_y)
#  rows, cols       - number of Element in rows, cols
#  width, height    - width and height of each Element
#
# When the pitch is equal to the width/height, we have routing by abutment
# https://en.wikipedia.org/wiki/Pitch#Linear_measurement
#
#  pitch_x, pitch_y - placement pitch for each Element, in x and y direction
# specification are in unit of placement grid
rows, cols, ce_x, ce_y, pitch_x, pitch_y = map(
    int, os.environ.get("MOCK_ARRAY_TABLE").split()
)

# Element size is set to multiple of placement grid above
ce_width = ce_x * placement_grid_x
ce_height = ce_y * placement_grid_y

# top level core offset
margin_x = placement_grid_x
margin_y = placement_grid_y

# Element core margin
ce_margin_x = placement_grid_x * 0.5
ce_margin_y = placement_grid_y * 0.5

# PDN problems if it is smaller. Not investigated.
array_spacing_x = margin_x * 2
array_spacing_y = margin_y * 2

array_offset_x = array_spacing_x + margin_x
array_offset_y = array_spacing_y + margin_y

# top level core and die size
core_width = (
    2 * array_spacing_x + ((placement_grid_x * pitch_x) * (cols - 1)) + ce_width
)
core_height = (
    2 * array_spacing_y + ((placement_grid_y * pitch_y) * (rows - 1)) + ce_height
)

die_width = core_width + (margin_x * 2)
die_height = core_height + (margin_y * 2)
