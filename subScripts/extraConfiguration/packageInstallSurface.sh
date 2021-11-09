#!/bin/bash

chroot $TEMPMOUNT /bin/bash -c "wget -qO - https://raw.githubusercontent.com/linux-surface/linux-surface/master/pkg/keys/surface.asc | gpg --dearmor | dd of=/etc/apt/trusted.gpg.d/linux-surface.gpg"

chroot $TEMPMOUNT /bin/bash -c "echo 'deb [arch=amd64] https://pkg.surfacelinux.com/debian release main' > /etc/apt/sources.list.d/linux-surface.list"

chroot $TEMPMOUNT /bin/bash -c "apt update"

chroot $TEMPMOUNT /bin/bash -c "apt install -y linux-image-surface linux-headers-surface && echo '---> apt install linux-image-surface linux-headers-surface succeeded <--------------------------------------------------------------' || { echo 'apt install linux-image-surface linux-headers-surface failed'; exit 1; }" || exit 1

chroot $TEMPMOUNT /bin/bash -c "apt install -y iptsd libwacom-surface surface-control surface-dtx-daemon && echo '---> apt install iptsd libwacom-surface surface-control surface-dtx-daemon succeeded <--------------------------------------------------------------' || { echo 'apt install iptsd libwacom-surface surface-control surface-dtx-daemon failed'; exit 1; }" || exit 1 


if [ -n "$SECUREBOOT" ]
then

	chroot $TEMPMOUNT /bin/bash -c "apt install -y linux-surface-secureboot-mok && echo '---> apt install linux-surface-secureboot-mok succeeded <--------------------------------------------------------------' || { echo 'apt install linux-surface-secureboot-mok failed'; exit 1; }" || exit 1 

fi

cp $CONFIGDIR/surface/NetworkManager.conf $TEMPMOUNT/etc/NetworkManager/

cp $CONFIGDIR/surface/thermal-conf.xml $TEMPMOUNT/etc/thermald/

cp $CONFIGDIR/surface/thermal-cpu-cdev-order.xml $TEMPMOUNT/etc/thermald/
 
#chroot $TEMPMOUNT /bin/bash -c "amixer -c 0 sset 'Auto-Mute Mode' Disabled"

#chroot $TEMPMOUNT /bin/bash -c "alsactl store"

chroot $TEMPMOUNT /bin/bash -c "systemctl enable surface-dtx-daemon.service"

chroot $TEMPMOUNT su - $USER -c "systemctl --user enable surface-dtx-userd.service"

chroot $TEMPMOUNT /bin/bash -c "systemctl enable iptsd"
