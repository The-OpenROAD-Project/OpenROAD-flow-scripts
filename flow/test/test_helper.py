#!/usr/bin/env python3

import argparse
import os
import subprocess
import sys

def run_command(command, log_file, append=False):
    mode = 'a' if append else 'w'
    with open(log_file, mode) as log:
        process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        for line in process.stdout:
            sys.stdout.write(line.decode())
            log.write(line.decode())
        process.wait()
        return process.returncode

def main():
    parser = argparse.ArgumentParser(description="Run design flow script")
    parser.add_argument('design_name', default='gcd', nargs='?', help='Design name')
    parser.add_argument('platform', default='nangate45', nargs='?', help='Platform')
    parser.add_argument('config_mk', default='config.mk', nargs='?', help='Configuration file')
    parser.add_argument('--flow_variant', help='Flow variant')
    parser.add_argument('--private_dir', default='../../private_tool_scripts', help='Private directory')
    parser.add_argument('--save_to_db', action='store_true', help='Save to metrics database')
    parser.add_argument('--run_calibre', action='store_true', help='Run calibre DRC')
    parser.add_argument('--check_drc_db', action='store_true', help='Check DRC database')
    parser.add_argument('--make_issue', action='store_true', help='Create final report issue')

    args = parser.parse_args()

    design_config = f"./designs/{args.platform}/{args.design_name}/{args.config_mk}"
    log_file = f"./logs/{args.platform}/{args.design_name}.log"
    os.makedirs(os.path.dirname(log_file), exist_ok=True)

    make_command = f"make DESIGN_CONFIG={design_config}"
    if args.flow_variant:
        make_command += f" FLOW_VARIANT={args.flow_variant}"

    ret = 0

    ret += run_command(f"{make_command} clean_all clean_metadata", log_file)

    ret += run_command(f"{make_command} finish metadata", log_file, append=True)

    if os.path.isfile(f"{args.private_dir}/openRoad/private.mk") and args.save_to_db:
        ret += run_command(f"{make_command} save_to_metrics_db", log_file, append=True)

    if os.path.isfile(f"{args.private_dir}/util/utils.mk") and args.run_calibre:
        ret += run_command(f"{make_command} calibre_drc", log_file, append=True)
        ret += run_command(f"{make_command} convert_calibre", log_file, append=True)
        if args.save_to_db:
            ret += run_command(f"{make_command} save_to_drc_db", log_file, append=True)
        if args.check_drc_db:
            ret += run_command(f"{make_command} check_drc_db", log_file, append=True)

    if args.make_issue:
        ret += run_command(f"{make_command} final_report_issue", log_file, append=True)

    sys.exit(ret)

if __name__ == '__main__':
    script_dir = os.path.dirname(os.path.realpath(__file__))
    parent_dir = os.path.abspath(os.path.join(script_dir, os.pardir))
    os.chdir(parent_dir)
    
    main()
