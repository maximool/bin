#!/usr/bin/env bash

# https://sharats.me/posts/shell-script-best-practices/
set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace


# content to look for (from $HOME)
# data, music & videos folders are usually too big
# zotero has not changed in a while
folders=(
    documents
    downloads
    pictures
    repositories
    stuff
)


flat() {
    # TODO make sure the backup archive is encrypted
    exit 1

    scp -B "$archive" "${USER}@${FLAT}:/home/${USER}/data"
}


help() {
    # TODO bad idea to overload a builtin command ?
    # display help (rather self-explanatory ¯\_(ツ)_/¯)
    printf "Available options:
    * flat: move the latest (daily) folder to the flatshare
    * help: displays this help
    * load: unzips last archive from ~/data
    * save: archives folders to ~/data\n"
}


load() {
    # uncompressing last archive into a temporary directory
    # TODO need that `--chmod=Du=rwx,Dgo=rx,Fu=rw,Fgo=r \` flag ?
    # TODO log file
    # TODO keep track of rsync return values and fire an clear error if need be
    cd data || exit 1
    archive=$(ls save_* | tail -n 1)
    if [[ -z "${archive-}" ]]

    then
        echo 'No archive in found ~/data. Aborting.'
        exit 1
    fi
    tempdir="qzd${RANDOM}ase"
    mkdir "$tempdir"
    unzip "$archive" -d "$tempdir"
    cd "$tempdir" || exit 1

    # actually merging files and folders
    for folder in "${folders[@]}"
    do
        (
            tar -zxf "${folder}.tar.gz"
            rsync \
                --archive \
                --compress \
                --delete-during \
                --delete-excluded \
                --partial \
                --progress \
                "./${folder}/" \
                "${HOME}/${folder}"
        ) &
    done
    wait

    cd ..
    rm -rf "$tempdir"
}

save() {
    # gathering required folders' archives into a temporary folder
    # TODO log file
    cd data || exit 1
    tempdir="qzd${RANDOM}ase"
    mkdir "$tempdir"
    cd "$tempdir" || exit 1
    archive="save$(date '+_%Y_%m_%d').zip"

    # actually compressing data
    for folder in "${folders[@]}"
    do
        tar --dereference --gzip \
            -cf "${folder}.tar.gz" \
            --exclude="node_modules/*" \
            "../../${folder}" &
    done
    wait

    # gathering these tarballs into a single zip file
    zip "$archive" ./*.tar.gz

    # moving from tempdir to data dump folder and removing tempdir
    rm ./*.tar.gz
    mv "$archive" ..
    cd ..
    rmdir "$tempdir"
}


cd "$HOME" || exit

if [[ -z "${1-}" ]]
then
    help
else
    time "$1"
    echo $?
fi
