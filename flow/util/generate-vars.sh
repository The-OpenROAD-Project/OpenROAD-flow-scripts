#!/bin/bash
set -euo pipefail
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# exclude system and CI variables
EXCLUDED_VARS="MAKE|PERL5LIB"
EXCLUDED_VARS+="|HOME|PWD|MAIL|QT_QPA_PLATFORM"
EXCLUDED_VARS+="|SHELL|OPENROAD_EXE|YOSYS_EXE|RESULTS_ODB"
EXCLUDED_VARS+="|NPROC|NUM_CORES|PUBLIC|ISSUE_SCRIPTS|MAKEFLAGS"
EXCLUDED_VARS+="|UNSET_VARIABLES_NAMES|do-step|get_variables|do-copy"

EXCLUDED_PATTERNS="_EXE$|PATH$|_DIR$|_CMD$|^\."

while read -r VAR; do
    if [[ ${VAR} != *"="* ]] ; then
        # skip variables that do not have an equal sign
        # they are invalid in shell
        continue
    fi
    name="${VAR%=*}"
    value="${VAR#*=}"
    if [[ "${name}" =~ ^[[:digit:]] ]] ; then
        # skip if the name starts with a number
        # they are invalid in shell
        continue
    fi
    if [[ "${value}" == "''" ]]; then
        # avoid exporting empty variables as var=''''
        # instead export as var=''
        value=
    fi
    if [[ "${name}" == *"MAKEFILE"* ]] ; then
        # skip make variables
        continue
    fi
    if [[ "${name}" =~ ^(${EXCLUDED_VARS})$  ]] ; then
        # skip variables from the exclude list
        continue
    fi
    if [[ "${name}" =~ ${EXCLUDED_PATTERNS}  ]] ; then
        # skip variables that match the exclude patterns
        continue
    fi
    if [[ ${value} == *"\""* ]]; then
        # remove double quotes from value to avoid syntax issues on final
        # generated script
        value=$(sed -e 's/^"//' -e 's/"$//' <<< "${value}")
    fi
    # handle special case where the variable needs to be splitted in Tcl code
    if [[ "${name}" == "GND_NETS_VOLTAGES" || "${name}" == "PWR_NETS_VOLTAGES" ]]; then
        echo "export ${name}='\"${value}\"'" >> $1.sh;
    else
        echo "export ${name}=\"${value}\"" >> $1.sh;
    fi
    echo "set env(${name}) \"${value}\"" >> $1.tcl;
    echo "set env ${name} ${value}" >> $1.gdb;
done <<< "$ISSUE_VARIABLES"
