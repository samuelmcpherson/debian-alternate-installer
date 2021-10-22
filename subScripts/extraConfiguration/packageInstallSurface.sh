#!/bin/bash

chroot $TEMPMOUNT /bin/bash -c "add-apt-repository -y ppa:graphics-drivers/ppa"

 chroot $TEMPMOUNT /bin/bash -c "wget -qO - https://raw.githubusercontent.com/linux-surface/linux-surface/master/pkg/keys/surface.asc | gpg --dearmor | dd of=/etc/apt/trusted.gpg.d/linux-surface.gpg"

chroot $TEMPMOUNT /bin/bash -c "echo 'deb [arch=amd64] https://pkg.surfacelinux.com/debian release main' > /etc/apt/sources.list.d/linux-surface.list"

chroot $TEMPMOUNT /bin/bash -c "apt update"

if [ "$RELEASE" = "hirsute" ]
then

	chroot $TEMPMOUNT /bin/bash -c "apt install -y linux-image-5.11.11-surface linux-headers-5.11.11-surface && echo '---> apt install linux-image-5.11.11-surface linux-headers-5.11.11-surface succeeded <--------------------------------------------------------------' || { echo 'apt install linux-image-5.11.11-surface linux-headers-5.11.11-surface failed'; exit 1; }" || exit 1

fi

chroot $TEMPMOUNT /bin/bash -c "apt install -y iptsd libwacom-surface surface-control surface-dtx-daemon && echo '---> apt install iptsd libwacom-surface surface-control surface-dtx-daemon succeeded <--------------------------------------------------------------' || { echo 'apt install iptsd libwacom-surface surface-control surface-dtx-daemon failed'; exit 1; }" || exit 1 

chroot $TEMPMOUNT /bin/bash -c "apt install -y zfs-dkms nvidia-dkms-460 && echo '---> apt install zfs-dkms nvidia-dkms-460 succeeded <--------------------------------------------------------------' || { echo 'apt install zfs-dkms nvidia-dkms-460 failed'; exit 1; }" || exit 1 

if [ -n "$SECUREBOOT" ]
then

	chroot $TEMPMOUNT /bin/bash -c "apt install -y linux-surface-secureboot-mok && echo '---> apt install linux-surface-secureboot-mok succeeded <--------------------------------------------------------------' || { echo 'apt install linux-surface-secureboot-mok failed'; exit 1; }" || exit 1 

fi
