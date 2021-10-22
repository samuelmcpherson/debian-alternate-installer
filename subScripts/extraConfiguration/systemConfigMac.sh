#!/bin/bash

chroot $TEMPMOUNT /bin/bash -c "apt install -y firmware-b43-installer mbpfan && echo '---> apt install firmware-b43-installer mbpfan succeeded <--------------------------------------------------------------' || { echo 'apt install firmware-b43-installer mbpfan failed'; exit 1; }" || exit 1

chroot $TEMPMOUNT /bin/bash -c "systemctl unmask mbpfan"

chroot $TEMPMOUNT /bin/bash -c "echo coretemp >> /etc/modules"

chroot $TEMPMOUNT /bin/bash -c "echo applesmc >> /etc/modules"

chroot $TEMPMOUNT /bin/bash -c "echo hid_apple >> /etc/modules"

cp $CONFIGDIR/etc/udev/rules.d/90-xhc_sleep.rules $TEMPMOUNT/etc/udev/rules.d/90-xhc_sleep.rules

#chroot $TEMPMOUNT /bin/bash -c "touch /etc/modprobe.d/hid_apple.conf"

if [[ -n "$FNKEYMODESWAP" ]]
then
#    chroot $TEMPMOUNT /bin/bash -c "echo options hid_apple fnmode=2 >> /etc/modprobe.d/hid_apple.conf"

    chroot $TEMPMOUNT /bin/bash -c "touch /etc/systemd/system/apple-fn-mode-swap.service"

    {
    echo "[Unit]"
    echo "Description=Apple Fn mode swap"
    echo ""
    echo "[Service]"
    echo "ExecStart=/bin/bash -c '/usr/bin/echo 2 > /sys/module/hid_apple/parameters/fnmode'"
    echo ""
    echo "[Install]"
    echo "WantedBy=multi-user.target"
    } > $TEMPMOUNT/etc/systemd/system/apple-fn-mode-swap.service

    chroot $TEMPMOUNT /bin/bash -c "systemctl enable apple-fn-mode-swap.service"

fi

if [[ -n "$ALTCMDKEYSWAP" ]]
then
#    chroot $TEMPMOUNT /bin/bash -c "echo options hid_apple swap_opt_cmd=1 >> /etc/modprobe.d/hid_apple.conf"

    chroot $TEMPMOUNT /bin/bash -c "touch /etc/systemd/system/apple-alt-cmd-key-swap.service"

    {
    echo "[Unit]"
    echo "Description=Apple Alt Cmd key swap"
    echo ""
    echo "[Service]"
    echo "ExecStart=/bin/bash -c '/usr/bin/echo 1 > /sys/module/hid_apple/parameters/swap_opt_cmd'"
    echo ""
    echo "[Install]"
    echo "WantedBy=multi-user.target"
    } > $TEMPMOUNT/etc/systemd/system/apple-alt-cmd-key-swap.service

    chroot $TEMPMOUNT /bin/bash -c "systemctl enable apple-alt-cmd-key-swap.service"

fi


