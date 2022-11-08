#!/usr/bin/env bash

# https://sharats.me/posts/shell-script-best-practices/
set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace


if [[ -z "${1-}" ]]
then
    from="$PWD"
else
    from="$1"
fi

find "${from}/" -type d -print0 | xargs -r -0 chmod 755
find "${from}/" -type f -print0 | xargs -r -0 chmod 644
