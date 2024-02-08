import json
import pandas as pd
import matplotlib.pyplot as plt
import synth_keep

# Load the first JSON file
with open('objects/nangate45/bp_multi/base/synth_full.json', 'r') as file:
    data_a = json.load(file)

# Load the second JSON file
with open('objects/nangate45/bp_multi/base/synth.json', 'r') as file:
    data_b = json.load(file)

# Get the cell counts for each module in each file
# create dictionary of module names and their area, strip the \ in front of module name
# Area of module \bsg_mem_1r1w_synth_width_p99_els_p2_read_write_same_addr_p0_harden_p0 is 1821.834000
with open('reports/nangate45/bp_multi/base/synth_cmos.txt', 'r') as file:
    cmos = json.load(file)
    transistors = {name.replace('\\', ''):
                   int(module['estimated_num_transistors'].replace('+', ''))
                   for name, module in cmos['modules'].items()}


def count_transistors(name, modules):
    count = 0
    module = data_a['modules'][name]
    for cell in module["cells"].values():
        if cell["type"] in modules:
            count += count_transistors(cell["type"], modules)
    count += transistors[name]
    return count


# Get the cell counts for each module in each file
cell_counts_a = {name: count_transistors(name, data_a['modules'])
                 for name in data_a['modules']}

cell_counts_b = {name: synth_keep.count_cells(module, data_b['modules'])
                 for name, module in data_b['modules'].items()}

# Create a DataFrame from the cell counts
df = pd.DataFrame(list(zip(cell_counts_a.keys(), cell_counts_a.values(), cell_counts_b.values())), 
                  columns=['name', 'cell count full', 'cell count fast'])

# number of cells to ungroup (i.e. flatten)
MAX_PLOT_SIZE = 2000
MAX_UNGROUP_SIZE = 200
# create four datasets:
# 1. where it should have been flattened
# 2. where it should not have been flattened
# 3. where the result is the same in either case
# 4. flattend in both cases as it should have
df1 = df[(df['cell count full'] > MAX_UNGROUP_SIZE) & (df['cell count fast'] <= MAX_UNGROUP_SIZE) & (df['cell count full'] <= MAX_PLOT_SIZE) & (df['cell count fast'] <= MAX_PLOT_SIZE)]
df2 = df[(df['cell count full'] <= MAX_UNGROUP_SIZE) & (df['cell count fast'] > MAX_UNGROUP_SIZE) & (df['cell count full'] <= MAX_PLOT_SIZE) & (df['cell count fast'] <= MAX_PLOT_SIZE) & df['cell count fast'] > 1]
df3 = df[(df['cell count full'] <= MAX_UNGROUP_SIZE) & (df['cell count fast'] <= MAX_UNGROUP_SIZE) & (df['cell count full'] <= MAX_PLOT_SIZE) & (df['cell count fast'] <= MAX_PLOT_SIZE)]
df4 = df[(df['cell count full'] > MAX_UNGROUP_SIZE) & (df['cell count fast'] > MAX_UNGROUP_SIZE) & (df['cell count full'] <= MAX_PLOT_SIZE) & (df['cell count fast'] <= MAX_PLOT_SIZE)]

# plot the data. Use x,y plot
plt.title("Cell count comparison for MAX_UNGROUP_SIZE=" + str(MAX_UNGROUP_SIZE))
plt.plot(df1['cell count full'], df1['cell count fast'], 'o', label='should have been flattend')
plt.plot(df2['cell count full'], df2['cell count fast'], 'x', label='should not have flattened')
plt.plot(df3['cell count full'], df3['cell count fast'], '.', label='flattened in either case')
plt.plot(df4['cell count full'], df4['cell count fast'], '*', label='flattened in neither case')
plt.xlabel('cell count full')
plt.ylabel('cell count fast')
plt.legend()
plt.show()
