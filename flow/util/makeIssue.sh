#!/bin/bash

set -euo pipefail

currentDate=$(date +"%Y-%m-%d_%H-%M")
ISSUE_TAG=${ISSUE_TAG:-"${DESIGN_NICKNAME}_${PLATFORM}_${FLOW_VARIANT}_${currentDate}"}
ISSUE_CP_DESIGN_FILE_VARS="SDC_FILE \
                           VERILOG_FILES \
                           CACHED_NETLIST \
                           FOOTPRINT_TCL \
                           FOOTPRINT \
                           SIG_MAP_FILE \
                           IO_CONSTRAINTS \
                           MACRO_PLACEMENT \
                           RTLMP_CONFIG_FILE \
                           DFF_LIB_FILE "
ISSUE_CP_PLATFORM_FILE_VARS="LIB_FILES \
                             SC_LEF \
                             TECH_LEF \
                             ADDITIONAL_LEFS \
                             CLKGATE_MAP_FILE \
                             ADDER_MAP_FILE \
                             LATCH_MAP_FILE \
                             CDL_FILE \
                             MAKE_TRACKS \
                             POST_FLOORPLAN_TCL \
                             TAPCELL_TCL \
                             PDN_CFG \
                             PDN_TCL \
                             POST_PDN_TCL \
                             POST_CTS_TCL \
                             PRE_GLOBAL_ROUTE \
                             FASTROUTE_TCL \
                             POST_DETAIL_ROUTE_TCL \
                             RCX_RULES \
                             FILL_CONFIG "
ISSUE_CP_FILE_VARS=$ISSUE_CP_DESIGN_FILE_VARS

ISSUE_CP_FILES_PLATFORM=""
if [[ ! -v EXCLUDE_PLATFORM ]]; then
    ISSUE_CP_FILE_VARS+=$ISSUE_CP_PLATFORM_FILE_VARS
    if [[ -e $PLATFORM_DIR/*.cfg ]]; then
        ISSUE_CP_FILES_PLATFORM="$PLATFORM_DIR/*.tcl $PLATFORM_DIR/*.cfg"
    else
        ISSUE_CP_FILES_PLATFORM="$PLATFORM_DIR/*.tcl"
    fi
fi

VARS_BASENAME=vars-$DESIGN_NICKNAME-$PLATFORM-$FLOW_VARIANT
RUN_ME_SCRIPT=run-me-$DESIGN_NICKNAME-$PLATFORM-$FLOW_VARIANT.sh

for i in $ISSUE_CP_FILE_VARS ; do
    if [ -v ${i} ]; then
        filename=$i
        ISSUE_CP_FILES+="${!filename} "
    fi
done

ISSUE_CP_FILES+="${ISSUE_CP_FILES_PLATFORM} \
    $UTILS_DIR/def2stream.py \
    ${RUN_ME_SCRIPT} \
    $VARS_BASENAME.sh \
    $VARS_BASENAME.tcl \
    $VARS_BASENAME.gdb"

echo "Creating ${RUN_ME_SCRIPT} script"
echo "#!/usr/bin/env bash"                     >  ${RUN_ME_SCRIPT}
echo "source ${VARS_BASENAME}.sh"              >> ${RUN_ME_SCRIPT}
echo "openroad -no_init ${SCRIPTS_DIR}/$1.tcl" >> ${RUN_ME_SCRIPT}
chmod +x ${RUN_ME_SCRIPT}

echo "Creating ${VARS_BASENAME}.sh/tcl script"
rm -f ${VARS_BASENAME}.sh ${VARS_BASENAME}.tcl ${VARS_BASENAME}.gdb || true

# exclude system and CI variables
EXCLUDED_VARS="MAKE|PYTHONPATH|PKG_CONFIG_PATH|PERL5LIB|PCP_DIR|PATH|MANPATH"
EXCLUDED_VARS+="|LD_LIBRARY_PATH|INFOPATH|HOME|PWD|MAIL|TIME_CMD|QT_QPA_PLATFORM"

printf '%s\n' "$ISSUE_VARIABLES" | while read -r V;
do
    if [[ ! ${V%=*} =~ ^[[:digit:]] && ${V} == *"="* && ! -z ${V#*=} && ${V%=*} != *"MAKEFILE"* && ! ${V%=*} =~ ^(${EXCLUDED_VARS})$ ]] ; then
        rhs=`sed -e 's/^"//' -e 's/"$//' <<<"${V#*=}"`
        # handle special case where the variable needs to be splitted in Tcl code
        if [[ "${V%=*}" == "GND_NETS_VOLTAGES" || "${V%=*}" == "PWR_NETS_VOLTAGES" ]]; then
            echo "export "${V%=*}"='"\"${rhs}"\"'" >> ${VARS_BASENAME}.sh;
        else
            echo "export "${V%=*}"='"${rhs}"'" >> ${VARS_BASENAME}.sh;
        fi
        echo "set env("${V%=*}") \""${rhs}\""" >> ${VARS_BASENAME}.tcl;
        echo "set env "${V%=*}" "${rhs}"" >> ${VARS_BASENAME}.gdb;
    fi
done

# remove variables starting with a dot
sed -i -e '/export \./d' ${VARS_BASENAME}.sh
sed -i -e '/set env(\./d' ${VARS_BASENAME}.tcl
sed -i -e '/set env \./d' ${VARS_BASENAME}.gdb

echo "Archiving issue to $1_${ISSUE_TAG}.tar.gz"
tar --ignore-failed-read -czhf $1_${ISSUE_TAG}.tar.gz \
    --transform="s|^|$1_${ISSUE_TAG}/|S" \
    $LOG_DIR \
    $OBJECTS_DIR \
    $REPORTS_DIR \
    $RESULTS_DIR \
    $SCRIPTS_DIR \
    $(for f in $ISSUE_CP_FILES; do echo $f; done | sort | uniq)

if [ -v EXCLUDE_PLATFORM ]; then
    # Remove liberty and lef files from tar file
    gunzip -f $1_${ISSUE_TAG}.tar.gz
    tar --list --file $1_${ISSUE_TAG}.tar | grep -iE "*.(lib|lef|tlef)$$" | xargs -r tar --delete --file $1_${ISSUE_TAG}.tar
    gzip $1_${ISSUE_TAG}.tar
fi

if [ ! -z ${COPY_ISSUE+x} ]; then
    mkdir -p ${COPY_ISSUE} ;
    cp $1_${ISSUE_TAG}.tar.gz ${COPY_ISSUE} ;
fi
