#!/bin/bash

chroot $TEMPMOUNT /bin/bash -c "apt install -y mbpfan && echo '---> apt install mbpfan succeeded <--------------------------------------------------------------' || { echo 'apt install mbpfan failed'; exit 1; }" || exit 1

if [[ -n "$MACWIFIWL" ]]
then
    chroot $TEMPMOUNT /bin/bash -c "apt install -y broadcom-sta-common && echo '---> apt install broadcom-sta-common succeeded <--------------------------------------------------------------' || { echo 'apt install broadcom-sta-common failed'; exit 1; }" || exit 1

elif [[ -n "$MACWIFIB43" ]]
then

    chroot $TEMPMOUNT /bin/bash -c "apt install -y firmware-b43-installer && echo '---> apt install firmware-b43-installer succeeded <--------------------------------------------------------------' || { echo 'apt install firmware-b43-installer failed'; exit 1; }" || exit 1

else 
    echo ""

fi

chroot $TEMPMOUNT /bin/bash -c "systemctl unmask mbpfan"

chroot $TEMPMOUNT /bin/bash -c "echo coretemp >> /etc/modules"

chroot $TEMPMOUNT /bin/bash -c "echo applesmc >> /etc/modules"

chroot $TEMPMOUNT /bin/bash -c "echo hid_apple >> /etc/modules"

cp $CONFIGDIR/etc/udev/rules.d/90-xhc_sleep.rules $TEMPMOUNT/etc/udev/rules.d/90-xhc_sleep.rules

chroot $TEMPMOUNT /bin/bash -c "touch /etc/modprobe.d/hid_apple.conf"

if [[ -n "$FNKEYMODESWAP" ]]
then
    chroot $TEMPMOUNT /bin/bash -c "'echo options hid_apple fnmode=2' >> /etc/modprobe.d/hid_apple.conf"
fi

if [[ -n "$FNKEYMODESWAP" ]]
then
    chroot $TEMPMOUNT /bin/bash -c "'echo options hid_apple swap_opt_cmd=1' >> /etc/modprobe.d/hid_apple.conf"
fi

chroot $TEMPMOUNT /bin/bash -c "update-initramfs -c -k all"


