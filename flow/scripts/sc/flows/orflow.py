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

    flow_groups = {
        #'presynth': [
        #    ('or_synth_hier_report', 'yosys'),
        #],
        'synthesis': [
            ('or_synth', 'yosys'), # (synthesis is done via OpenROAD TCL that calls yosys)
        ],
        'floorplan': [
            ('or_floorplan', 'openroad'),
            ('or_io_placement_random', 'openroad'),
            ('or_tdms_place', 'openroad'),
            ('or_macro_place', 'openroad'),
            ('or_tapcell', 'openroad'),
            ('or_pdn', 'openroad'),
        ],
        'place': [
            ('or_global_place_skip_io', 'openroad'),
            ('or_io_placement', 'openroad'),
            ('or_global_place', 'openroad'),
            ('or_resize', 'openroad'),
            ('or_detail_place', 'openroad'),
        ],
        'cts': [
            ('or_cts', 'openroad'),
            ('or_fillcell', 'openroad'),
        ],
        'route': [
            ('or_global_route', 'openroad'),
            ('or_detail_route', 'openroad'),
        ],
        'finish': [
            ('or_final_report', 'openroad'),
            # Like yosys, KLayout GDS-streaming script is run through an OpenROAD tcl script
            ('or_export', 'klayout')
        ]
    }
    #flowpipe = ['presynth', 'synthesis', 'floorplan', 'place', 'cts', 'route', 'finish']
    flowpipe = ['synthesis', 'floorplan', 'place', 'cts', 'route', 'finish']

    # Additional dependencies defined here
    extra_deps = {
        'or_detail_route': ['or_fillcell'], # reads 4_cts.odb
    }

    chip.node(flow, 'import', 'nop')
    last_step = 'import'
    last_sdc_step = ''
    for group in flowpipe:
        for step, tool in flow_groups[group]:
            chip.node(flow, step, tool)

            if last_step:
                chip.edge(flow, last_step, step)
            if last_sdc_step and last_sdc_step != last_step:
                chip.edge(flow, last_sdc_step, step)
            if step in extra_deps:
                for dep in extra_deps[step]:
                    chip.edge(flow, dep, step)

            last_step = step

            if step == 'or_export':
                chip.set('tool', tool, 'script', step, '0', 'def2stream.py')
                chip.set('tool', tool, 'refdir', step, '0', os.path.join(openroad_dir, 'flow', 'util'))
            else:
                chip.set('tool', tool, 'script', step, '0', 'sc_apr.tcl')
                chip.set('tool', tool, 'refdir', step, '0', os.path.join(openroad_dir, 'flow', 'scripts', 'sc', 'tools', 'openroad'))

        # Each step in a flow group relies on an SDC produced by (or copied
        # into) the first step of the previous flow group.
        last_sdc_step, _ = flow_groups[group][0]

    # Set default goal
    for step in chip.getkeys('flowgraph', flow):
        chip.set('flowgraph', flow, step, '0', 'goal', 'errors', 0)

if __name__ == '__main__':
    chip = siliconcompiler.Chip('<design>')
    setup(chip)
    chip.set('option', 'flow', 'orflow')
    chip.write_flowgraph('orflow.png')
