#!/bin/bash
set -u

# Set default paths
export PLATFORM_HOME="${PLATFORM_HOME:-${FLOW_HOME}/platforms}"
export WORK_HOME="${WORK_HOME:-.}"
export SCRIPTS_DIR="${SCRIPTS_DIR:-${FLOW_HOME}/scripts}"

# Define public platforms
PUBLIC="nangate45 sky130hd sky130hs asap7 ihp-sg13g2 gf180"

# Determine PLATFORM_DIR based on PLATFORM
if [[ -d "${PLATFORM_HOME}/${PLATFORM}" ]]; then
  export PLATFORM_DIR="${PLATFORM_HOME}/${PLATFORM}"
elif [[ " ${PUBLIC} " == *" ${PLATFORM} "* ]]; then
  export PLATFORM_DIR="./platforms/${PLATFORM}"
elif [[ -d "../../${PLATFORM}" ]]; then
  export PLATFORM_DIR="../../${PLATFORM}"
fi

export UTILS_DIR="${UTILS_DIR:-${FLOW_HOME}/util}"

# if $PLATFORM_DIR/config.sh exists, source it
if [ -f "${PLATFORM_DIR}/config.sh" ]; then
  source "${PLATFORM_DIR}/config.sh"
fi

export TIME_BIN="${TIME_BIN:-env time}"
TIME_CMD="$TIME_BIN -f 'Elapsed time: %E[h:]min:sec. CPU time: user %U sys %S (%P). Peak memory: %MKB.'"
if ! TIME_TEST=$(eval "$TIME_CMD echo foo" 2>/dev/null); then
  TIME_CMD="$TIME_BIN"
fi
export TIME_CMD

# Setup working directories
export DESIGN_NICKNAME="${DESIGN_NICKNAME:=${DESIGN_NAME}}"

export LOG_DIR="${WORK_HOME}/logs/${PLATFORM}/${DESIGN_NICKNAME}/${FLOW_VARIANT}"
export OBJECTS_DIR="${WORK_HOME}/objects/${PLATFORM}/${DESIGN_NICKNAME}/${FLOW_VARIANT}"
export REPORTS_DIR="${WORK_HOME}/reports/${PLATFORM}/${DESIGN_NICKNAME}/${FLOW_VARIANT}"
export RESULTS_DIR="${WORK_HOME}/results/${PLATFORM}/${DESIGN_NICKNAME}/${FLOW_VARIANT}"

# Determine the number of cores (NUM_CORES)
if [[ -z "${NUM_CORES:-}" ]]; then
  # Linux (utility program)
  NUM_CORES=$(nproc 2>/dev/null || true)

  if [[ -z "$NUM_CORES" ]]; then
    # Linux (generic)
    NUM_CORES=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || true)
  fi

  if [[ -z "$NUM_CORES" ]]; then
    # BSD (at least FreeBSD and macOS)
    NUM_CORES=$(sysctl -n hw.ncpu 2>/dev/null || true)
  fi

  if [[ -z "$NUM_CORES" ]]; then
    # Fallback
    NUM_CORES=1
  fi
fi
export NUM_CORES

# Determine the executable location for each tool used by this flow.
# Priority is given to:
# 1. User explicitly setting the variable in the environment or command line (e.g., OPENROAD_EXE).
# 2. Default ORFS compiled tools: openroad, yosys.

# Set default paths for executables if not already set
if [[ -n "${IN_NIX_SHELL:-}" ]]; then
  export OPENROAD_EXE=$(command -v openroad)
fi
export OPENROAD_EXE="${OPENROAD_EXE:-$(realpath "${FLOW_HOME}/../tools/install/OpenROAD/bin/openroad")}"
export OPENSTA_EXE="${OPENSTA_EXE:-$(realpath "${FLOW_HOME}/../tools/install/OpenROAD/bin/sta")}"
if [[ -n "${IN_NIX_SHELL:-}" ]]; then
  export YOSYS_EXE=$(command -v yosys)
fi
export YOSYS_EXE="${YOSYS_EXE:-$(realpath "${FLOW_HOME}/../tools/install/yosys/bin/yosys")}"

# Define OpenROAD command-line arguments
export OPENROAD_ARGS="-no_init -threads ${NUM_CORES} ${OR_ARGS:-}"

# Define OpenROAD commands
export OPENROAD_CMD="${OPENROAD_EXE} -exit ${OPENROAD_ARGS}"
export OPENROAD_NO_EXIT_CMD="${OPENROAD_EXE} ${OPENROAD_ARGS}"
export OPENROAD_GUI_CMD="${OPENROAD_EXE} -gui ${OR_ARGS:-}"

# Use locally installed and built klayout if it exists, otherwise use klayout in path
KLAYOUT_DIR="$(realpath "${FLOW_HOME}/../tools/install/klayout/")"
KLAYOUT_BIN_FROM_DIR="${KLAYOUT_DIR}/klayout"

if [[ -x "${KLAYOUT_BIN_FROM_DIR}" ]]; then
  export KLAYOUT_CMD="sh -c 'LD_LIBRARY_PATH=$(dirname "${KLAYOUT_BIN_FROM_DIR}") \$0 \"\$@\"' ${KLAYOUT_BIN_FROM_DIR}"
else
  if [[ -z "${KLAYOUT_CMD:-}" ]]; then
    KLAYOUT_CMD="$(command -v klayout || true)"
  fi
fi
export KLAYOUT_CMD

export SYNTH_SCRIPT="${SYNTH_SCRIPT:-${SCRIPTS_DIR}/synth.tcl}"
export SDC_FILE_CLOCK_PERIOD="${SDC_FILE_CLOCK_PERIOD:-${RESULTS_DIR}/clock_period.txt}"
