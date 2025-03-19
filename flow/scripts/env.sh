#!/bin/bash
# Print out make variables that have changed so that
# make can set them up in "make". This vile script has to
# be in bash, because we're sourcing the script that we're
# checking for changes to environment variables.
set -e
# Get the environment file from the first argument
envfile="$1"

# Save the current environment variables
declare -A env_vars

while IFS= read -r -d '' entry; do
  var="${entry%%=*}"  # Extract the variable name
  val="${entry#*=}"   # Extract the variable value
  env_vars["$var"]="$val"
done < <(env -0)

# Source the environment file to load new variables
if [[ -f "$envfile" ]]; then
  source "$envfile"
else
  echo "Error: Environment file '$envfile' not found."
  exit 1
fi

# Compare the new environment variables with the original ones
while IFS= read -r -d '' entry; do
  var="${entry%%=*}"  # Extract the variable name
  val="${entry#*=}"   # Extract the variable value
  if [[ "${env_vars[$var]+_}" && "${env_vars[$var]}" != "$val" ]] || [[ ! "${env_vars[$var]+_}" ]]; then
    val=$(echo "$val" | sed 's/ /__SPACE__/g')
    echo "export $var:=$val"
  fi
done < <(env -0)
