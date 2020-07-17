import pya

# Load technology file
tech = pya.Technology()
tech.load(tech_file)
layoutOptions = tech.load_layout_options

# Load def file
main_layout = pya.Layout()
main_layout.read(in_def, layoutOptions)

# Clear cells
top_cell_index = main_layout.cell(design_name).cell_index()

print("[INFO] Clearing cells...")
for i in main_layout.each_cell():
  if i.cell_index() != top_cell_index:
    if not i.name.startswith("VIA"):
      print("\t" + i.name)
      i.clear()

# Load in the gds to merge
print("[INFO] Merging GDS files...")
for gds in in_gds.split():
  print("\t{0}".format(gds))
  main_layout.read(gds)

# Copy the top level only to a new layout
print("[INFO] Copying toplevel cell '{0}'".format(design_name))
top_only_layout = pya.Layout()
top_only_layout.dbu = main_layout.dbu
top = top_only_layout.create_cell(design_name)
top.copy_tree(main_layout.cell(design_name))

print("[INFO] Checking for missing GDS...")
missing_gds = False
for i in top_only_layout.each_cell():
  if i.is_empty():
    missing_gds = True
    print("[ERROR] LEF Cell '{0}' has no matching GDS cell. Cell will be empty".format(i.name))

if not missing_gds:
  print("[INFO] All LEF cells have matching GDS cells")

if seal_gds:

  top_cell = top_only_layout.top_cell()

  print("[INFO] Reading seal GDS file...")
  print("\t{0}".format(seal_gds))
  top_only_layout.read(seal_gds)

  for cell in top_only_layout.top_cells():
    if cell != top_cell:
      print("[INFO] Merging '{0}' as child of '{1}'".format(cell.name, top_cell.name))
      top.insert(pya.CellInstArray(cell.cell_index(), pya.Trans()))

# Write out the GDS
print("[INFO] Writing out GDS '{0}'".format(out_gds))
top_only_layout.write(out_gds)
