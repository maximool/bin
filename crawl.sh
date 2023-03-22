#!/usr/bin/env bash

# https://sharats.me/posts/shell-script-best-practices/
set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace


# Revamped version of both:
# - https://sametmax.com/la-blog-ferme/
# - https://www.linuxjournal.com/content/downloading-entire-web-site-wget
# - https://www.tupp.me/2014/06/how-to-crawl-website-with-linux-wget.html

# Good examples of use
# * `wget -m -k -p -c -E https://sametmax.com` ?
# * `wget -m -k -p -c -E https://librecours.net/parcours/na17` ?
# * `wget -m -k -p -c -E https://stph.scenari-community.org/dwh` ?

# Extract the domain from the given url (see `--domain` option)
domain=$(echo "$1" | sed -r 's,(https?|ftp|ssh|ssl)://(www\.)?,,')
domain=$(echo "$domain" | sed -r 's,/$,,')

# Proceed with downloading with custom options
if [[ -z "${1-}" ]]
then
    echo 'Invalid option command (no website given)' && exit
else
    wget \
        --adjust-extension \
        --continue \
        --convert-links \
        --domains="$domain" \
        --execute robots=off \
        --level 5 \
        --limit-rate=900K \
        --no-parent \
        --page-requisites \
        --random-wait \
        --recursive \
        --user-agent=mozilla \
        --wait=1 \
        "$1"
fi
