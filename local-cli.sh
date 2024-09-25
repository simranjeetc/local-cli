#!/bin/bash

# Download the Docker image (replace with your Docker image)
docker pull simranchawla/local-cli:latest

# Check if any command is passed, otherwise just run the shell
if [ -z "$1" ]; then
    docker run --rm -it -v $(pwd):/workspace -w /workspace simranchawla/local-cli:latest zsh
else
    docker run --rm -it -v $(pwd):/workspace -w /workspace simranchawla/local-cli:latest zsh -c "$*"
fi
