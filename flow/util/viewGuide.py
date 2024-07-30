# This is a KLayout script to load a FastRoute guide file
# and make a marker database for one net

import pya
import re

# lx ly ux uy layer_name
bbox_re = re.compile("(\d+) (\d+) (\d+) (\d+) (\w+)")
categories = {}


def add_box(line):
    m = re.match(bbox_re, line)
    if not m:
        assert line.strip() == ")"
        return False

    # covert DBU to microns
    # TODO: get conversion factor from KLayout
    lx = float(m.group(1)) / 2000.0
    ly = float(m.group(2)) / 2000.0
    ux = float(m.group(3)) / 2000.0
    uy = float(m.group(4)) / 2000.0
    layer = m.group(5)

    if layer not in categories:
        category = rdb.create_category(layer)
        categories[layer] = category

    category = categories[layer]
    item = rdb.create_item(cell, category)
    bbox = pya.DBox(lx, ly, ux, uy)
    item.add_value(bbox)

    return True


app = pya.Application.instance()
win = app.main_window()

# Load technology file
tech = pya.Technology()
tech.load(tech_file)
layoutOptions = tech.load_layout_options

# Load def file in the main window
cell_view = win.load_layout(in_def, layoutOptions, 0)
layout_view = cell_view.view()

rdb_id = layout_view.create_rdb("FastRoute")
rdb = layout_view.rdb(rdb_id)
cell = rdb.create_cell(cell_view.cell_name)

# The format is net_name ( <box> <layer> ... ) ...
field = 0
on_net = False
with open(in_guide) as fp:
    for line in fp:
        if field == 0:
            m = re.match("(.*)", line)
            assert m
            net = m.group(1)
            on_net = net == net_name
            field = 1
        elif field == 1:
            assert line.strip() == "("
            field = 2
        elif field == 2:
            if on_net:
                if not add_box(line):
                    field = 0
            else:
                if line.strip() == ")":
                    field = 0


assert field == 0

win.menu().action("tools_menu.browse_markers").trigger()
