import os

rows = int(os.environ.get("MOCK_ARRAY_HEIGHT", "8"))
cols = int(os.environ.get("MOCK_ARRAY_WIDTH", "8"))
pitch_scale = int(os.environ.get("MOCK_ARRAY_PITCH_SCALE", "2"))

routing_pitch = 0.48

# 0.48 * 125 = 60, which is a nice round number to work with
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
