# if ORFS_DEFAULTS_LOADED is 1, the defaults have already been loaded
# return early.
# ORFS_DEFAULTS_LOADED: unbound variable
if [ "${ORFS_DEFAULTS_LOADED:-}" = "1" ]; then
  return
fi

# defaults.py is in the same folder as this script
DEFAULTS_PY="$(dirname $0)/defaults.py"
# Run once to produce an early failure with a human readable
# error message to stderr.
${DEFAULTS_PY} bash >/dev/null

while IFS= read -r line; do
  eval "${line//__SPACE__/ }"
done < <(${DEFAULTS_PY} bash)
