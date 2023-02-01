# from platforms/asap7/openRoad/make_tracks.tcl, smallest common x_pitch and y_pitch
# denominator
lowest_common_grid_denominator = 0.576

y_pitch = lowest_common_grid_denominator * 43
x_pitch = lowest_common_grid_denominator * 43
offset = lowest_common_grid_denominator * 17

rows = 8
cols = 8

def manufcaturing_grid(num):
    return f'{num:.3f}'

for row in range(rows):
    for col in range(cols):
        print(f'ces_{row}_{col} R0 {manufcaturing_grid(col * x_pitch + offset)} {manufcaturing_grid(row * y_pitch + offset)}')
