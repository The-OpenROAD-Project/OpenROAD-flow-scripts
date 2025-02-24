# This is a KLayout script to load a TritonRoute DRC rpt file
# and make a marker database.  Markers are categorized by their
# 'violation type'.

import pya
import re

app = pya.Application.instance()
win = app.main_window()

# Load technology file
tech = pya.Technology()
tech.load(tech_file)
layoutOptions = tech.load_layout_options

# Load def file in the main window
cell_view = win.load_layout(in_def, layoutOptions, 0)
layout_view = cell_view.view()

rdb_id = layout_view.create_rdb("TritonRoute")
rdb = layout_view.rdb(rdb_id)
cell = rdb.create_cell(cell_view.cell_name)

bbox_re = " *bbox = \( ([^,]+), ([^)]+) \) - \( ([^,]+), ([^)]+) \) on (Layer .*)"

categories = {}

# The format is a simple three line repetition.  'Field' keeps
# track of where we are in the pattern.
field = 0
with open(in_drc) as fp:
    for line in fp:
        if field == 0:
            m = re.match(" *violation type: (.*)", line)
            assert m
            viol = m.group(1)
        elif field == 1:
            assert "srcs:" in line
            srcs = line.lstrip()
        elif field == 2:
            m = re.match(bbox_re, line)
            assert m
            lx = float(m.group(1))
            ly = float(m.group(2))
            ux = float(m.group(3))
            uy = float(m.group(4))
            layer = m.group(5)

        if field == 2:
            if viol not in categories:
                category = rdb.create_category(viol)
                categories[viol] = category

            category = categories[viol]
            item = rdb.create_item(cell, category)
            bbox = pya.DBox(lx, ly, ux, uy)
            item.add_value(bbox)
            item.add_value(layer)
            item.add_value(srcs)

            field = 0
        else:
            field += 1

assert field == 0

win.menu().action("tools_menu.browse_markers").trigger()
