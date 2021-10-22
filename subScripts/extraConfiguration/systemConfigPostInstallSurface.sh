#!/bin/bash
 
cp $WORKDIR/$FILEREPO/surface/NetworkManager.conf $TEMPMOUNT/etc/NetworkManager/

cp $WORKDIR/$FILEREPO/surface/thermal-conf.xml $TEMPMOUNT/etc/thermald/

cp $WORKDIR/$FILEREPO/surface/thermal-cpu-cdev-order.xml $TEMPMOUNT/etc/thermald/
 
chroot $TEMPMOUNT /bin/bash -c "amixer -c 0 sset 'Auto-Mute Mode' Disabled"

chroot $TEMPMOUNT /bin/bash -c "alsactl store"

chroot $TEMPMOUNT /bin/bash -c "systemctl enable surface-dtx-daemon.service"

chroot $TEMPMOUNT su - $USER -c "systemctl --user enable surface-dtx-userd.service"

chroot $TEMPMOUNT /bin/bash -c "systemctl enable iptsd"