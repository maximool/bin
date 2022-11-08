#!/usr/bin/env bash

# https://sharats.me/posts/shell-script-best-practices/
set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace


if [[ -z "${1-}" ]]
then
    echo "No command given as first parameter"
    exit
else
    "$1" "${USER}@${FLAT}"
fi
