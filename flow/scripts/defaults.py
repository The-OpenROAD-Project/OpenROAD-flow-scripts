#!/usr/bin/env python3

import os
import subprocess
import sys
import yaml
from types import MappingProxyType

# fewer edge cases as unset env vars are passed in as blank env vars
# from make
env_canonical = {key: value for key, value in os.environ.items() if value != ""}

config_py = os.path.join(os.environ["PLATFORM_DIR"], "config.py")
if os.path.exists(config_py):
    sys.path.append(os.path.dirname(config_py))
    import config

    get_platform_defaults = config.get_defaults
else:

    def get_platform_defaults(variables):
        return {}


def get_num_cores():
    """Determine the number of CPU cores available."""
    try:
        # Linux (utility program)
        num_cores = int(
            subprocess.check_output(["nproc"], stderr=subprocess.DEVNULL).strip()
        )
    except (subprocess.CalledProcessError, FileNotFoundError):
        try:
            # Linux (generic)
            with open("/proc/cpuinfo", "r") as f:
                num_cores = sum(1 for line in f if line.startswith("processor"))
        except FileNotFoundError:
            try:
                # BSD (at least FreeBSD and macOS)
                num_cores = int(
                    subprocess.check_output(
                        ["sysctl", "-n", "hw.ncpu"], stderr=subprocess.DEVNULL
                    ).strip()
                )
            except (subprocess.CalledProcessError, FileNotFoundError):
                # Fallback
                num_cores = 1
    return num_cores


def env_blank(name):
    return name not in env_canonical or env_canonical[name] == ""


def env_get(name):
    """Get the value of an environment variable, or
    raise an error if it is not set or blank.

    Invocations from "make" will pass in blank values instead of
    unset when the variable is unset
    """
    if env_blank(name):
        raise ValueError(f"Environment variable {name} is not set.")
    return env_canonical[name]


def get_time_cmd(time_bin):
    """Set up the time command with appropriate formatting."""
    time_cmd = f"{time_bin} -f 'Elapsed time: %E[h:]min:sec. CPU time: user %U sys %S (%P). Peak memory: %MKB.'"

    try:
        # Test if the time command works
        subprocess.run(
            f"{time_cmd} echo foo",
            shell=True,
            check=True,
            stderr=subprocess.DEVNULL,
            stdout=subprocess.DEVNULL,
        )
    except subprocess.CalledProcessError:
        # Fallback to a simpler time command if the test fails
        time_cmd = time_bin

    return time_cmd


def main():
    dir_path = os.path.dirname(os.path.realpath(__file__))

    yaml_path = os.path.join(dir_path, "variables.yaml")
    with open(yaml_path, "r") as file:
        info = yaml.safe_load(file)

    variables = {
        name: value["default"] for name, value in info.items() if "default" in value
    }

    # 'variables' is a dictionary that contains settings. Historically,
    # these settings were managed in variables in the Makefile. We are
    # moving code from the Makefile to Python to generate the
    # entries in the 'variables' dictionary.
    if env_blank("WORK_HOME"):
        variables["WORK_HOME"] = "."
    else:
        variables["WORK_HOME"] = env_get("WORK_HOME")

    if env_blank("FLOW_HOME"):
        variables["FLOW_HOME"] = os.path.join(os.path.dirname(__file__), "..")
    else:
        variables["FLOW_HOME"] = env_get("FLOW_HOME")

    for name in ["PLATFORM", "DESIGN_NAME", "PLATFORM_DIR", "FLOW_VARIANT"]:
        variables[name] = env_get(name)

    if env_blank("DESIGN_NICKNAME"):
        variables["DESIGN_NICKNAME"] = variables["DESIGN_NAME"]
    else:
        variables["DESIGN_NICKNAME"] = env_get("DESIGN_NICKNAME")

    for name, folder in [
        ("OBJECTS_DIR", "objects"),
        ("REPORTS_DIR", "reports"),
        ("RESULTS_DIR", "results"),
        ("LOG_DIR", "logs"),
    ]:
        variables[name] = os.path.join(
            variables["WORK_HOME"],
            folder,
            variables["PLATFORM"],
            variables["DESIGN_NICKNAME"],
            variables["FLOW_VARIANT"],
        )

    append_semantics = [
        "ADDITIONAL_LEFS",
        "ADDITIONAL_LIBS",
        "ADDITIONAL_GDS",
        "LIB_FILES",
        "GDS_FILES",
    ]

    for key in ["ASAP7_USELVT", "ASAP7_USESLVT", "CLUSTER_FLOPS"]:
        if key in env_canonical:
            variables[key] = env_canonical[key]

    # the platform overrides the defaults from variables.yaml, but need
    # OBJECTS_DIR. make handles such dependencies differently, it has
    # late and immediate expansion of variables.
    variables |= get_platform_defaults(MappingProxyType(variables))

    if env_blank("NUM_CORES"):
        variables["NUM_CORES"] = get_num_cores()
    else:
        variables["NUM_CORES"] = env_get("NUM_CORES")

    if env_blank("TIME_BIN"):
        variables["TIME_BIN"] = "env time"
    else:
        variables["TIME_BIN"] = env_get("TIME_BIN")
    variables["TIME_CMD"] = get_time_cmd(variables["TIME_BIN"])

    if not env_blank("IN_NIX_SHELL"):
        variables["OPENROAD_EXE"] = subprocess.getoutput("command -v openroad")
        variables["OPENSTA_EXE"] = subprocess.getoutput("command -v sta")
    else:
        variables["OPENROAD_EXE"] = (
            os.path.abspath(
                os.path.join(
                    variables["FLOW_HOME"], "../tools/install/OpenROAD/bin/openroad"
                )
            )
            if env_blank("OPENROAD_EXE")
            else env_get("OPENROAD_EXE")
        )
        variables["OPENSTA_EXE"] = (
            os.path.abspath(
                os.path.join(
                    variables["FLOW_HOME"], "../tools/install/OpenROAD/bin/sta"
                )
            )
            if env_blank("OPENSTA_EXE")
            else env_get("OPENSTA_EXE")
        )

    variables["OPENROAD_ARGS"] = (
        f"-no_init -threads {variables['NUM_CORES']} {variables.get('OR_ARGS', '')}"
    )
    variables["OPENROAD_CMD"] = (
        f"{variables['OPENROAD_EXE']} -exit {variables['OPENROAD_ARGS']}"
    )
    variables["OPENROAD_NO_EXIT_CMD"] = (
        f"{variables['OPENROAD_EXE']} {variables['OPENROAD_ARGS']}"
    )
    variables["OPENROAD_GUI_CMD"] = (
        f"{variables['OPENROAD_EXE']} -gui {variables.get('OR_ARGS', '')}"
    )

    if not env_blank("IN_NIX_SHELL"):
        variables["YOSYS_EXE"] = subprocess.getoutput("command -v yosys")
    else:
        variables["YOSYS_EXE"] = (
            os.path.abspath(
                os.path.join(variables["FLOW_HOME"], "../tools/install/yosys/bin/yosys")
            )
            if env_blank("YOSYS_EXE")
            else env_get("YOSYS_EXE")
        )

    KLAYOUT_DIR = os.path.abspath(
        os.path.join(variables["FLOW_HOME"], "../tools/install/klayout/")
    )
    KLAYOUT_BIN_FROM_DIR = os.path.join(KLAYOUT_DIR, "klayout")
    if os.path.exists(KLAYOUT_BIN_FROM_DIR):
        variables["KLAYOUT_CMD"] = (
            f"sh -c 'LD_LIBRARY_PATH={os.path.dirname(KLAYOUT_BIN_FROM_DIR)} $$0 \"$$@\"' {KLAYOUT_BIN_FROM_DIR}"
        )
    else:
        if env_blank("KLAYOUT_CMD"):
            variables["KLAYOUT_CMD"] = "klayout"
        else:
            variables["KLAYOUT_CMD"] = env_get("KLAYOUT_CMD")
    if len(variables["KLAYOUT_CMD"]) == 0:
        variables["KLAYOUT_CMD"] = subprocess.getoutput("command -v klayout")

    if env_blank("PLATFORM_HOME"):
        variables["PLATFORM_HOME"] = os.path.join(variables["FLOW_HOME"], "platforms")
    else:
        variables["PLATFORM_HOME"] = env_get("PLATFORM_HOME")
    if env_blank("UTILS_DIR"):
        variables["UTILS_DIR"] = os.path.join(variables["FLOW_HOME"], "util")
    else:
        variables["UTILS_DIR"] = env_get("UTILS_DIR")
    if env_blank("SCRIPTS_DIR"):
        variables["SCRIPTS_DIR"] = os.path.join(variables["FLOW_HOME"], "scripts")
    else:
        variables["SCRIPTS_DIR"] = env_get("SCRIPTS_DIR")
    if env_blank("PLATFORM_DIR"):
        variables["PLATFORM_DIR"] = os.path.join(
            variables["PLATFORM_HOME"], variables["PLATFORM"]
        )
    else:
        variables["PLATFORM_DIR"] = env_get("PLATFORM_DIR")

    variables["ORFS_DEFAULTS_LOADED"] = "1"

    for key, value in variables.items():
        value = str(value).replace(" ", "__SPACE__")
        append = key in append_semantics
        if sys.argv[1] == "make":
            print(f'export {key}{"+" if append else "?"}={value}')
        elif sys.argv[1] == "bash":
            print(
                f'export {key}="'
                + (f"{value}" if append else ("${" + f"{key}:-{value}" + "}"))
                + '"'
            )
        else:
            print(f"{key}={value}")


if __name__ == "__main__":
    main()
