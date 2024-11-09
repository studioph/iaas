#!/bin/bash

set -euo pipefail

FCOSDISK="$1"

sudo podman run \
    --privileged \
    --rm \
    -v /dev:/dev \
    -v /run/udev:/run/udev \
    -v "$PWD:/data" \
    -w /data \
    quay.io/coreos/coreos-installer:release \
    install \
    --config-file install.yaml \
    "$FCOSDISK"


FCOSEFIPARTITION=$(lsblk $FCOSDISK -J -oLABEL,PATH  | jq -r '.blockdevices[] | select(.label == "EFI-SYSTEM")'.path)
mkdir -p /tmp/FCOSEFIpart
sudo mount $FCOSEFIPARTITION /tmp/FCOSEFIpart
pushd /tmp/FCOSEFIpart
VERSION=v1.34  # use latest one from https://github.com/pftf/RPi4/releases
sudo curl -LO https://github.com/pftf/RPi4/releases/download/${VERSION}/RPi4_UEFI_Firmware_${VERSION}.zip
sudo unzip RPi4_UEFI_Firmware_${VERSION}.zip
sudo rm RPi4_UEFI_Firmware_${VERSION}.zip
popd
sudo umount /tmp/FCOSEFIpart