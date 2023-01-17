y_pitch = 40
x_pitch = 40
offset = 20

rows = 8
cols = 8

for row in range(rows):
    for col in range(cols):
        print(f'ces_{row}_{col} R0 {col * x_pitch + offset} {row * y_pitch + offset}')
