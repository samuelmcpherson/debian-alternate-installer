#!/bin/bash

zfs create -o canmount=off -o mountpoint=none zroot/"$HOSTNAME"

zfs create -o canmount=off -o mountpoint=none -o org.zfsbootmenu:rootprefix="root=zfs:" -o org.zfsbootmenu:commandline="ro" zroot/"$HOSTNAME"/ROOT

zfs create -o canmount=noauto -o mountpoint=/ zroot/"$HOSTNAME"/ROOT/default

zfs mount zroot/"$HOSTNAME"/ROOT/default

zpool set bootfs=zroot/"$HOSTNAME"/ROOT/default zroot

zfs create -o canmount=off -o mountpoint=none zroot/"$HOSTNAME"/DATA

zfs create -o canmount=off -o mountpoint=none zroot/"$HOSTNAME"/DATA/var

zfs create -o canmount=off -o mountpoint=none zroot/"$HOSTNAME"/DATA/var/lib

zfs create -o canmount=on -o mountpoint=/var/log zroot/"$HOSTNAME"/DATA/var/log

zfs create -o canmount=off -o mountpoint=/home zroot/"$HOSTNAME"/DATA/home
    
zfs create -o canmount=on -o mountpoint=/home/$USER zroot/"$HOSTNAME"/DATA/home/"$USER"

zfs create -V 16G -b 4096 -o logbias=throughput -o sync=always -o primarycache=metadata -o com.sun:auto-snapshot=false zroot/swap

mkswap -f /dev/zvol/zroot/swap


echo "---> created zfs datasets  <--------------------------------------------------------------" || { echo "failed to create zfs datasets"; exit 1; }

