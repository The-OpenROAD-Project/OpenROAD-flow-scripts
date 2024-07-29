#!/usr/bin/env bash

# Check if exactly one argument is provided
if [ "$#" -ne 1 ]; then
    echo "Error: Only argument required is the PR number."
    exit 1
fi

# Check if the argument is numerical
if ! [[ "$1" =~ ^[0-9]+$ ]]; then
    echo "Error: The argument must be a numerical value."
    exit 1
fi
PR_NUMBER="$1"

JENKINS_URL="https://jenkins.openroad.tools/job/OpenROAD-flow-scripts-Public"
PR_BUILD_URL="${JENKINS_URL}/job/PR-${PR_NUMBER}-merge"

while true; do

    if ! curl -s "${PR_BUILD_URL}/api/json?pretty" | jq . > /dev/null 2>&1 ; then
        echo "Error while checking PR ${PR_NUMBER}"
        exit 1
    fi

    echo "Checking if build is in queue..."
    in_queue=$(curl -s "${PR_BUILD_URL}/api/json?pretty" | jq -r '.inQueue')
    if [ "$in_queue" == "true" ]; then
        echo "Build still in queue. Retrying..."
        sleep 30
        continue
    fi
    echo "Build not in queue."

    echo "Getting latest build ID..."
    LAST_BUILD_ID=$(curl -s "${PR_BUILD_URL}/api/json?pretty" | jq -r '.lastBuild.number')
    if [ "$LAST_BUILD_ID" == "null" ]; then
        echo "Build id is null."
        exit 1
    fi
    if [ -z "$LAST_BUILD_ID" ]; then
        echo "No build found. Retrying..."
        sleep 30
        continue
    fi
    echo "Latest build id ${LAST_BUILD_ID}"

    echo "Checking if build is done..."
    BUILD_URL="${PR_BUILD_URL}/${LAST_BUILD_ID}/api/json?pretty"
    in_progress=$(curl -s "$BUILD_URL" | jq -r '.inProgress')
    if [ "$in_progress" == "false" ]; then
        echo "Build complete. Running Python script..."
        break
    else
        echo "Build still in progress. Waiting for completion..."
        sleep 30
    fi

done
