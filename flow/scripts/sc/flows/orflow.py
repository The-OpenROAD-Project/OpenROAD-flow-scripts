import os
import siliconcompiler
import re

openroad_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..', '..'))

def make_docs():
    # TODO: Docs

    chip = siliconcompiler.Chip('<topmodule>')
    chip.set('option', 'flow', 'orflow')
    setup(chip)

    return chip

###########################################################################
# Flowgraph Setup
############################################################################
def setup(chip, flowname='orflow'):
    '''
    Setup function for 'orflow' implementation of the OpenROAD-flow-scripts build process.

    Args:
        chip (object): SC Chip object

    TODO: Fully support all environment variables used by the scripts
    '''

    # Set mandatory mode
    chip.set('option', 'mode', 'asic')

    # Set showtools for sc-show
    chip.set('option', 'showtool', 'def', 'klayout')
    chip.set('option', 'showtool', 'gds', 'klayout')

    # Setup empty 'import' stage with a single-node OpenROAD task to run 'run_all.tcl'
    # TODO: Use the 'import' step to parse config.mk file env vars.
    # TODO: Split up individual TCL scripts into sc tasks?
    flow = 'orflow'
    flowpipe = {
        'import': ['nop', ''],
        'syn': ['openroad', 'yosys.tcl'], # (synthesis is done via OpenROAD TCL that calls yosys)
        'init_floorplan': ['openroad', 'floorplan.tcl'],
        'io_place_rand': ['openroad', 'io_placement_random.tcl'],
        'tdms_place': ['openroad', 'tdms_place.tcl'],
        'macro_place': ['openroad', 'macro_place.tcl'],
        'tapcell': ['openroad', 'tapcell.tcl'],
        'pdn': ['openroad', 'pdn.tcl'],
        'gp_skip_io': ['openroad', 'global_place_skip_io.tcl'],
        'io_place': ['openroad', 'io_placement.tcl'],
        'global_place': ['openroad', 'global_place.tcl'],
        'resize': ['openroad', 'resize.tcl'],
        'detail_place': ['openroad', 'detail_place.tcl'],
        'clock_tree_syn': ['openroad', 'cts.tcl'],
        'fillcells': ['openroad', 'fillcell.tcl'],
        'global_route': ['openroad', 'global_route.tcl'],
        'detail_route': ['openroad', 'detail_route.tcl'],
        'final_report': ['openroad', 'final_report.tcl'],
        # Like yosys, KLayout GDS-streaming script is run through an OpenROAD tcl script
        'export': ['openroad', 'klayout.tcl'],
    }
    last_step = ''
    for k,v in flowpipe.items():
        chip.node(flow, k, v[0])
        if last_step:
            chip.edge(flow, last_step, k)
        if v[1]:
            chip.set('tool', v[0], 'script', k, '0',
                     os.path.abspath(os.path.join(openroad_dir, 'flow', 'scripts', v[1])))
            chip.set('tool', v[0], 'refdir', k, '0', os.path.join('tools', v[0]))
        last_step = k

    # Set default goal
    for step in chip.getkeys('flowgraph', flow):
        chip.set('flowgraph', flow, step, '0', 'goal', 'errors', 0)
