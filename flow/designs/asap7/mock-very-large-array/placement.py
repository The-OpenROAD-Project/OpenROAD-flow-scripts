power_x_pitch = 11.88
power_y_pitch = 12
y_pitch = (power_y_pitch * 2)
x_pitch = (power_x_pitch * 2)
offset_x = power_x_pitch * 1
offset_y = power_y_pitch * 1
margin = 2

rows = 16
cols = 16

# from asap7_tech_1x_201209.lef MANUFACTURINGGRID 0.001
mf = 0.001

def manufacturinggrid(number):
    return mf * round(number / mf)

for row in range(rows):
    for col in range(cols):
        print(f'ces_{row}_{col} R0 {col * x_pitch + offset_x:.3f} {row * y_pitch + offset_y:.3f}')
