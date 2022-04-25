import pya
import re
import json
import copy
import sys
import os

errors = 0

# Expand layers in json
def expand_cfg_layers(cfg):
  layers = cfg['layers']
  expand = [layer for layer in layers if 'layers' in layers[layer]]
  for layer in expand:
    for i, (name, num) in enumerate(zip(layers[layer]['names'],
                                        layers[layer]['layers'])):
      new_layer = copy.deepcopy(layers[layer])
      del new_layer['names']
      new_layer['name'] = name
      del new_layer['layers']
      new_layer['layer'] = num
      layers[name] = new_layer
    del layers[layer]

def read_cfg():
  print('INFO: Reading config file: ' + config_file)
  with open(config_file, 'r') as f:
    cfg = json.load(f)

  expand_cfg_layers(cfg)
  cfg = cfg['layers'] # ignore the rest

  # Map gds layers & datatype to KLayout indices
  # These are arrays for the different mask numbers
  for layer, vals in cfg.items():
    layer = vals['layer']
    for key in ('opc', 'non-opc'):
      if key not in vals:
        continue
      data = vals[key]
      if isinstance(data['datatype'], int):
        data['datatype'] = [data['datatype']] # convert to array
      data['klayout'] = [main_layout.find_layer(layer, datatype)
                         for datatype in data['datatype']]

  return cfg

#match a line like:
# - LAYER M2 + MASK 2 + OPC RECT ( 3000 3000 ) ( 5000 5000 ) ;
rect_pat = re.compile(r'''
  \s*\-\ LAYER\ (?P<layer>\S+)  # The layer name
  (?:                           # Non-capturing group
  \s+\+\ MASK\ (?P<mask>\d+)    # Mask, None if absent
  )?
  (?P<opc>                      # OPC, None if absent
  \s+\+\ OPC
  )?
  \s+RECT\
   \(\ (?P<xlo>\d+)\ (?P<ylo>\d+)\ \)\   # rect lower-left pt
  \(\ (?P<xhi>\d+)\ (?P<yhi>\d+)\ \)\ ; # rect upper-right pt
  ''',
                      re.VERBOSE)

def read_fills(top):
  if config_file == '':
    print('WARNING: no fill config file specified')
    return
  # KLayout doesn't support FILL in DEF so we have to side load them :(
  cfg = read_cfg()
  in_fills = False
  units = None
  with open(in_def) as fp:
    for line in fp:
      if in_fills:
        if re.match('END FILLS', line):
          break # done with fills; don't care what follows
        m = re.match(rect_pat, line)
        if not m:
          raise Exception('Unrecognized fill: ' + line)
        opc_type = 'opc' if m.group('opc') else 'non-opc'
        mask = m.group('mask')
        if not mask: #uncolored just uses first entry
          mask = 0
        else:
          mask = int(mask) - 1 # DEF is 1-based indexing
        layer = cfg[m.group('layer')][opc_type]['klayout'][mask]
        xlo = int(m.group('xlo')) / units
        ylo = int(m.group('ylo')) / units
        xhi = int(m.group('xhi')) / units
        yhi = int(m.group('yhi')) / units
        top.shapes(layer).insert(pya.DBox(xlo, ylo, xhi, yhi))
      elif re.match('FILLS \d+ ;', line):
        in_fills = True
      elif not units:
        m = re.match('UNITS DISTANCE MICRONS (\d+)', line)
        if m:
          units = float(m.group(1))

# Load technology file
tech = pya.Technology()
tech.load(tech_file)
layoutOptions = tech.load_layout_options
if len(layer_map) > 0:
  layoutOptions.lefdef_config.map_file = layer_map

# Load def file
main_layout = pya.Layout()
print("[INFO] Reporting cells prior to loading DEF ...")
for i in main_layout.each_cell():
  print("[INFO] '{0}'".format(i.name))

print("[INFO] Reading DEF ...")
main_layout.read(in_def, layoutOptions)

#print("[INFO] Reporting cells after loading DEF ...")
#for i in main_layout.each_cell():
#  print("[INFO] '{0}'".format(i.name))

# Clear cells
top_cell_index = main_layout.cell(design_name).cell_index()

# remove orphan cell BUT preserve cell with VIA_
#  - KLayout is prepending VIA_ when reading DEF that instantiates LEF's via
print("[INFO] Clearing cells...")
for i in main_layout.each_cell():
  if i.cell_index() != top_cell_index:
    if not i.name.startswith("VIA_"):
      i.clear()

# Load in the gds to merge
print("[INFO] Merging GDS/OAS files...")
for fil in in_files.split():
  print("\t{0}".format(fil))
  main_layout.read(fil)

# Copy the top level only to a new layout
print("[INFO] Copying toplevel cell '{0}'".format(design_name))
top_only_layout = pya.Layout()
top_only_layout.dbu = main_layout.dbu
top = top_only_layout.create_cell(design_name)
top.copy_tree(main_layout.cell(design_name))

read_fills(top)

print("[INFO] Checking for missing cell from GDS/OAS...")
missing_cell = False
regex = None
if 'GDS_ALLOW_EMPTY' in os.environ:
    print("[INFO] Found GDS_ALLOW_EMPTY variable.")
    regex = os.getenv('GDS_ALLOW_EMPTY')
for i in top_only_layout.each_cell():
  if i.is_empty():
    missing_cell = True
    if regex is not None and re.match(regex, i.name):
        print("[WARNING] LEF Cell '{0}' ignored. Matches GDS_ALLOW_EMPTY.".format(i.name))
    else:
        print("[ERROR] LEF Cell '{0}' has no matching GDS/OAS cell."
              " Cell will be empty.".format(i.name))
        errors += 1

if not missing_cell:
  print("[INFO] All LEF cells have matching GDS/OAS cells")

print("[INFO] Checking for orphan cell in the final layout...")
orphan_cell = False
for i in top_only_layout.each_cell():
  if i.name != design_name and i.parent_cells() == 0:
    orphan_cell = True
    print("[ERROR] Found orphan cell '{0}'".format(i.name))
    errors += 1

if not orphan_cell:
  print("[INFO] No orphan cells")


if seal_file:

  top_cell = top_only_layout.top_cell()

  print("[INFO] Reading seal GDS/OAS file...")
  print("\t{0}".format(seal_file))
  top_only_layout.read(seal_file)

  for cell in top_only_layout.top_cells():
    if cell != top_cell:
      print("[INFO] Merging '{0}' as child of '{1}'".format(cell.name, top_cell.name))
      top.insert(pya.CellInstArray(cell.cell_index(), pya.Trans()))

# Write out the GDS
print("[INFO] Writing out GDS/OAS '{0}'".format(out_file))
top_only_layout.write(out_file)

sys.exit(errors)
