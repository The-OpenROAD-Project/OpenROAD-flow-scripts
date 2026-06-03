#!/usr/bin/env bash
set -euo pipefail
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
FLOW_ROOT=$(realpath "${FLOW_HOME}")
ORFS_ROOT=$(realpath "${FLOW_HOME}/../")
WORK_ROOT=$(realpath "${WORK_HOME:-.}")

# exclude system and CI variables
EXCLUDED_VARS='MAKE|MAKEFLAGS|PERL5LIB|QT_QPA_PLATFORM'
EXCLUDED_VARS+='|RESULTS_ODB|PUBLIC|ISSUE_SCRIPTS'
EXCLUDED_VARS+='|HOME|PWD|MAIL|SHELL|NPROC|NUM_CORES|FLOW_HOME|\\n'
EXCLUDED_VARS+='|UNSET_VARIABLES_NAMES|do-step|get_variables|do-copy'
EXCLUDED_VARS+='|CURDIR|OPEN_GUI|OPEN_GUI_SHORTCUT'
EXCLUDED_VARS+='|COMMAND_LINE_ARGS'

EXCLUDED_PATTERNS="_EXE$|PATH$|_CMD$|\."

echo 'export FLOW_HOME=${FLOW_HOME:-$(pwd)}' > $1.sh

while read -r VAR; do
    if [[ ${VAR} != *"="* ]] ; then
        # skip variables that do not have an equal sign
        # they are invalid in shell
        continue
    fi
    name="${VAR%%=*}"
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

    # convert absolute paths if possible to use FLOW_HOME variable
    if [[ "${name}" == *"SCRIPTS_DIR"* ]]; then
        value=$(sed -e "s,${FLOW_ROOT},.,g" <<< "${value}")
    fi

    # PII members use PRESERVE_PATHS=1 make issue ...
    if [[ ! -v PRESERVE_PATHS ]]; then
        # Relativize paths under WORK_HOME (e.g. a CI workspace); makeIssue.sh
        # stores those files at the tarball root. Both the literal and the
        # symlink-resolved form may appear in values. Skip when WORK_HOME is
        # FLOW_HOME, which is handled via ${FLOW_HOME} below.
        for work_path in "${WORK_HOME:-.}" "${WORK_ROOT}"; do
            if [[ "${work_path}" == /* && "${work_path}" != "${FLOW_ROOT}" ]]; then
                value=$(sed -e "s,\(^\|[: \"']\)${work_path},\1.,g" <<< "${value}")
            fi
        done
        for path in workspace platforms; do
            value=$(sed -e "s,\(^\|[: \"']\)/${path},\1./${path},g" <<< "${value}")
        done
    fi
    value=$(sed -e "s,${FLOW_ROOT},\${FLOW_HOME},g" <<< "${value}")
    value=$(sed -e "s,${ORFS_ROOT},\${FLOW_HOME}/\.\.,g" <<< "${value}")

    echo "export ${name}=\"${value}\"" >> $1.sh
    if [[ "${value}" == *'$'* ]]; then
        echo "set env ${name} $(sed -e 's,${FLOW_HOME},getenv("FLOW_HOME"),g' <<< ${value})" >> $1.gdb
        echo "set env(${name}) \"$(sed -e 's,${FLOW_HOME},$::env(FLOW_HOME),g' <<< ${value})\"" >> $1.tcl
    else
        echo "set env(${name}) \"${value}\"" >> $1.tcl
        echo "set env ${name} ${value}" >> $1.gdb
    fi
done <<< "$ISSUE_VARIABLES"
