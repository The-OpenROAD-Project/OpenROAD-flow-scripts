# This is a KLayout script which performs a simple metal fill
# TODO(mliberty) Density check needs updating/fixing
# TODO(rovinski) Density calc for boxes that go outside boundary aren't useful

# Script parameters:
#  in_gds
#  out_gds
#  report_file
#  config_file [json]

import pya
import time
from math import floor
import json
import copy

start_time = time.time()

def half(x):
  'halve x while rounding up'
  return int((x + 1) / 2)

def read_cfg():
  print('INFO: Reading config file: ' + config_file)
  with open(config_file, 'r') as f:
    cfg = json.load(f)
  return cfg
  
print('INFO: Reading GDS: ' + in_gds)
main_layout = pya.Layout()
main_layout.read(in_gds)

def setup_top():
  top_name = 'top'
  print('INFO: Creating new top cell: ' + top_name)
  design_top = main_layout.top_cell()
  top = main_layout.create_cell('top')
  fill_top_cell = main_layout.create_cell('fill')

  top.insert(pya.CellInstArray(design_top.cell_index(), pya.Trans()))
  top.insert(pya.CellInstArray(fill_top_cell.cell_index(), pya.Trans()))

  print('INFO: Flattening top cell')
  top.move_tree(fill_top_cell)
  fill_top_cell.copy_tree(design_top)
  fill_top_cell.flatten(True)
  return fill_top_cell

fill_top_cell = setup_top()

# Expand layers in json
def expand_cfg_layers(cfg):
  layers = cfg['layers']
  expand = [layer for layer in layers if 'layers' in layers[layer]]
  for layer in expand:
    for i, (num, dir) in enumerate(zip(layers[layer]['layers'],
                                       layers[layer]['dirs'])):
      new_layer = copy.deepcopy(layers[layer])
      del new_layer['layers']
      new_layer['layer'] = num
      del new_layer['dirs']
      new_layer['dir'] = dir
      layers['{}_{}'.format(layer, i)] = new_layer
    del layers[layer]


def setup_cfg(cfg):
  expand_cfg_layers(cfg)

  # Find the klayout layer_index and convert microns to DBUs
  for vals in cfg['layers'].values():
    vals['klayout'] = main_layout.find_layer(vals['layer'], vals['datatype'])
    vals['space_to_outline'] /= main_layout.dbu
    for opc_type in ('opc', 'non-opc'):
      if opc_type not in vals: # layer without opc
        continue
      v = vals.get(opc_type)
      v['klayout'] = main_layout.layer(vals['layer'], v['datatype'])
      if 'datatype2' in v: # second exposure in double patterning
        v['klayout2'] = main_layout.layer(vals['layer'], v['datatype2'])      
      v['width']  = [x / main_layout.dbu for x in v['width']]
      v['height'] = [x / main_layout.dbu for x in v['height']]
      if 'halo' in v: # only opc
        v['halo'] /= main_layout.dbu
        assert(opc_type == 'opc')
      v['space_to_fill'] /= main_layout.dbu
      v['space_to_non_fill'] /= main_layout.dbu
      if 'space_line_end' in v: 
        v['space_line_end'] /= main_layout.dbu
        assert(opc_type == 'opc') # we don't need line_end for non-opc today
      
      
def create_fill_cell(name, cfg, w, h, secondary_layer=False):
  cell = main_layout.create_cell(name + '_small_' + str(w) + '_' + str(h))
  if secondary_layer:
    layer = cfg['klayout2']
  else:
    layer = cfg['klayout']

  cell.shapes(layer).insert(pya.Box(0, 0, w, h))

  xpad = ypad = half(cfg['space_to_fill'])
  if 'space_line_end' in cfg:
    if w > h:
      xpad = half(cfg['space_line_end'])
    else:
      ypad = half(cfg['space_line_end'])
      
  bbox = pya.Box(-xpad, -ypad, w + xpad, h + ypad)
  return cell, bbox

def double_pattern(fill_top_cell, old_cell, new_cell):
  # swap half the instances to the other exposure
  i = 0
  for inst in fill_top_cell.each_inst():
    if inst.cell == old_cell:
      i += 1
      if i % 2 == 0:
        inst.cell = new_cell
  

def do_non_opc_fill(fill_top_cell, layer, layer_cfg, outline_area, shapes_area):
  non_opc_cfg = layer_cfg['non-opc']
  sp_non = non_opc_cfg['space_to_non_fill']
  sp_fill = non_opc_cfg['space_to_fill']
  # Constant across iterations
  fill_base_area = outline_area - shapes_area.sized(sp_non - half(sp_fill))

  for w, h in zip(non_opc_cfg['width'], non_opc_cfg['height']):
    # Orient the fill in the preferred direction
    if layer_cfg['dir'] == 'H':
      w, h = (max(w, h), min(w, h))
    else:
      w, h = (min(w, h), max(w, h))

    # The set of non-OPC fill shapes may expand on each iteration so we
    # recompute it
    non_opc_fill = pya.Region(fill_top_cell.begin_shapes_rec(non_opc_cfg['klayout']))
    fill_area = fill_base_area - non_opc_fill.sized(half(sp_fill))

    small_cell, fill_cell_bbox = create_fill_cell(layer + '_non_opc',
                                                  non_opc_cfg, w, h)
    while not fill_area.is_empty():
      fill_top_cell.fill_region(fill_area,
                                small_cell.cell_index(),
                                fill_cell_bbox,
                                None,
                                fill_area,
                                pya.Point(0,0),
                                None)

    if 'datatype2' in non_opc_cfg:
      e2_cell, _ = create_fill_cell(layer + '_non_opc_e2',
                                    non_opc_cfg, w, h, True)
      double_pattern(fill_top_cell, small_cell, e2_cell)

def do_opc_fill(fill_top_cell, layer, layer_cfg, outline_area, shapes_area):
  has_opc = 'opc' in layer_cfg
  if not has_opc:
    return
  opc_cfg = layer_cfg['opc']
  sp_non = opc_cfg['space_to_non_fill']
  sp_fill = opc_cfg['space_to_fill']
  halo = opc_cfg['halo']

  non_opc_cfg = layer_cfg['non-opc']
  sp_fill_non_opc = non_opc_cfg['space_to_fill'] - half(sp_fill)

  non_opc_fill = pya.Region(fill_top_cell.begin_shapes_rec(non_opc_cfg['klayout']))
  if 'klayout2' in non_opc_cfg:
    non_opc_fill |= pya.Region(fill_top_cell.begin_shapes_rec(non_opc_cfg['klayout2']))
    
  fill_base_area = outline_area & (shapes_area.sized(halo)
                                   - shapes_area.sized(sp_non - half(sp_fill))
                                   - non_opc_fill.sized(sp_fill_non_opc))

  is_h = layer_cfg['dir'] == 'H'
  for w, h in zip(opc_cfg['width'], opc_cfg['height']):
    w_space = h_space = half(sp_fill)
    le = opc_cfg.get('space_line_end', 0)
    if is_h:
      w, h = (max(w, h), min(w, h))
      w_space += half(le)
    else:
      w, h = (min(w, h), max(w, h))
      h_space += half(le)

    opc_fill = pya.Region(fill_top_cell.begin_shapes_rec(opc_cfg['klayout']))
    if 'klayout2' in opc_cfg:
      opc_fill |= pya.Region(fill_top_cell.begin_shapes_rec(opc_cfg['klayout2']))

    fill_area = fill_base_area - opc_fill.sized(w_space, h_space, 2)
    small_cell, fill_cell_bbox = create_fill_cell(layer + '_opc',
                                                  opc_cfg, w, h)
    while not fill_area.is_empty():
      fill_top_cell.fill_region(fill_area,
                                small_cell.cell_index(),
                                fill_cell_bbox,
                                None,
                                fill_area,
                                pya.Point(0,0),
                                None)
    if 'datatype2' in opc_cfg:
      e2_cell, _ = create_fill_cell(layer + '_opc_e2',
                                    opc_cfg, w, h, True)
      double_pattern(fill_top_cell, small_cell, e2_cell)
      
def do_fill():
  cfg = read_cfg()
  setup_cfg(cfg)
  
  # Map outline from GDS to layer index
  outline = cfg['outline']
  outline_index = main_layout.find_layer(outline['layer'], outline['datatype'])

  for layer, layer_cfg in cfg['layers'].items():
    print('INFO: Performing fill for {} [gds={}:{} klayout={}]'.format(
      layer, layer_cfg['layer'], layer_cfg['datatype'], layer_cfg['klayout']))

    outline_area = pya.Region(fill_top_cell.bbox_per_layer(outline_index))
    outline_area.size(-layer_cfg['space_to_outline'])

    shapes_area = pya.Region(fill_top_cell.shapes(layer_cfg['klayout']))

    do_non_opc_fill(fill_top_cell, layer, layer_cfg, outline_area, shapes_area)
    do_opc_fill(fill_top_cell, layer, layer_cfg, outline_area, shapes_area)

  # Discards the flatten shapes from the design but keeps the fill instances
  fill_top_cell.clear_shapes()

  print('INFO: Writing gds: ' + out_gds)
  main_layout.write(out_gds)

  print('INFO: Fill finished')
  print('\t time taken: %.2f seconds ' % (time.time() - start_time))

do_fill()

if False:
    start_time = time.time()
    print('INFO: Starting density report')
    # Windowed Density calculation
    
    # Obtain the parameters for the density map 
    # TODO: read them from some setup file or provide a UI for that (difficult) ...
    xmin = top.bbox().p1.x * main_layout.dbu  # left coordinate of the mapping area
    xmax = top.bbox().p2.x * main_layout.dbu  # right coordinate of the mapping area
    ymin = top.bbox().p1.y * main_layout.dbu  # bottom coordinate of the mapping area
    ymax = top.bbox().p2.y * main_layout.dbu  # top coordinate of the mapping area
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
      raise ValueError('Input layer ' + str(layer) + ' not found in input layout')
    
    # Start to collect the data:
    data = []
    
    # proceed row by row
    # (for each row we use the multi_clip_into which is more efficient
    #  than single clips per window)
    nrows = 0
    y = ymin
    
    reportstr = ''
    
    while y < ymax-1e-6:
    
      # Prepare a new layout to receive the clips
      # Hint: we need to clip all layers (clip does not support clipping
      #   of one layer alone currently).
      cl = pya.Layout()
      cl.dbu = dbu
      for li in main_layout.layer_indexes():
        cl.insert_layer_at(li, main_layout.get_info(li))
    
      # Prepare the clip boxes for this row.
      # Note: because clip only works with boxes that overlap the cell's
      # bounding box currently, we have to operate with a subset of fields
      # to support the general case.
      boxes = []
      x = xmin
      ncolumns = 0
      colstart = None
      while x < xmax-1e-6:
        b = pya.Box.new(floor(0.5 + x / dbu),
                        floor(0.5 + y / dbu),
                        floor(0.5 + (x + xw) / dbu),
                        floor(0.5 + (y + yw) / dbu));
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
          printstr = 'Region: (%08.3f,%08.3f) - (%08.3f,%08.3f): %06.3f%%' \
            % ((col-1)*xw, y, col*xw, y+yw, 100*a)
          reportstr += printstr
          reportstr += '\n'
          print(printstr)
    
          col += 1
    
      y += yw
      nrows += 1
    
    with open(report_file, 'w') as rpt:
      rpt.write(reportstr)
    
    print('INFO: Density report finished')
    print('\t time taken: %.2f seconds ' % (time.time() - start_time))
    
