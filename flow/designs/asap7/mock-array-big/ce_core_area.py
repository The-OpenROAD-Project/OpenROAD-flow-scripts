import config

margin_x = config.pgrid_x * 0.5
margin_y = config.pgrid_y * 0.5

print(f'{margin_x} {margin_y} {config.ce_width - margin_x} {config.ce_height - margin_y}')
