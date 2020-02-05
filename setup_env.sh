modroot="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/tools"


if [ ! -d "${modroot}" ]; then
  echo "Module path does not exist: ${modroot}"
  exit -1
fi


export OPENROAD=${modroot}/OpenROAD
echo "OPENROAD: ${OPENROAD}"

path_string=${modroot}/OpenROAD/build/src:${modroot}/TritonRoute/build:${modroot}/yosys/build/bin

if [ -n "${PATH}" ]; then
  export PATH=$path_string:$PATH
else
  export PATH=$path_string
fi

if [ -n "${MANPATH}" ]; then
  export MANPATH=${modroot}/share/man:$MANPATH
else
  export MANPATH=${modroot}/share/man
fi
