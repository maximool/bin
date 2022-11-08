#!/usr/bin/env bash

# https://sharats.me/posts/shell-script-best-practices/
set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace


# see https://duckduckgo.com/?q=linux+convert+svg+to+png&t=ffab&ia=qa&iax=qa
for img in $(./*.svg)
do
    inkscape -z -e "${img}.png" -w 1024 -h 1024 "$img"
done
