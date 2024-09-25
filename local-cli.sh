#!/bin/bash

IMAGE_NAME="simranchawla/local-cli:latest"

# Function to display help
function show_help {
    echo "Usage: $(basename "$0") [-h] [-u] [command]"
    echo ""
    echo "Options:"
    echo "  -h          Show this help message."
    echo "  -u          Update/pull the Docker image."
    echo ""
    echo "If no command is passed, a Zsh shell will be launched inside the Docker container."
    echo "Otherwise, the specified command will be executed in the Docker container."
}

# Function to pull Docker image if not available locally
function check_image {
    if [[ "$(docker images -q $IMAGE_NAME 2> /dev/null)" == "" ]]; then
        echo "Docker image not found locally. Pulling $IMAGE_NAME..."
        docker pull $IMAGE_NAME
    else
        echo "Docker image found locally. Using the existing image."
    fi
}

# Parse options
while getopts "hu" opt; do
    case ${opt} in
        h )
            show_help
            exit 0
            ;;
        u )
            echo "Pulling the latest Docker image..."
            docker pull $IMAGE_NAME
            exit 0
            ;;
        * )
            show_help
            exit 1
            ;;
    esac
done
shift $((OPTIND -1))

# Check if Docker image exists locally, pull if not
check_image

# Check if any command is passed, otherwise run the shell
if [ -z "$1" ]; then
    docker run --rm -it -v $(pwd):/workspace -w /workspace $IMAGE_NAME zsh
else
    docker run --rm -it -v $(pwd):/workspace -w /workspace $IMAGE_NAME zsh -c "$*"
fi
