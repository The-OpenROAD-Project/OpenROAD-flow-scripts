#!/usr/bin/env bash

set -eoux pipefail

cd "$(dirname "$(readlink -f "$0")")/../"

usage() {
  cat <<'EOF'
Usage:
  test_helper.sh [options]
  test_helper.sh <design> <platform> [config_mk] [variant] [target]   (legacy positional)

Options:
  --design NAME         Design name (default: gcd)
  --platform NAME       Platform (default: nangate45)
  --config FILE         Design config file name (default: config.mk)
  --design-path DIR     Root path containing 'designs/' (default: ./)
  --variant NAME        Flow variant (default: unset)
  --target STR          Make target(s), space-separated (default: 'finish metadata')
  --work-home DIR       Work home (default: .)
  --private-dir DIR     Private tool scripts dir (default: ../../private_tool_scripts)
  --save-to-db          Save metrics to DB (requires private.mk)
  --run-calibre         Run Calibre DRC (requires utils.mk)
  --check-drc-db        Check DRC DB (use with --run-calibre + --save-to-db)
  --make-issue          Run final_report_issue at end
  -h, --help            Show this help

Environment variables override defaults; flags override env. Flags also accept
values via the corresponding env var (e.g., DESIGN_NAME, PLATFORM, CONFIG_MK,
FLOW_VARIANT, TARGET, WORK_HOME, PRIVATE_DIR, DESIGN_PATH, SAVE_TO_DB,
RUN_CALIBRE, CHECK_DRC_DB, MAKE_ISSUE).
EOF
}

DESIGN_NAME="${DESIGN_NAME:-gcd}"
PLATFORM="${PLATFORM:-nangate45}"
CONFIG_MK="${CONFIG_MK:-config.mk}"
TARGET="${TARGET:-finish metadata}"
WORK_HOME="${WORK_HOME:-.}"
PRIVATE_DIR="${PRIVATE_DIR:-../../private_tool_scripts}"
DESIGN_PATH="${DESIGN_PATH:-./}"

if [ $# -gt 0 ]; then
  if [ "${1#-}" = "$1" ]; then
    # Legacy positional: <design> <platform> [config_mk] [variant] [target]
    DESIGN_NAME=${1:-$DESIGN_NAME}
    PLATFORM=${2:-$PLATFORM}
    CONFIG_MK=${3:-$CONFIG_MK}
    if [ $# -ge 4 ] && [ -n "$4" ]; then
      FLOW_VARIANT=$4
    fi
    if [ $# -ge 5 ] && [ -n "$5" ]; then
      TARGET=$5
    fi
  else
    while [ $# -gt 0 ]; do
      case "$1" in
        --design)       DESIGN_NAME=$2; shift 2 ;;
        --platform)     PLATFORM=$2; shift 2 ;;
        --config)       CONFIG_MK=$2; shift 2 ;;
        --design-path)  DESIGN_PATH=$2; shift 2 ;;
        --variant)      FLOW_VARIANT=$2; shift 2 ;;
        --target)       TARGET=$2; shift 2 ;;
        --work-home)    WORK_HOME=$2; shift 2 ;;
        --private-dir)  PRIVATE_DIR=$2; shift 2 ;;
        --save-to-db)   SAVE_TO_DB=1; shift ;;
        --run-calibre)  RUN_CALIBRE=1; shift ;;
        --check-drc-db) CHECK_DRC_DB=1; shift ;;
        --make-issue)   MAKE_ISSUE=1; shift ;;
        -h|--help)      usage; exit 0 ;;
        *) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
      esac
    done
  fi
fi

DESIGN_CONFIG=${DESIGN_PATH%/}/designs/$PLATFORM/$DESIGN_NAME/$CONFIG_MK
LOG_FILE=${WORK_HOME}/logs/$PLATFORM/$DESIGN_NAME.log
mkdir -p "${WORK_HOME}/logs/$PLATFORM"

__make=(make "DESIGN_CONFIG=$DESIGN_CONFIG")
if [ -n "${FLOW_VARIANT+x}" ]; then
  __make+=("FLOW_VARIANT=$FLOW_VARIANT")
fi

mkdir -p "$(dirname "$LOG_FILE")"
"${__make[@]}" clean_all clean_metadata 2>&1 | tee "$LOG_FILE"

# turn off abort on error so we can always capture the result
set +e

read -r -a TARGET_ARR <<< "$TARGET"
"${__make[@]}" "${TARGET_ARR[@]}" 2>&1 | tee -a "$LOG_FILE"

# Save the return code to return as the overall status after we package
# the results
ret=$?

if [ "${TARGET}" != "finish metadata" ]; then
  exit $ret
fi

if [ -f "$PRIVATE_DIR/openRoad/private.mk" ] && [ -n "${SAVE_TO_DB+x}" ]; then
  "${__make[@]}" save_to_metrics_db
  ret=$(( ret + $? ))
fi

if [ -f "$PRIVATE_DIR/util/utils.mk" ] && [ -n "${RUN_CALIBRE+x}" ]; then
  "${__make[@]}" calibre_drc
  ret=$(( ret + $? ))
  "${__make[@]}" convert_calibre
  ret=$(( ret + $? ))
  if [ -n "${SAVE_TO_DB+x}" ]; then
    "${__make[@]}" save_to_drc_db
    ret=$(( ret + $? ))
  fi
  if [ -n "${CHECK_DRC_DB+x}" ]; then
    "${__make[@]}" check_drc_db
    ret=$(( ret + $? ))
  fi
fi

# Only enabled abort on error at the end to allow script to reach make issue
set -e

if [ -n "${MAKE_ISSUE+x}" ]; then
  "${__make[@]}" final_report_issue 2>&1 | tee -a "$LOG_FILE"
fi

# Find make targets
set +x # These rules are noisy
TARGETS=$("${__make[@]}" -np | grep -e '^[^ ]*:')
if [ $ret -eq 0 ] && grep -q 'simulate:' <(echo "$TARGETS"); then
  echo "Start simulate"
  "${__make[@]}" simulate 2>&1 | tee -a "$LOG_FILE"
  ret=$(( ret + $? ))
fi
if [ $ret -eq 0 ] && grep -q 'power:' <(echo "$TARGETS"); then
  echo "Start power"
  "${__make[@]}" power 2>&1 | tee -a "$LOG_FILE"
  ret=$(( ret + $? ))
fi
set -x

exit $ret
