# This is a KLayout script which performs a simple metal fill
# TODO(rovinski) this is hardcoded for Nangate45
# TODO(rovinski) Density calc for boxes that go outside boundary aren't useful
# TODO(rovinski) Enhanced fill, which allows off-grid placement of cells, should be enabled
# TODO(rovinski) Second-roder fill with a smaller fill cell needs to be enabled
# TODO(rovinski) Find out if there's a built-in way to get min layer widths from the LEF
# TODO(rovinski) Calculate density for all fill layers, not just one

import pya
import time
from math import floor

start_time = time.time()

print("INFO: Reading GDS: " + in_gds)
main_layout = pya.Layout()
main_layout.read(in_gds)

top_name = "top"
print("INFO: Creating new top cell: " + top_name)
design_top = main_layout.top_cell()
top = main_layout.create_cell("top")
fill_top_cell = main_layout.create_cell("fill")

top.insert(pya.CellInstArray(design_top.cell_index(), pya.Trans()))
top.insert(pya.CellInstArray(fill_top_cell.cell_index(), pya.Trans()))

print("INFO: Flattening top cell")
top.move_tree(fill_top_cell)
fill_top_cell.copy_tree(design_top)
fill_top_cell.flatten(True)

# Metal           1      2      3      4      5      6      7      8      9     10
metal_widths = [0.065, 0.070, 0.070, 0.140, 0.140, 0.140, 0.400] #, 0.400, 0.800, 0.800]


# Map metals to GDS layers to layer indexes
metal_infos = []
for i in range(7):
  metal_infos.append(pya.LayerInfo(11+2*i, 0))

metal_layers = []

for metal in metal_infos:
  for li in main_layout.layer_indexes():
    if main_layout.get_info(li).is_equivalent(metal):
      metal_layers.append(li)
      break

# Fill margin = minimum spacing rule + extension factor
fill_margin  = [1.5*width for width in metal_widths]

metal_widths[:] = [width / main_layout.dbu for width in metal_widths]
fill_margin[:] = [margin / main_layout.dbu for margin in fill_margin]

def create_fill_cell_large(metal):
  cell = main_layout.create_cell("metal" + str(metal + 1) + "_large")
  mw = metal_widths[metal]

  # Row 1
  cell.shapes(metal_layers[i]).insert(pya.Box(     0,      0, 1.0*mw, 1.0*mw))
  cell.shapes(metal_layers[i]).insert(pya.Box(2.0*mw, 0.5*mw, 3.0*mw, 1.5*mw))
  cell.shapes(metal_layers[i]).insert(pya.Box(4.0*mw, 1.0*mw, 5.0*mw, 2.0*mw))

  # Row 2
  cell.shapes(metal_layers[i]).insert(pya.Box(     0, 2.0*mw, 1.0*mw, 3.0*mw))
  cell.shapes(metal_layers[i]).insert(pya.Box(2.0*mw, 2.5*mw, 3.0*mw, 3.5*mw))
  cell.shapes(metal_layers[i]).insert(pya.Box(4.0*mw, 3.0*mw, 5.0*mw, 4.0*mw))
  return cell

def create_fill_cell_small(metal):
  cell = main_layout.create_cell("metal" + str(metal + 1) + "_small")
  mw = metal_widths[metal]

  cell.shapes(metal_layers[i]).insert(pya.Box(     0,      0, 1.0*mw, 1.0*mw))
  return cell

for i in range(len(metal_widths)):
  large_cell = create_fill_cell_large(i)
  #small_cell = create_fill_cell_small(i)
  # Calculate the fill area
  # Fill area is calculated by NOT(layer shapes + margin)
  print("INFO: Calculating fill region for metal" + str(i+1))
  #TODO(rovinski) get outline layer properly
  fill_area = pya.Region(fill_top_cell.shapes(12))
  exclude_area = pya.Region(fill_top_cell.shapes(metal_layers[i]))
  fill_area = fill_area - exclude_area.extents(fill_margin[i], fill_margin[i])
  outline = pya.Box(0,0,6*metal_widths[i],4*metal_widths[i])

  print("INFO: Performing fill for metal" + str(i+1))
  while not fill_area.is_empty():
    fill_top_cell.fill_region(fill_area, large_cell.cell_index(), outline, None, fill_area, pya.Point(0,0), None)
  #fill_top_cell.fill_region(fill_area, large_cell.cell_index(), outline, None, fill_area, pya.Point(0,0), None)
  #outline = pya.Box(-metal_widths[i],-metal_widths[i],metal_widths[i],metal_widths[i])
  #while not fill_area.is_empty():
  #  fill_top_cell.fill_region(fill_area, small_cell.cell_index(), outline, None, fill_area, pya.Point(0,0), None)

fill_top_cell.clear_shapes()

print("INFO: Writing gds: " + out_gds)
main_layout.write(out_gds)

print("INFO: Fill finished")
print("\t time taken: %.2f seconds " % (time.time() - start_time))

start_time = time.time()
print("INFO: Starting density report")
# Windowed Density calculation

# Obtain the parameters for the density map 
# TODO: read them from some setup file or provide a UI for that (difficult) ...
xmin = top.bbox().p1.x * main_layout.dbu         # left coordinate of the mapping area
xmax = top.bbox().p2.x * main_layout.dbu      # right coordinate of the mapping area
ymin = top.bbox().p1.y * main_layout.dbu         # bottom coordinate of the mapping area
ymax = top.bbox().p2.y * main_layout.dbu      # top coordinate of the mapping area
xw = 50.0          # horizontal window size
yw = 50.0          # vertical window size
layer = pya.LayerInfo(15, 0)     # source layer (GDS: layer, datatype)

# obtain the pointers to the layout and cell 
top_index = top.cell_index()
top_name = main_layout.cell_name(top_index)
top_bbox = top.bbox()
dbu = main_layout.dbu

# identify the layer to take the density from
input_layer = None
for li in main_layout.layer_infos():
  if li.is_equivalent(layer):
    input_layer = li.layer

# no such layer -> error
if not input_layer:
  raise ValueError("Input layer " + str(layer) + " not found in input layout")

# Start to collect the data:
data = []

# proceed row by row
# (for each row we use the multi_clip_into which is more efficient than single clips per window)
nrows = 0
y = ymin

reportstr = ""

while y < ymax-1e-6:

  # Prepare a new layout to receive the clips
  # Hint: we need to clip all layers (clip does not support clipping of one layer alone currently).
  cl = pya.Layout()
  cl.dbu = dbu
  for li in main_layout.layer_indexes():
    cl.insert_layer_at(li, main_layout.get_info(li))

  # Prepare the clip boxes for this row.
  # Note: because clip only works with boxes that overlap the cell's bounding box currently, we
  # have to operate with a subset of fields to support the general case.
  boxes = []
  x = xmin
  ncolumns = 0
  colstart = None
  while x < xmax-1e-6:
    b = pya.Box.new(floor(0.5 + x / dbu), floor(0.5 + y / dbu), floor(0.5 + (x + xw) / dbu), floor(0.5 + (y + yw) / dbu));
    if b.overlaps(top_bbox):
      colstart = colstart or ncolumns 
      boxes.append(b)
    x += xw
    ncolumns += 1

  if colstart:

    col = colstart

    # Actually do the clip
    cells = main_layout.multi_clip_into(top_index, cl, boxes)

    ep = pya.ShapeProcessor()
    merged = pya.Shapes()

    # Compute the area within area box
    for c in cells:

      # merge the shapes to polygons and compute the area
      ep.merge(cl, cl.cell(c), input_layer, merged, True, 0, False, False)
      a = 0
      for m in merged.each():
        a += m.polygon.area()

      # compute and store the density
      a = a * dbu * dbu / (xw * xw)
      printstr = "Region: (%08.3f,%08.3f) - (%08.3f,%08.3f): %06.3f%%" % ((col-1)*xw, y, col*xw, y+yw, 100*a)
      reportstr += printstr
      reportstr += '\n'
      print(printstr)

      col += 1

  y += yw
  nrows += 1

with open(report_file, 'w') as rpt:
  rpt.write(reportstr)

print("INFO: Density report finished")
print("\t time taken: %.2f seconds " % (time.time() - start_time))
