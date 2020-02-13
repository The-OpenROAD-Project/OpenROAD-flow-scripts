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
  print("\t" + gds)
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
