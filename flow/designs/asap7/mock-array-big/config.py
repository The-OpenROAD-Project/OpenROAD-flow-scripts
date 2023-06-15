import os

# routing pitch for M4, M5 and M6 tied to placement grid at 2.16
# therefore, the optimal placement and Element size should be multiple of 2.16
# set grid x and y
pgrid_x     = 2.16
pgrid_y     = 2.16

# number of Elements in row and column, can be control by user via environment variable MOCK_ARRAY_TABLE (rows, cols)
# specification is in unit of placement grid
rows, cols = [int(os.environ.get("MOCK_ARRAY_TABLE").split()[i]) for i in (0, 1)]

# Element placement pitch, can be control by user via environment variable MOCK_ARRAY_ELEMENT_PITCH (x, y)
# specification is in unit of placement grid
pitch_x, pitch_y = [int(os.environ.get("MOCK_ARRAY_ELEMENT_PITCH").split()[i]) for i in (0, 1)]

# Element size, can be control by user via environment variable MOCK_ARRAY_ELEMENT_SIZE (width, height)
# specification is in unit of placement grid
ce_x, ce_y = [int(os.environ.get("MOCK_ARRAY_ELEMENT_SIZE").split()[i]) for i in (0, 1)]

# Element size is set to multiple of placement grid above
ce_width    = ce_x * pgrid_x
ce_height   = ce_y * pgrid_y

# top level core offset 
margin_x    = pgrid_x
margin_y    = pgrid_y

# top level core and die size
core_width  = ((pgrid_x * pitch_x) * (cols + 1)) + (ce_width  * cols)
core_height = ((pgrid_y * pitch_y) * (rows + 1)) + (ce_height * rows)

die_width  = core_width  + (margin_x * 2)
die_height = core_height + (margin_y * 2)
