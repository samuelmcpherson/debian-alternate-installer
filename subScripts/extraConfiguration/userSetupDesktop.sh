#!/bin/bash

chroot $TEMPMOUNT /bin/bash -c "usermod -aG audio,video,games $USER" #wireshark

if [ -n "$HIDPI" ]
then
    cp $CONFIGDIR/home/hidpi/.conkyrc $TEMPMOUNT/home/$USER/

    cp $CONFIGDIR/home/hidpi/.conkyrc2 $TEMPMOUNT/home/$USER/
else
    cp $CONFIGDIR/home/.conkyrc $TEMPMOUNT/home/$USER/

    cp $CONFIGDIR/home/.conkyrc2 $TEMPMOUNT/home/$USER/
fi

chroot $TEMPMOUNT su - $USER -c "systemctl --user enable psd.service"

cp $CONFIGDIR/etc/X11/xorg.conf.d/30-touchpad.conf $TEMPMOUNT/etc/X11/xorg.conf.d/30-touchpad.conf

cp $CONFIGDIR/caps_remap.sh $TEMPMOUNT/usr/bin/caps_remap.sh

mkdir -p $TEMPMOUNT/home/$USER/.config/autostart

cp $CONFIGDIR/home/.config/autostart/conky* $TEMPMOUNT/home/$USER/.config/autostart/

cp $CONFIGDIR/home/.config/autostart/caps_remap.desktop $TEMPMOUNT/home/$USER/.config/autostart/caps_remap.desktop

if [[ -n "$GESTURES" ]]
then
    chroot $TEMPMOUNT /bin/bash -c "usermod -aG input $USER" 

    chroot $TEMPMOUNT su - $USER -c "cd /home/$USER && git clone https://github.com/osleg/gebaar-libinput-fork.git"

    chroot $TEMPMOUNT su - $USER -c "cd /home/$USER/gebaar-libinput-fork  && git checkout v0.1.4 && git submodule update --init"

    sleep 2

    chroot $TEMPMOUNT su - $USER -c "mkdir /home/$USER/gebaar-libinput-fork/build && cd /home/$USER/gebaar-libinput-fork/build && cmake .. && make -j$(nproc)"

    sleep 2

    cp -r $CONFIGDIR/home/.config/gebaar $TEMPMOUNT/home/$USER/.config/gebaar

    cp $CONFIGDIR/home/.config/autostart/gebaard.desktop $TEMPMOUNT/home/$USER/.config/autostart

    echo "Run 'make install' from ~/gebaar-libinput-fork/build on boot"
fi

chroot $TEMPMOUNT /bin/bash -c "chown -R $USER:users /home/$USER"
