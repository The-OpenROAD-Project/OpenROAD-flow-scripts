import os
import subprocess
import tempfile

def parse(path):
    '''Parse env variables defined in a Makefile fragment'''
    env_before = os.environ

    with tempfile.TemporaryDirectory() as tempdir:
        makefile_path = os.path.join(tempdir, 'Makefile')
        with open(makefile_path, 'w') as f:
            print(f'include {path}', file=f)
            print(f'all:', file=f)
            print(f'\tprintenv', file=f)

        proc = subprocess.run(['make', '-s', '--no-print-directory', '-f', makefile_path], stdout=subprocess.PIPE)
        output = proc.stdout.decode('utf-8')

    new_envvars = {}
    assignments = output.split('\n')
    for assignment in assignments:
        if (not assignment) or (not '=' in assignment):
            # skip blank lines
            # only process lines with an assignment. (Ignore lines produced by e.g. `$(info [...])`)
            continue

        var, val = assignment.split('=', 1)
        if var in ('MAKEFLAGS', 'MFLAGS', 'MAKE_TERMERR', 'MAKE_TERMERR', 'MAKELEVEL'):
            # skip envvars that Make adds
            continue

        if var not in env_before:
            new_envvars[var] = val

    return new_envvars

if __name__ == '__main__':
    vars = parse_config_mk('./designs/nangate45/bp_fe_top/config.mk')
    print(vars)
