#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

disks="/dev/disk/by-id/scsi-35002538d401140b0 /dev/disk/by-id/scsi-35002538d4200cf5c"

mdadm --misc --verbose --zero-superblock "$disks"
echo 'start=2048, type=83' | sfdisk --label gpt  "$disks"
mdadm --create --verbose --level=1 --name=containers --raid-devices=2 "$disks" 