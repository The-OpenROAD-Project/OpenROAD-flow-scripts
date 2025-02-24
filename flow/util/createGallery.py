# This is a KLoayout script to create a screenshot gallery
import pya
import json

# Load technology file
tech = pya.Technology()
tech.load(tech_file)
layoutOptions = tech.load_layout_options

# Load gallery config JSON
main_window = pya.Application.instance().main_window()
with open(gallery_json) as gj:
    gallery = json.load(gj)

for image in gallery:
    layout_path = "{0}/{1}".format(results_path, image["layout_file"])
    print("[INFO][FLOW] Loading file '{0}'".format(layout_path))
    main_window.load_layout(layout_path, layoutOptions, 0)
    view = main_window.current_view()

    # Force uniform view config
    view.set_config("background-color", "#000000")
    view.set_config("grid-visible", "false")
    view.set_config("text-visible", "false")
    view.set_config("inst-color", "#808080")

    view.min_hier_levels = image["min_hierarchy"]
    view.max_hier_levels = image["max_hierarchy"]

    if image["hide_layers"]:
        i = view.begin_layers()
        while not i.at_end():
            i.current().visible = False
            i.next()

    save_path = "{0}/gallery_{1}.png".format(results_path, image["name"])
    view.save_image(save_path, image["x_resolution"], image["y_resolution"])
    print("[INFO][FLOW] Saved screenshot to '{0}'".format(save_path))

pya.Application.instance().exit(0)
