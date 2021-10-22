#!/bin/bash

chroot $TEMPMOUNT /bin/bash -c "ln -s /proc/self/mounts /etc/mtab"

chroot $TEMPMOUNT /bin/bash -c "ln -sf /usr/share/zoneinfo/"$TIMEZONE" /etc/localtime"
chroot $TEMPMOUNT /bin/bash -c "hwclock --systohc"

chroot $TEMPMOUNT /bin/bash -c "echo en_US.UTF-8 UTF-8 >> /etc/locale.gen"

chroot $TEMPMOUNT /bin/bash -c "locale-gen"
chroot $TEMPMOUNT /bin/bash -c "echo LANG=$LANG >> /etc/locale.conf"
chroot $TEMPMOUNT /bin/bash -c "echo $HOSTNAME > /etc/hostname"
chroot $TEMPMOUNT /bin/bash -c "echo 127.0.1.1 $HOSTNAME.$DOMAIN $HOSTNAME >> /etc/hosts"
