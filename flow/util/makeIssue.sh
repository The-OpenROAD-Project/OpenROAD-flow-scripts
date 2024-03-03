#!/usr/bin/env bash

set -euo pipefail
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

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
cat > ${RUN_ME_SCRIPT} <<EOF
#!/usr/bin/env bash
source ${VARS_BASENAME}.sh
if [[ ! -z \${GDB+x} ]]; then
    gdb --args openroad -no_init \${SCRIPTS_DIR}/$1.tcl
else
    openroad -no_init \${SCRIPTS_DIR}/$1.tcl
fi
EOF
chmod +x ${RUN_ME_SCRIPT}

echo "Creating ${VARS_BASENAME}.sh/tcl script"
rm -f ${VARS_BASENAME}.sh ${VARS_BASENAME}.tcl ${VARS_BASENAME}.gdb || true

$DIR/generate-vars.sh ${VARS_BASENAME}

echo "Archiving issue to $1_${ISSUE_TAG}.tar.gz"
# if pigz is installed, use it instead of gzip
if command -v pigz &> /dev/null; then
    COMPRESS=pigz
else
    COMPRESS=gzip
fi

echo "Using $COMPRESS to compress tar file"

# Save all files inside design and platform folders
if [ -v FULL_ISSUE ]; then
    DESIGN_PLATFORM_FILES="$DESIGN_DIR $PLATFORM_DIR"
else
    DESIGN_PLATFORM_FILES="$DESIGN_DIR/config.mk $PLATFORM_DIR/config.mk"
fi

set -x
tar --use-compress-program=${COMPRESS} \
    --ignore-failed-read -chf $1_${ISSUE_TAG}.tar.gz \
    --transform="s|^|$1_${ISSUE_TAG}/|S" \
    --transform="s|^$1_${ISSUE_TAG}${FLOW_HOME}/|$1_${ISSUE_TAG}/|S" \
    $DESIGN_PLATFORM_FILES \
    $LOG_DIR \
    $OBJECTS_DIR \
    $REPORTS_DIR \
    $RESULTS_DIR \
    $SCRIPTS_DIR \
    $(for f in $ISSUE_CP_FILES; do echo $f; done | sort | uniq)

if [ -v EXCLUDE_PLATFORM ]; then
    # Remove liberty and lef files from tar file
    gunzip -f $1_${ISSUE_TAG}.tar.gz
    tar --list --file $1_${ISSUE_TAG}.tar | grep -iE "*.(lib|lef|tlef)$" | xargs -r tar --delete --file $1_${ISSUE_TAG}.tar
    gzip $1_${ISSUE_TAG}.tar
fi

if [ ! -z ${COPY_ISSUE+x} ]; then
    mkdir -p ${COPY_ISSUE} ;
    cp $1_${ISSUE_TAG}.tar.gz ${COPY_ISSUE} ;
fi
