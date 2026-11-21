#!/usr/bin/env python3
"""Write the flow's variables as vars files: <basename>.sh, .tcl and .gdb.

`make vars` and `make <step>_issue` write them, so that a step can be run
by hand, under gdb or from an issue archive on another machine:

    source vars.sh       # bash
    source vars.tcl      # openroad, yosys
    source vars.gdb      # gdb --args openroad ...

The variables come from ISSUE_VARIABLES, which the flow's Makefile
exports as one NAME=value per line. Paths are spelled through FLOW_HOME,
and paths under WORK_HOME and a docker image's /workspace and /platforms
are made relative, so that the files work wherever the flow is unpacked;
PRESERVE_PATHS keeps every other path as it is.

Usage: generate_vars.py <basename>
"""

import os
import re
import sys

# The make machinery's and the machine's own variables, which mean
# nothing on another machine.
EXCLUDED_VARS = re.compile(
    r"^("
    r"MAKE|MAKEFLAGS|PERL5LIB|QT_QPA_PLATFORM"
    r"|RESULTS_ODB|PUBLIC|ISSUE_SCRIPTS"
    r"|HOME|PWD|MAIL|SHELL|NPROC|NUM_CORES|FLOW_HOME|\\n"
    r"|UNSET_VARIABLES_NAMES|do-step|get_variables|do-copy"
    r"|CURDIR|OPEN_GUI|OPEN_GUI_SHORTCUT"
    r"|COMMAND_LINE_ARGS"
    r")$"
)

# Executables and commands are machine specific, as are search paths;
# a name with a dot is not a shell variable.
EXCLUDED_PATTERNS = re.compile(r"_EXE$|PATH$|_CMD$|\.")

# A path in a value starts at the value's start or after a separator.
SEPARATOR = "[: \"']"

SH_HEADER = (
    "export FLOW_HOME=${FLOW_HOME:-$(pwd)}\n"
    # *_EXE paths are machine specific and excluded; default to PATH lookup.
    "export PYTHON_EXE=${PYTHON_EXE:-python3}\n"
)
TCL_HEADER = "if { ![info exists env(PYTHON_EXE)] } { set env(PYTHON_EXE) python3 }\n"


def path_pattern(path):
    """A path as a pattern that matches it where it appears in a value."""
    return re.escape(path)


def replace_path(value, path, replacement):
    return re.sub(path_pattern(path), lambda _: replacement, value)


def variables(issue_variables):
    """The (name, value) pairs of ISSUE_VARIABLES that belong in the vars
    files, in order: one NAME=value per line, surrounding blanks ignored,
    the value everything after the first '='."""
    for line in issue_variables.split("\n"):
        line = line.strip(" \t")
        if "=" not in line:
            continue
        name, value = line.split("=", 1)
        if name[:1].isdigit():
            # not a valid shell name
            continue
        if value == "''":
            # make's spelling of an empty value
            value = ""
        if "MAKEFILE" in name:
            continue
        if EXCLUDED_VARS.search(name) or EXCLUDED_PATTERNS.search(name):
            continue
        yield name, value


def relative_value(name, value, env, flow_root, orfs_root, work_root):
    """The value with its paths spelled so that it works on another
    machine."""
    if "SCRIPTS_DIR" in name:
        # the scripts are in the archive, next to the vars files
        value = replace_path(value, flow_root, ".")

    if "PRESERVE_PATHS" not in env:
        # Paths under WORK_HOME (a CI workspace, say) are relative to the
        # archive's root, where makeIssue.py stores those files. Both the
        # literal and the symlink-resolved WORK_HOME may appear. WORK_HOME
        # inside FLOW_HOME is spelled through FLOW_HOME below.
        for work_path in [env.get("WORK_HOME") or ".", work_root]:
            if work_path.endswith("/"):
                work_path = work_path[:-1]
            if work_path.startswith("/") and work_path != flow_root:
                # a path boundary after it, so that /tmp/work does not
                # match /tmp/work_other
                value = re.sub(
                    f"(^|{SEPARATOR}){path_pattern(work_path)}(/|{SEPARATOR}|$)",
                    lambda m: m.group(1) + "." + m.group(2),
                    value,
                )
        for path in ["workspace", "platforms"]:
            value = re.sub(
                f"(^|{SEPARATOR})/{path}",
                lambda m, path=path: m.group(1) + "./" + path,
                value,
            )

    value = replace_path(value, flow_root, "${FLOW_HOME}")
    return replace_path(value, orfs_root, "${FLOW_HOME}/..")


def write_vars(basename, env):
    """Writes <basename>.sh, .tcl and .gdb from env's ISSUE_VARIABLES."""
    flow_root = os.path.realpath(env["FLOW_HOME"])
    orfs_root = os.path.realpath(env["FLOW_HOME"] + "/../")
    work_root = os.path.realpath(env.get("WORK_HOME") or ".")

    sh = [SH_HEADER]
    tcl = [TCL_HEADER]
    gdb = []
    for name, value in variables(env["ISSUE_VARIABLES"]):
        value = relative_value(name, value, env, flow_root, orfs_root, work_root)
        sh.append(f'export {name}="{value}"\n')
        if "$" in value:
            gdb_value = value.replace("${FLOW_HOME}", 'getenv("FLOW_HOME")')
            tcl_value = value.replace("${FLOW_HOME}", "$::env(FLOW_HOME)")
            gdb.append(f"set env {name} {gdb_value}\n")
            tcl.append(f'set env({name}) "{tcl_value}"\n')
        else:
            tcl.append(f'set env({name}) "{value}"\n')
            gdb.append(f"set env {name} {value}\n")

    for ext, lines in [("sh", sh), ("tcl", tcl), ("gdb", gdb)]:
        with open(f"{basename}.{ext}", "w") as f:
            f.write("".join(lines))


def main():
    if len(sys.argv) != 2:
        sys.exit(f"usage: {sys.argv[0]} <basename>")
    write_vars(sys.argv[1], os.environ)


if __name__ == "__main__":
    main()
