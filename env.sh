#!/usr/bin/env bash
function __setpaths() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    DIR="$(dirname $(perl -e 'use Cwd "abs_path";print abs_path(shift)' "${BASH_SOURCE[0]:-${(%):-%x}}"))"
  else
    DIR="$(dirname $(readlink -f "${BASH_SOURCE[0]:-${(%):-%x}}"))"
  fi

  export OPENROAD=${DIR}/tools/OpenROAD
  echo "OPENROAD: ${OPENROAD}"

  # Set user paths and environment variables here,
  # developer settings go in ./dev_env.sh
  export PATH=${DIR}/tools/install/OpenROAD/bin:$PATH
  export PATH=${DIR}/tools/install/yosys/bin:$PATH

  if [[ "$OSTYPE" == "darwin"* ]]; then
    export PATH="/Applications/KLayout/klayout.app/Contents/MacOS:$PATH"
    export PATH="$(brew --prefix bison)/bin:$(brew --prefix flex)/bin:$(brew --prefix tcl-tk)/bin:$PATH"
  fi

  export FLOW_HOME=$DIR/flow
}
__setpaths
unset -f __setpaths
