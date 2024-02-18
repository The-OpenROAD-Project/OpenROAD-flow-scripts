if [[ "$OSTYPE" == "darwin"* ]]; then
  DIR="$(dirname $(perl -e 'use Cwd "abs_path";print abs_path(shift)' "${BASH_SOURCE[0]}"))"
else
  DIR="$(dirname $(readlink -f "${BASH_SOURCE[0]}"))"
fi

if [ -f /opt/rh/rh-python38/enable ]; then
  source /opt/rh/rh-python38/enable
fi

export OPENROAD=${DIR}/tools/OpenROAD
echo "OPENROAD: ${OPENROAD}"

export PATH=${DIR}/tools/install/OpenROAD/bin:$PATH
export PATH=${DIR}/tools/install/yosys/bin:$PATH
export PATH=${DIR}/tools/install/LSOracle/bin:$PATH
export PATH=${DIR}/dependencies/bin:$PATH

if [[ "$OSTYPE" == "darwin"* ]]; then
  export PATH="/Applications/KLayout/klayout.app/Contents/MacOS:$PATH"
  export PATH="$(brew --prefix bison)/bin:$(brew --prefix flex)/bin:$(brew --prefix tcl-tk)/bin:$PATH"
  export CMAKE_PREFIX_PATH="$(brew --prefix or-tools)"
fi
