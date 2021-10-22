#!/bin/bash

# takes $DISK1 (or $DISK2 in case of mirror setup) as single input

sgdisk --zap-all $1 || echo "failed to destroy $1"

sgdisk --clear $1 && echo "---> cleared $1  <--------------------------------------------------------------" || { echo "failed to clear $1";  exit 1; }

sleep 3

if [ -n "$ZFS" ] && [ -n "$EFI" ] && [ -z "$BIOS" ]
then

    sgdisk     -n1:1M:+512M   -t1:EF00 $1 && echo "---> created EFI partition at $1-part1  <--------------------------------------------------------------" || { echo "failed to create EFI partition at $1-part1"; exit 1; }

    sgdisk     -n2:0:0        -t2:BE00 $1 && echo "---> created rpool partition at $1-part2  <--------------------------------------------------------------" || { echo "failed to create rpool partition at $1-part2"; exit 1; }

    sleep 3

    if [ "$1" = "$DISK1" ]
    then

        mkfs.vfat -n EFI $1-part1 && echo "---> created vfat EFI filesystem on partition: $1-part1  <--------------------------------------------------------------" || { echo "failed to create vfat EFI filesystem on partition: $1-part1"; exit 1; }

    elif [ "$1" = "$DISK2" ]
    then

        mkfs.vfat -n EFI2 $1-part1 && echo "---> created vfat EFI filesystem on partition: $1-part1  <--------------------------------------------------------------" || { echo "failed to create vfat EFI filesystem on partition: $1-part1"; exit 1; }

    fi


elif [ -n "$ZFS" ] && [ -z "$EFI" ] && [ -n "$BIOS" ] 
then

    sgdisk     -n1:0:0        -t1:BE00 $1 && echo "---> created rpool partition at $1-part1  <--------------------------------------------------------------" || { echo "failed to create rpool partition at $1-part1"; exit 1; }


elif [ -z "$ZFS" ] && [ -n "$EFI" ] && [ -z "$BIOS" ]
then

    sgdisk     -n1:1M:+512M   -t1:EF00 $1 && echo "---> created EFI partition at $1-part1  <--------------------------------------------------------------" || { echo "failed to create EFI partition at $1-part1"; exit 1; }

    sgdisk     -n2:0:0      -t2:8300 $1 && echo "---> created ext4 root partition at $1-part2  <--------------------------------------------------------------" || { echo "failed to create ext4 root partition at $1-part2"; exit 1; }

    sleep 3

    mkfs.vfat -n EFI $1-part1 && echo "---> created vfat EFI filesystem on partition: $1-part1  <--------------------------------------------------------------" || { echo "failed to create vfat EFI filesystem on partition: $1-part1"; exit 1; }

    mkfs.ext4 $1-part2 && echo "---> created ext4 root filesystem on partition: $1-part2  <--------------------------------------------------------------" || { echo "failed to create ext4 root filesystem on partition: $1-part2"; exit 1; }


elif [ -z "$ZFS" ] && [ -z "$EFI" ] && [ -n "$BIOS" ]
then

    sgdisk     -n1:0:0      -t1:8300 $1 && echo "---> created ext4 root partition at $1-part1  <--------------------------------------------------------------" || { echo "failed to create ext4 root partition at $1-part1"; exit 1; }

    sleep 3

    mkfs.ext4 $1-part1 && echo "---> created ext4 root filesystem on partition: $1-part1  <--------------------------------------------------------------" || { echo "failed to create ext4 root filesystem on partition: $1-part1"; exit 1; }

fi
