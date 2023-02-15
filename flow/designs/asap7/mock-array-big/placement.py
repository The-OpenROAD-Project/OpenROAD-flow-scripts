import config


# from asap7_tech_1x_201209.lef MANUFACTURINGGRID 0.001
mf = 0.001

def manufacturinggrid(number):
    return f'{mf * round(number / mf):.3f}'

for row in range(config.rows):
    for col in range(config.cols):
        print(f'ces_{row}_{col} R0 {manufacturinggrid(col * config.x_pitch + config.offset_x)} {manufacturinggrid(row * config.y_pitch + config.offset_y)}')
