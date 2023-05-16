import config

margin_x = config.placement_grid_x * 8
margin_y = config.placement_grid_y * 2

print(f'{margin_x} {margin_y} {config.ce_width - margin_x} {config.ce_height - margin_y}')
