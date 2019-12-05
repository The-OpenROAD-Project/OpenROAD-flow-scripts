modroot="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/OpenROAD"


if [ ! -d "${modroot}" ]; then
  echo "Module path does not exist: ${modroot}"
  exit -1
fi


export OPENROAD=${modroot}
echo "OPENROAD: ${OPENROAD}"

path_string=""
paths=$(ls -d $modroot/build/src/*/ | sed 's/.$/:/')
for path in $paths; do
    path_string=$path$path_string
done


if [ -n "${PATH}" ]; then
  export PATH=${modroot}/build/src:$modroot/build/src/pdn/scripts:$path_string$PATH
else
  export PATH=${modroot}/build/src:$modroot/build/src/pdn/scripts:$path_string
fi

if [ -n "${MANPATH}" ]; then
    #export MANPATH=/net/trenton/x/rovinski/openroad/openroad/OpenROAD-2019-09-05_20-10/share/man
    export MANPATH=${modroot}/share/man:$MANPATH
else
  export MANPATH=${modroot}/share/man
fi

export TCLLIBPATH=${modroot}/build/src/pdn/scripts
