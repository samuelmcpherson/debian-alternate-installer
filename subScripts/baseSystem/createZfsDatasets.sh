#!/bin/bash

zfs create -o canmount=off -o mountpoint=none -o org.zfsbootmenu:rootprefix="root=zfs:" -o org.zfsbootmenu:commandline="ro" zroot/ROOT

zfs create -o canmount=noauto -o mountpoint=/ zroot/ROOT/debian

zfs mount zroot/ROOT/debian

zpool set bootfs=zroot/ROOT/debian zroot

zfs create -o canmount=off -o mountpoint=none zroot/DATA

zfs create -o canmount=off -o mountpoint=none zroot/DATA/debian

zfs create -o canmount=off -o mountpoint=none zroot/DATA/debian/var

zfs create -o canmount=off -o mountpoint=none zroot/DATA/debian/var/lib

zfs create -o canmount=on -o mountpoint=/var/log zroot/DATA/debian/var/log

zfs create -o canmount=off -o mountpoint=/home zroot/DATA/debian/home
    
zfs create -o canmount=on -o mountpoint=/home/$USER zroot/DATA/debian/home/"$USER"

zfs create -V 20G -b 4096 -o logbias=throughput -o sync=always -o primarycache=metadata -o com.sun:auto-snapshot=false zroot/swap

mkswap -f /dev/zvol/zroot/swap


echo "---> created zfs datasets  <--------------------------------------------------------------" || { echo "failed to create zfs datasets"; exit 1; }

