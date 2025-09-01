#!/usr/bin/env bash

podman run \
    --rm --privileged \
    --pid=host \
    -v /dev:/dev \
    -v /var/lib/containers:/var/lib/containers \
    --security-opt label=type:unconfined_t \
    "$1" \
    bootc install to-disk --wipe "$2"