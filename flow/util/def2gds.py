import pya

# Create a layer map for conversion to gds
layer_map = pya.LayerMap()

# Manually parse layermap file
# TODO(rovinski) find out if this can be read from the lyp file
print("INFO: Opening layermap file: " + map_file)
with open(map_file) as mf:
  print("INFO: Mapping:")
  index = 0
  for line in mf:
    s = line.strip()

    # Comment or empty line
    if s.startswith('#') or not s:
      continue
    print("\tlayer_map.map(" + s + ", " + str(index) + ")")
    layer_map.map(s, index)
    index += 1

# TODO(rovinski) If the GDS and LEF DB units are mismatched, the merged GDS is
# incorrect because the GDS cell geometry is not scaled properly. I need to ask
# what the proper way to do this is. In the meantime, we can get the GDS DBU and
# use that to scale the LEF. Does not work if merging multiple GDSs with
# different DBUs
temp_layout = pya.Layout()
temp_gds = in_gds.split()[0]
print("INFO: Getting DBU from '" + temp_gds + "'")
temp_layout.read(in_gds.split()[0])
print("INFO: Using GDS DBU of " + str(temp_layout.dbu))

# Load in the lef/def layout
print("INFO: Opening input files...")
print("\tDEF: " + in_def)
print("\tLEF: " + in_lef)

main_layout = pya.Layout()
options = pya.LoadLayoutOptions()
lefdef_options = pya.LEFDEFReaderConfiguration()
lefdef_options.lef_files = [in_lef]
lefdef_options.layer_map = layer_map
lefdef_options.dbu = temp_layout.dbu
options.lefdef_config = lefdef_options
main_layout.read(in_def, options)

# Clear cells
top_cell_index = main_layout.cell(design_name).cell_index()

print("INFO: Clearing cells...")
for i in range(main_layout.cells()):
  if i != top_cell_index:
    cname = main_layout.cell_name(i)
    if not cname.startswith("VIA"):
      print("\t" + cname)
      main_layout.cell(i).clear()

# Load in the gds to merge
print("INFO: Merging gds files...")
for gds in in_gds.split():
  test = pya.Layout()
  print("\t" + gds)
  test.read(gds)
  main_layout.dbu = test.dbu
  main_layout.read(gds)

# Copy the top level only to a new layout
print("INFO: Copying toplevel cell '" + design_name + "'")
top_only_layout = pya.Layout()
top_only_layout.dbu = main_layout.dbu
top = top_only_layout.create_cell(design_name)
top.copy_tree(main_layout.cell(design_name))

# Write out the gds
print("INFO: Write out gds '" + out_gds + "'")
top_only_layout.write(out_gds)
