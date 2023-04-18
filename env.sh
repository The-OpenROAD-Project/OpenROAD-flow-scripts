if [[ "$OSTYPE" == "darwin"* ]]; then
  modroot="$(dirname $(perl -e 'use Cwd "abs_path";print abs_path(shift)' "${BASH_SOURCE[0]}"))/tools"
else
  modroot="$(dirname $(readlink -f "${BASH_SOURCE[0]}"))/tools"
fi

if [ ! -d "${modroot}" ]; then
  echo "Module path does not exist: ${modroot}"
  return 1
fi

export OPENROAD=${modroot}/OpenROAD
echo "OPENROAD: ${OPENROAD}"

export PATH=${modroot}/install/OpenROAD/bin:${modroot}/install/yosys/bin:${modroot}/install/LSOracle/bin:$PATH

if [[ "$OSTYPE" == "darwin"* ]]; then
  export PATH="/Applications/KLayout/klayout.app/Contents/MacOS:$PATH"
  export PATH="$(brew --prefix bison)/bin:$(brew --prefix flex)/bin:$(brew --prefix tcl-tk)/bin:$PATH"
  export CMAKE_PREFIX_PATH="$(brew --prefix or-tools)"
fi
