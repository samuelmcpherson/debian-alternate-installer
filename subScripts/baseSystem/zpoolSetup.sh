#!/bin/bash

# takes input $DISK1-part3 as $1 (and $DISK2-part3 as $2 for mirror setups) for full disk format installs

# takes input $ZFSPART as $1 for no drive formatting installs 



zpool create -f -o ashift=12 -o autotrim=on -O acltype=posixacl -O compression=lz4 -O dnodesize=auto -O relatime=on -O xattr=sa -O normalization=formD -O canmount=off -O mountpoint=/ -R $TEMPMOUNT zroot $MIRROR $1 $2 && echo "---> created $MIRROR zpool: zroot with $1  $2  <--------------------------------------------------------------" || { echo "failed to create $MIRROR zpool: zroot with $1  $2"; exit 1; }

sleep 2