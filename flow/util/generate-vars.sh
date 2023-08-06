#!/bin/bash
set -euo pipefail
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# exclude system and CI variables
EXCLUDED_VARS="MAKE|PYTHONPATH|PKG_CONFIG_PATH|PERL5LIB|PCP_DIR|PATH|MANPATH"
EXCLUDED_VARS+="|LD_LIBRARY_PATH|INFOPATH|HOME|PWD|MAIL|QT_QPA_PLATFORM"
EXCLUDED_VARS+="|OPENROAD_CMD|OPENROAD_GUI_CMD|OPENROAD_NO_EXIT_CMD"
EXCLUDED_VARS+="|LSORACLE_CMD|YOSYS_CMD|TIME_CMD|STDBUF_CMD"
EXCLUDED_VARS+="|SHELL|OPENROAD_EXE|YOSYS_EXE"
EXCLUDED_VARS+="|UNSET_VARIABLES_NAMES|do-step|get_variables|do-copy"

# get the root directory of the Git repository
GIT_ROOT=$(git rev-parse --show-toplevel)
FLOW_ROOT=${GIT_ROOT}/flow
printf '%s\n' "$ISSUE_VARIABLES" | while read -r V;
do
    if [[ ${V%=*} =~ ^[[:digit:]] || ${V} != *"="* || -z ${V#*=} || ${V%=*} == *"MAKEFILE"* || ${V%=*} =~ ^(${EXCLUDED_VARS})$  ]] ; then
        continue
    fi
    rhs=`sed -e 's/^"//' -e 's/"$//' <<<"${V#*=}"`
    # handle absolute paths
    if [[ "${rhs}" == /* ]]; then
        if [[ ! -e "${rhs}" ]]; then
            echo "Skiping path not found ${V}"
            continue
        fi
        if [[ "${rhs}" != "${GIT_ROOT}"* ]]; then
            echo "Skiping file outside git ${V}"
            continue
        fi
        # convert the absolute path to a path relative to the flow dir
        rhs=$(realpath --relative-to="$FLOW_ROOT" "$rhs")
    fi
    # handle special case where the variable needs to be splitted in Tcl code
    if [[ "${V%=*}" == "GND_NETS_VOLTAGES" || "${V%=*}" == "PWR_NETS_VOLTAGES" ]]; then
        echo "export "${V%=*}"='"\"${rhs}"\"'" >> $1.sh;
    else
        echo "export "${V%=*}"='"${rhs}"'" >> $1.sh;
    fi
    echo "set env("${V%=*}") \""${rhs}\""" >> $1.tcl;
    echo "set env "${V%=*}" "${rhs}"" >> $1.gdb;
done

# remove variables starting with a dot
sed -i -e '/export \./d' $1.sh
sed -i -e '/set env(\./d' $1.tcl
sed -i -e '/set env \./d' $1.gdb
