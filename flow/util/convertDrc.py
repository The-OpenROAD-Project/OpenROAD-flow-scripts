# This is a KLayout script to load a RVE DRC rpt file
# and write out a json the DRC viewer can read.

import pya

import json

app = pya.Application.instance()
win = app.main_window()

# Load def file in the main window
cell_view = win.create_layout(0)
layout_view = cell_view.view()

rdb_id = layout_view.create_rdb("ASCII")
rdb = layout_view.rdb(rdb_id)
rdb.load(in_drc)

violations = []

for category in rdb.each_category():
    if category.num_items() == 0:
        # ignore categories with no data
        continue

    violations_shapes = []
    for item in rdb.each_item_per_category(category.rdb_id()):
        for value in item.each_value():
            if value.is_box():
                violations_shapes.append(
                    {
                        "type": "box",
                        "shape": [
                            {"x": value.box().left, "y": value.box().bottom},
                            {"x": value.box().right, "y": value.box().top},
                        ],
                    }
                )
            elif value.is_edge():
                violations_shapes.append(
                    {
                        "type": "edge",
                        "shape": [
                            {"x": value.edge().p1.x, "y": value.edge().p1.y},
                            {"x": value.edge().p2.x, "y": value.edge().p2.y},
                        ],
                    }
                )
            elif value.is_edge_pair():
                edge1 = value.edge_pair().first
                edge2 = value.edge_pair().second
                violations_shapes.append(
                    {
                        "type": "edge_pair",
                        "shape": [
                            {"x": edge1.p1.x, "y": edge1.p1.y},
                            {"x": edge1.p2.x, "y": edge1.p2.y},
                            {"x": edge2.p1.x, "y": edge2.p1.y},
                            {"x": edge2.p2.x, "y": edge2.p2.y},
                        ],
                    }
                )
            elif value.is_polygon():
                points = []
                for edge in value.polygon().each_edge():
                    points.append({"x": edge.p1.x, "y": edge.p1.y})
                points.append({"x": edge.p2.x, "y": edge.p2.y})
                violations_shapes.append({"type": "polygon", "shape": points})
            else:
                print("Unknown violation shape:", value)

    violations.append(
        {
            "name": category.name(),
            "description": category.description,
            "violations": violations_shapes,
        }
    )

with open(out_file, "w") as outfile:
    json.dump({"DRC": violations}, outfile)

app.exit(0)
