#!/usr/bin/env bash

# https://sharats.me/posts/shell-script-best-practices/
set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace


apt-get update
apt-get -y purge "$(deborphan)"
apt-get -y autoremove
apt-get -y autoclean
for pckg in "$(dpkg -l | grep ^rc | awk '{print $2}')"
do
    apt-get -y purge "$pckg"
done
