#!/bin/bash

mkdir -p $TEMPMOUNT/home/$USER/.local

mkdir -p $TEMPMOUNT/home/$USER/.config

mkdir -p $TEMPMOUNT/home/$USER/.kde

if [ -n "$HIDPI" ]
then
    cp -r $CONFIGDIR/home/hidpi/kde/.local/* $TEMPMOUNT/home/$USER/.local/
    cp -r $CONFIGDIR/home/hidpi/kde/.config/* $TEMPMOUNT/home/$USER/.config/
    cp -r $CONFIGDIR/home/hidpi/kde/.kde/* $TEMPMOUNT/home/$USER/.kde/
else
    cp -r $CONFIGDIR/home/kde/.local/* $TEMPMOUNT/home/$USER/.local/
    cp -r $CONFIGDIR/home/kde/.config/* $TEMPMOUNT/home/$USER/.config/
    cp -r $CONFIGDIR/home/kde/.kde/* $TEMPMOUNT/home/$USER/.kde/
fi

cp $CONFIGDIR/wallpaper/* $TEMPMOUNT/usr/share/wallpapers/

chroot $TEMPMOUNT /bin/bash -c "chown -R $USER:users /home/$USER"

if [[ -n "$PARACHUTE" ]]
then
    chroot $TEMPMOUNT su - $USER -c "cd /home/$USER && git clone https://github.com/tcorreabr/Parachute.git"

    sleep 2

    chroot $TEMPMOUNT su - $USER -c "cd /home/$USER/Parachute && make install"

    sleep 2
fi

if [[ -n "$KROHNKITE" ]]
then
    chroot $TEMPMOUNT su - $USER -c "cd /home/$USER && git clone https://github.com/esjeon/krohnkite.git"

    sleep 2

    chroot $TEMPMOUNT su - $USER -c "cd /home/$USER/krohnkite && make install"

    sleep 2

    chroot $TEMPMOUNT su - $USER -c "mkdir -p ~/.local/share/kservices5/"

    chroot $TEMPMOUNT su - $USER -c "ln -s ~/.local/share/kwin/scripts/krohnkite/metadata.desktop ~/.local/share/kservices5/krohnkite.desktop"
fi