import os

# number of Elements in row and column, user can set via environment variable
rows = int(os.environ.get("MOCK_ARRAY_HEIGHT", "8"))
cols = int(os.environ.get("MOCK_ARRAY_WIDTH", "8"))

# must be 8x8
if (rows * cols) < 64:
  print("ERROR: number of elements row and columns must add up to 64.")
  print("         {} {} revert to 8 x 8".format(rows, cols))
  exit

# Element placement pitch can be control by user
pitch_scale = int(os.environ.get("MOCK_ARRAY_PITCH_SCALE", "2"))

# must be > 1
if pitch_scale < 1:
  print("ERROR: Element placement pitch must be greater than 1")
  exit

# routing pitch for M4, M5 and M6 tied to placement grid at 2.16
# therefore, the Element size should be multiple of 2.16 and
# placement of Element should be multiple of 2.16
placement_grid_x = 0.054
placement_grid_y = 0.27

# Element size is set to multiple of 2.16
ce_width    = 12.96
ce_height   = 12.96

# Element placement, can be controled by user
ce_pitch_x  = ce_width  * pitch_scale
ce_pitch_y  = ce_height * pitch_scale

# top level core offset 
margin_x    = 2.16
margin_y    = 2.16

# top level core size
core_width  = (ce_pitch_x * (cols + 0.5))
core_height = (ce_pitch_y * (rows + 0.5))

die_width = core_width + (2 * margin_x)
die_height = core_height + (2 * margin_y)
