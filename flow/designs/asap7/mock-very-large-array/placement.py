y_pitch = 25
x_pitch = 25
offset = 10

rows = 16
cols = 16

for row in range(rows):
    for col in range(cols):
        print(f'ces_{row}_{col} R0 {col * x_pitch + offset} {row * y_pitch + offset}')
