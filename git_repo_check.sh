#!/bin/bash

if [[ ! $1 ]]; then
    echo "Error: Path to directory containing git repositories is required"
    exit
else
    if [[ ! -d "$1" ]]; then
        echo "Error: Directory '$1' does not exist"
        exit
    else
        GIT_DIR=$1
    fi
fi

if [[ ! $(which git) ]]; then
    echo 'Error: Failed to find git binary in $PATH'
    exit
fi

declare -a unpushed_repos
VALID_GIT_REPO=0

for i in $(ls -d $GIT_DIR/*/ | grep -Eo '[^/]+/?$' | cut -d / -f1); do
    if [[ "$(git -C $GIT_DIR/$i rev-parse --is-inside-work-tree 2>/dev/null)" ]]; then
        GIT_STATUS=$(git -C $GIT_DIR/$i status --short)
        VALID_GIT_REPO=1
    fi
    if [[ $GIT_STATUS ]]; then 
        unpushed_repos+=($i)
    fi
done
