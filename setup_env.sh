modroot="$(dirname $(readlink -f "${BASH_SOURCE[0]}"))/tools"

if [ ! -d "${modroot}" ]; then
  echo "Module path does not exist: ${modroot}"
  return 1
fi

export OPENROAD=${modroot}/OpenROAD
echo "OPENROAD: ${OPENROAD}"

export PATH=${modroot}/build/OpenROAD/src:${modroot}/build/yosys/bin:${modroot}/build/LSOracle/core:$PATH
