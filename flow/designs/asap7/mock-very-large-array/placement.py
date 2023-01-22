power_x_pitch = 11.88
power_y_pitch = 12
y_pitch = (power_y_pitch * 2)
x_pitch = (power_x_pitch * 2)
offset_x = power_x_pitch * 1
offset_y = power_y_pitch * 1
margin = 2

rows = 16
cols = 16

for row in range(rows):
    for col in range(cols):
        print(f'ces_{row}_{col} R0 {col * x_pitch + offset_x} {row * y_pitch + offset_y}')
