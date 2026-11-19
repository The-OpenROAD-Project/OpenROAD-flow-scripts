#!/usr/bin/env python3
"""Archive a flow step as a self-contained reproducible: `make <step>_issue`.

The archive holds the step's inputs (the flow's logs, objects, reports and
results, the scripts, the design and platform files the flow variables
name), a vars file with every flow variable, and a run-me script that runs
the step from wherever the archive is unpacked.

Usage: makeIssue.py <WORK_HOME>/<step>

The flow's Makefile exports the variables this reads (WORK_HOME, the
*_DIR variables, DESIGN_NICKNAME, PLATFORM, FLOW_VARIANT, ...) and
ISSUE_VARIABLES, which generate_vars.py writes into the vars files.
"""

import datetime
import glob
import os
import re
import shutil
import subprocess
import sys

import yaml

import generate_vars

UTILS_DIR = os.path.dirname(os.path.abspath(__file__))

# variables.yaml describes every flow variable; `type: file` marks the
# ones that name files a step may read.
VARIABLES_YAML = os.path.join(UTILS_DIR, "..", "scripts", "variables.yaml")

# Platform files dropped from the archive with EXCLUDE_PLATFORM: a name
# that ends in lib, lef or tlef after any character.
PLATFORM_LIBRARY = re.compile(r".(lib|lef|tlef)$", re.IGNORECASE)

YOSYS_SCRIPT = re.compile(r"synth_preamble|yosys -import")


def expand(words):
    """Splits on whitespace and expands each glob, as an unquoted shell
    word would be; a glob that matches nothing stays as written."""
    expanded = []
    for word in words.split():
        matches = sorted(glob.glob(word))
        expanded.extend(matches if matches else [word])
    return expanded


def platform_globs(platform_dir):
    """The platform's Tcl scripts, and its SDC and .cfg files if it has any."""
    globs = [f"{platform_dir}/*.tcl"]
    for ext in ["sdc", "cfg"]:
        if glob.glob(f"{platform_dir}/*.{ext}"):
            globs.append(f"{platform_dir}/*.{ext}")
    return globs


def flow_variables():
    with open(VARIABLES_YAML) as f:
        return yaml.safe_load(f)


def file_variables():
    """The flow variables that name files: `type: file` in
    variables.yaml."""
    return sorted(
        name
        for name, variable in flow_variables().items()
        if variable.get("type") == "file"
    )


def platform_file_variables():
    """The file variables that name the platform's files, wherever the
    platform keeps them: `platform: true` in variables.yaml."""
    return sorted(
        name
        for name, variable in flow_variables().items()
        if variable.get("type") == "file" and variable.get("platform")
    )


def in_platform(path, platform_dir):
    """Whether the file lies under the platform directory, as it is
    named or through a symlink."""
    return any(
        resolve(path).startswith(resolve(platform_dir) + os.sep)
        for resolve in [os.path.abspath, os.path.realpath]
    )


def issue_files(env, vars_basename, run_me_script):
    """The files the flow variables name, the platform's scripts and the
    issue's own vars and run-me files, sorted and without duplicates.
    EXCLUDE_PLATFORM leaves out the files the platform's variables name
    and the files under the platform directory, whichever variable names
    them."""
    names = file_variables()
    words = []
    if "EXCLUDE_PLATFORM" in env:
        platform = platform_file_variables()
        names = [name for name in names if name not in platform]
    else:
        words += platform_globs(env["PLATFORM_DIR"])
    files = expand(" ".join(env[name] for name in names if name in env))
    if "EXCLUDE_PLATFORM" in env:
        files = [f for f in files if not in_platform(f, env["PLATFORM_DIR"])]
    words += [
        f"{env['UTILS_DIR']}/def2stream.py",
        run_me_script,
        f"{vars_basename}.sh",
        f"{vars_basename}.tcl",
        f"{vars_basename}.gdb",
    ]
    return sorted(set(files + expand(" ".join(words))))


def is_yosys_step(script):
    with open(script) as f:
        return YOSYS_SCRIPT.search(f.read()) is not None


def archive_root_from_run_me(work_home, vars_basename):
    """Where run-me changes to, relative to its own directory, and the vars
    file's path from there: the archive's root, where the vars' paths
    start. run-me is at the root when WORK_HOME is absolute (its path is
    stripped from the members) or the flow directory; a relative WORK_HOME
    keeps its place under the root, and run-me climbs back from it."""
    here = os.path.realpath(".")
    if work_home.startswith("/") or os.path.realpath(work_home) == here:
        return None, f"./{os.path.basename(vars_basename)}.sh"
    root = os.path.relpath(here, os.path.realpath(work_home))
    vars_path = os.path.relpath(os.path.realpath(vars_basename), here)
    return root, f"./{vars_path}.sh"


def run_me_text(env, issue_target, vars_basename, yosys):
    """The run-me script: it changes to the archive's root, sources the
    vars file from there and runs the step's script."""
    root, vars_path = archive_root_from_run_me(
        env.get("WORK_HOME") or ".", vars_basename
    )
    run_me_dir = '"$(dirname "$0")"' if root is None else f'"$(dirname "$0")/{root}"'
    lines = [
        "#!/usr/bin/env bash",
        f"cd {run_me_dir}",
        f"source {vars_path}",
    ]
    script = "${SCRIPTS_DIR}/" + issue_target + ".tcl"
    if yosys:
        lines.append(f"yosys {env.get('YOSYS_FLAGS', '')} -c {script}")
    else:
        threads = env.get("NUM_CORES") or "1"
        openroad = f"openroad -no_init -threads {threads} {script}"
        lines += [
            "if [[ ! -z ${GDB+x} ]]; then",
            f"    gdb --args {openroad}",
            "else",
            f"    {openroad}",
            "fi",
        ]
    return "\n".join(lines) + "\n"


def write_executable(path, text):
    with open(path, "w") as f:
        f.write(text)
    umask = os.umask(0)
    os.umask(umask)
    os.chmod(path, os.stat(path).st_mode | (0o111 & ~umask))


def compressor():
    """pigz compresses in parallel; gzip when it is not installed."""
    return "pigz" if shutil.which("pigz") else "gzip"


def tar_transforms(issue_name, flow_home, work_home):
    """Member names under the issue's directory, with the FLOW_HOME and
    WORK_HOME prefixes stripped, so files generated outside FLOW_HOME (a
    CI workspace) land at the archive's root instead of recreating the
    absolute path. Both the literal and the symlink-resolved WORK_HOME
    may appear in member names."""
    work_root = os.path.realpath(work_home)
    transforms = [
        f"s|^|{issue_name}/|S",
        f"s|^{issue_name}{flow_home}/|{issue_name}/|S",
        f"s|^{issue_name}{work_root}//*|{issue_name}/|S",
    ]
    literal = work_home.rstrip("/")
    if work_home.startswith("/") and literal != work_root:
        transforms.append(f"s|^{issue_name}{literal}//*|{issue_name}/|S")
    return ["--transform=" + t for t in transforms]


def design_platform_files(env):
    if "FULL_ISSUE" in env:
        return expand(f"{env['DESIGN_DIR']} {env['PLATFORM_DIR']}")
    return expand(f"{env['DESIGN_CONFIG']} {env['PLATFORM_DIR']}/config*.mk")


def tar_command(env, tar_name, issue_name, files):
    return (
        [
            "tar",
            f"--use-compress-program={compressor()}",
            "--ignore-failed-read",
            "-chf",
            tar_name,
        ]
        + tar_transforms(issue_name, env["FLOW_HOME"], env.get("WORK_HOME") or ".")
        + design_platform_files(env)
        + expand(
            " ".join(
                env[name]
                for name in [
                    "LOG_DIR",
                    "OBJECTS_DIR",
                    "REPORTS_DIR",
                    "RESULTS_DIR",
                    "SCRIPTS_DIR",
                ]
            )
        )
        + files
    )


def exclude_platform_library(tar_name):
    """Drops the liberty and LEF files from the archive."""
    tar = tar_name[: -len(".gz")]
    subprocess.run(["gunzip", "-f", tar_name], check=True)
    members = subprocess.run(
        ["tar", "--list", "--file", tar],
        check=True,
        stdout=subprocess.PIPE,
        universal_newlines=True,
    ).stdout.splitlines()
    library = [m for m in members if PLATFORM_LIBRARY.search(m)]
    if library:
        subprocess.run(["tar", "--delete", "--file", tar] + library, check=True)
    subprocess.run(["gzip", tar], check=True)


def make_issue(target, env):
    issue_target = os.path.basename(target)
    issue_dest = os.path.dirname(target) or "."
    print(f"Creating issue for target {issue_target} in {issue_dest}", flush=True)

    date = datetime.datetime.now().strftime("%Y-%m-%d_%H-%M")
    issue_tag = env.get("ISSUE_TAG") or (
        f"{env['DESIGN_NICKNAME']}_{env['PLATFORM']}_{env['FLOW_VARIANT']}_{date}"
    )
    flow_name = f"{env['DESIGN_NICKNAME']}-{env['PLATFORM']}-{env['FLOW_VARIANT']}"
    vars_basename = f"{env['WORK_HOME']}/vars-{flow_name}"
    run_me_script = f"{env['WORK_HOME']}/run-me-{flow_name}.sh"

    files = issue_files(env, vars_basename, run_me_script)

    yosys = is_yosys_step(f"{env['SCRIPTS_DIR']}/{issue_target}.tcl")
    write_executable(
        run_me_script, run_me_text(env, issue_target, vars_basename, yosys)
    )

    generate_vars.write_vars(vars_basename, env)

    issue_name = f"{issue_target}_{issue_tag}"
    tar_name = f"{issue_dest}/{issue_name}.tar.gz"
    print(f"Archiving issue to {tar_name}", flush=True)
    print(f"Using {compressor()} to compress tar file", flush=True)
    subprocess.run(tar_command(env, tar_name, issue_name, files), check=True)

    if "EXCLUDE_PLATFORM" in env:
        exclude_platform_library(tar_name)

    if "COPY_ISSUE" in env:
        os.makedirs(env["COPY_ISSUE"], exist_ok=True)
        shutil.copy(tar_name, env["COPY_ISSUE"])
    return tar_name


def main():
    if len(sys.argv) != 2:
        sys.exit(f"usage: {sys.argv[0]} <WORK_HOME>/<step>")
    make_issue(sys.argv[1], dict(os.environ))


if __name__ == "__main__":
    main()
