import os

# routing pitch for M4, M5 and M6 tied to placement grid at 2.16
# therefore, the optimal placement and Element size should be multiple of 2.16
# set grid x and y
placement_grid_x     = 2.16
placement_grid_y     = 2.16

# number of Elements in row and column, can be control by user via environment variable 
# MOCK_ARRAY_TABLE (rows, cols, width, height, pitch_x, pitch_y)
#  rows, cols       - number of Element in rows, cols
#  width, height    - width and height of each Element
#  pitch_x, pitch_y - placement pitch for each Element, in x and y direction
# specification are in unit of placement grid
rows, cols, ce_x, ce_y, pitch_x, pitch_y = map(int, os.environ.get("MOCK_ARRAY_TABLE").split())

# Element size is set to multiple of placement grid above
ce_width    = ce_x * placement_grid_x
ce_height   = ce_y * placement_grid_y

# top level core offset 
margin_x    = placement_grid_x
margin_y    = placement_grid_y

# Element core margin
ce_margin_x = placement_grid_x * 0.5
ce_margin_y = placement_grid_y * 0.5

# top level core and die size
core_width  = ((placement_grid_x * pitch_x) * (cols + 1)) + (ce_width  * cols)
core_height = ((placement_grid_y * pitch_y) * (rows + 1)) + (ce_height * rows)

die_width  = core_width  + (margin_x * 2)
die_height = core_height + (margin_y * 2)
