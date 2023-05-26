import os

# number of Elements in row and column, user can set via environment variable
rows = int(os.environ.get("MOCK_ARRAY_HEIGHT"))
cols = int(os.environ.get("MOCK_ARRAY_WIDTH"))

# Element placement pitch can be control by user
pitch_scale = int(os.environ.get("MOCK_ARRAY_PITCH_SCALE"))

if pitch_scale < 1:
  raise Exception("Element placement pitch must be greater than 1")

# routing pitch for M4, M5 and M6 tied to placement grid at 2.16
# therefore, the Element size should be multiple of 2.16 and
# placement of Element should be multiple of 2.16
placement_grid_x = 0.054
placement_grid_y = 0.27

# Element size is set to multiple of 2.16
ce_width    = (3 * 2.16) * pitch_scale
ce_height   = (3 * 2.16) * pitch_scale

# top level core offset 
margin_x    = 2.16
margin_y    = 2.16

# Element placement, can be controlled by user
ce_pitch_x  = ce_width + 2 * margin_x
ce_pitch_y  = ce_height + 2 * margin_y

# top level core size
core_width  = (ce_pitch_x * (cols + 1))
core_height = (ce_pitch_y * (rows + 1))

die_width = core_width + (2 * margin_x)
die_height = core_height + (2 * margin_y)
