#!/bin/bash

set -e

coreos-installer download --format pxe --decompress

assets=("kernel" "initramfs" "rootfs")
for asset in "${assets[@]}"; do
    mv fedora-coreos-*$asset* "$asset" --force
done