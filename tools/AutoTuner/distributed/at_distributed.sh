    #!/bin/bash -eu

    # Ray script that starts the Ray HEAD/WORKER node based on the command line arg

    IS_HEAD=${1:-false}
    RAY_HEAD_IP_ADDRESS=${2:-10.129.0.4}


    if [ "$IS_HEAD" = "true" ]; then
        echo "Starting Ray HEAD node"
        ray start --head --port=6379
    else
        echo "Starting Ray WORKER node"
        ray start --address=$RAY_HEAD_IP_ADDRESS:6379
    fi