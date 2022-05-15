#!/bin/bash

set -e
export FCOS_DISK="$1"

function install_edk2(){
    TMP_DIR=/tmp/fcos-efi
    FCOS_EFI_PARTITION=$(lsblk $FCOS_DISK --json --output LABEL,PATH  | jq -r '.blockdevices[] | select(.label == "EFI-SYSTEM")'.path)
    LATEST_EDK_URL=$(curl https://api.github.com/repos/pftf/RPi4/releases/latest | jq -r .assets[0].browser_download_url)
    mkdir -p $TMP_DIR
    sudo mount $FCOS_EFI_PARTITION $TMP_DIR
    pushd $TMP_DIR
    curl --location $LATEST_EDK_URL | sudo busybox unzip -
    popd
    sudo umount $TMP_DIR
}

docker compose run --rm install
install_edk2