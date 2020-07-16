# This is a KLoayout script to create a screenshot gallery
import pya
import json

tech = pya.Technology()
tech.load(tech_file)
layoutOptions = tech.load_layout_options

main_window = pya.Application.instance().main_window()
with open(gallery_json) as gj:
  gallery = json.load(gj)

for image in gallery:
  main_window.load_layout("{0}/{1}".format(results_path,image['layout_file']), layoutOptions, 0)
  view = main_window.current_view()

  view.min_hier_levels = image['min_hierarchy']
  view.max_hier_levels = image['max_hierarchy']

  if image['hide_layers']:
    i = view.begin_layers()
    while not i.at_end():
      i.current().visible = False
      i.next()

  view.save_image("{0}/gallery_{1}.png".format(results_path, image['name']),
                  image['x_resolution'],
                  image['y_resolution'])

pya.Application.instance().exit(0)
