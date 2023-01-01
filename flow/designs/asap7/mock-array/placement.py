y_pitch = 20
x_pitch = 20
offset = 10

rows = 2
cols = 2

for row in range(rows):
    for col in range(cols):
        print(f'ces_{row}_{col} R0 {col * x_pitch + offset} {row * y_pitch + offset}')
