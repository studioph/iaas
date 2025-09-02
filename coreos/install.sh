#!/usr/bin/env bash

sudo podman run \
     --privileged \
     --rm \
    -v /dev:/dev \
    -v /run/udev:/run/udev \
    -v "$PWD:/data" \
    -w /data \
    quay.io/coreos/coreos-installer:release \
    install --config-file config.yaml