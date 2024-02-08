import json
import pandas as pd
import matplotlib.pyplot as plt
import synth_keep

# Load the first JSON file
with open('objects/nangate45/bp_multi/base/synth_full.json', 'r') as file:
    data_a = json.load(file)

# create dictionary of module names and their area, strip the \ in front of module name
# Area of module \bsg_mem_1r1w_synth_width_p99_els_p2_read_write_same_addr_p0_harden_p0 is 1821.834000
with open('mark_hier_stop_modules.tcl', 'r') as file:
    areas = {line.split()[3].lstrip("\\"): float(line.split()[5])
             for line in file.readlines() if line.startswith('Area of module')}


for name, module in data_a['modules'].items():
    area = areas.get(name, 0)
    cells = synth_keep.count_cells(module, data_a['modules'])
    if area > 100 and area < 1000 and cells < 100:
        print(f"{name} {cells} {area}")
        synth_keep.count_cells(module, data_a['modules'])


# Get the cell counts for each module in each file
cell_counts_a = {name: synth_keep.count_cells(module, data_a['modules'])
                 for name, module in data_a['modules'].items()}

# Create a DataFrame from the cell counts and areas
df = pd.DataFrame(list(zip(cell_counts_a.keys(), cell_counts_a.values())),
                  columns=['name', 'cell count full'])
df['area'] = df['name'].map(areas)

MAX_AREA = 1000
# prune datapoints with area > MAX_AREA
df = df[df['area'] < MAX_AREA]


# plot the data. Use x,y plot area against cells with titles
plt.title("Cell count vs. area up to area " + str(MAX_AREA))
plt.plot(df['area'], df['cell count full'], 'o')
plt.xlabel('area')
plt.ylabel('cell count full')
plt.show()
