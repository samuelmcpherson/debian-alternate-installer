#!/bin/bash

chroot $TEMPMOUNT /bin/bash -c "apt -y update"

chroot $TEMPMOUNT /bin/bash -c "apt dist-upgrade -y && echo '---> apt dist-upgrade succeeded <--------------------------------------------------------------' || { echo 'apt dist-upgrade failed'; exit 1; }" || exit 1

chroot $TEMPMOUNT /bin/bash -c "apt install -y dpkg-dev linux-headers-amd64 linux-image-amd64 systemd-sysv firmware-linux fwupd intel-microcode amd64-microcode dconf-cli  && echo '---> apt install dpkg-dev linux-headers-amd64 linux-image-amd64 systemd-sysv firmware-linux fwupd intel-microcode amd64-microcode dconf-cli succeeded <--------------------------------------------------------------' || { echo 'apt install dpkg-dev linux-headers-amd64 linux-image-amd64 systemd-sysv firmware-linux fwupd intel-microcode amd64-microcode dconf-cli failed'; exit 1; }" || exit 1

if [ -n "$ZFS" ]
then
    chroot $TEMPMOUNT /bin/bash -c "apt install -y zfs-initramfs && echo '---> apt install zfs-dkms zfsutils-linux zfs-zed kexec-tools kexec-tools libconfig-inifiles-perl libsort-versions-perl libboolean-perl fzf mbuffer succeeded <--------------------------------------------------------------' || { echo 'apt install zfs-dkms zfsutils-linux zfs-zed kexec-tools kexec-tools kexec-tools libconfig-inifiles-perl libsort-versions-perl libboolean-perl fzf mbuffer failed'; exit 1; }" || exit 1

    echo REMAKE_INITRD=yes > $TEMPMOUNT/etc/dkms/zfs.conf
fi


if [ -n "$BIOS" ] 
then
    chroot $TEMPMOUNT /bin/bash -c "apt -y install refind && echo '---> apt install refind succeeded <--------------------------------------------------------------' || apt -y install refind failed'; exit 1; }" || exit 1
elif [ -n "$EFI" ]
then
    chroot $TEMPMOUNT /bin/bash -c "apt -y install refind efibootmgr && echo '---> apt install refind efibootmgr succeeded <--------------------------------------------------------------' || { echo 'apt install refind efibootmgr failed'; exit 1; }" || exit 1
fi

chroot $TEMPMOUNT /bin/bash -c "apt -y install locales vim git rsync dosfstools openssh-server curl patch apt-file software-properties-common apt-transport-https && echo '---> apt install locales vim git rsync dosfstools openssh-server curl patch apt-file software-properties-common apt-transport-https succeeded <--------------------------------------------------------------' || { echo 'apt install locales vim git rsync dosfstools openssh-server curl patch apt-file software-properties-common apt-transport-https failed'; exit 1; }" || exit 1

if [ -n "$SECUREBOOT" ]
then
    chroot $TEMPMOUNT /bin/bash -c "apt -y install shim shim-signed && echo '---> apt install shim-signed succeeded <--------------------------------------------------------------' || { echo 'apt install shim-signed failed'; exit 1; }" || exit 1
fi
