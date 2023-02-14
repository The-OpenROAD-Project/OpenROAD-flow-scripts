# see flow/platforms/asap7/openRoad/pdn/grid_strategy-M2-M5-M7.tcl
import os

rows = int(os.environ.get("MOCK_ARRAY_HEIGHT", "8"))
cols = int(os.environ.get("MOCK_ARRAY_WIDTH", "8"))
pitch_scale = int(os.environ.get("MOCK_ARRAY_PITCH_SCALE", "10"))


# from platforms/asap7/openRoad/make_tracks.tcl, smallest common x_pitch and y_pitch
# denominator
lowest_common_grid_denominator = 0.576

power_x_pitch = 4 * lowest_common_grid_denominator
power_y_pitch = 4 * lowest_common_grid_denominator
y_pitch = (power_y_pitch * pitch_scale)
x_pitch = (power_x_pitch * pitch_scale)
offset_x = power_x_pitch * 4
offset_y = power_y_pitch * 4
margin = 4 * lowest_common_grid_denominator

element_width = x_pitch - power_x_pitch * 4
element_height = y_pitch - power_y_pitch * 4

height = rows * y_pitch + offset_y
width = cols * x_pitch + offset_x
