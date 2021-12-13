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

chroot $TEMPMOUNT /bin/bash -c "chmod +x /usr/bin/caps_remap.sh"

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

    mkdir -p $TEMPMOUNT/home/$USER/.config/gebaar

    cp $CONFIGDIR/home/.config/autostart/gebaard.desktop $TEMPMOUNT/home/$USER/.config/autostart

    echo "Run 'make install' from ~/gebaar-libinput-fork/build on boot"

    chroot $TEMPMOUNT /bin/bash -c "chown -R $USER:users /home/$USER"

    if [[ -n "$KDE" ]]
    then 

        if [[ -z "$PARACHUTE" ]] && [[ -n "$BISMUTH" ]] && [[ -z "$KROHNKITE" ]] 
        then 
            cp $CONFIGDIR/home/.config/gebaar/gebaard-kde-bismuth.toml $TEMPMOUNT/home/$USER/.config/gebaar/gebaard.toml

        elif [[ -z "$PARACHUTE" ]] && [[ -z "$BISMUTH" ]] && [[ -n "$KROHNKITE" ]] 
        then 
            cp $CONFIGDIR/home/.config/gebaar/gebaard-kde-krohnkite.toml $TEMPMOUNT/home/$USER/.config/gebaar/gebaard.toml

        elif [[ -n "$PARACHUTE" ]] && [[ -n "$BISMUTH" ]] && [[ -z "$KROHNKITE" ]]
        then 
            cp $CONFIGDIR/home/.config/gebaar/gebaard-kde-parachute-bismuth.toml $TEMPMOUNT/home/$USER/.config/gebaar/gebaard.toml


        elif [[ -n "$PARACHUTE" ]] && [[ -z "$BISMUTH" ]] && [[ -n "$KROHNKITE" ]]
        then 
            cp $CONFIGDIR/home/.config/gebaar/gebaard-kde-parachute-krohnkite.toml $TEMPMOUNT/home/$USER/.config/gebaar/gebaard.toml
        
        elif [[ -n "$PARACHUTE" ]] && [[ -z "$KROHNKITE" ]] && [[ -z "$BISMUTH" ]]
        then 
            cp $CONFIGDIR/home/.config/gebaar/gebaard-kde-parachute.toml $TEMPMOUNT/home/$USER/.config/gebaar/gebaard.toml
        
        elif [[ -z "$PARACHUTE" ]] && [[ -z "$BISMUTH" ]] && [[ -z "$KROHNKITE" ]] 
        then 
            cp $CONFIGDIR/home/.config/gebaar/gebaard-kde.toml $TEMPMOUNT/home/$USER/.config/gebaar/gebaard.toml
        
        else

            echo "Inconprehensible combination of kwin scripts to setup gestures for"

        fi
    
    fi    

fi
   
chroot $TEMPMOUNT /bin/bash -c "chown -R $USER:users /home/$USER"

{

echo '[connection]'
echo 'wifi.powersave = 2'

} >> $TEMPMOUNT/etc/NetworkManager/NetworkManager.conf

{

echo 'blacklist nouveau'
echo 'options nouveau modeset=0'    

} > $TEMPMOUNT/etc/modprobe.d/blacklist-nouveau.conf

chroot $TEMPMOUNT /bin/bash -c "update-initramfs -c -k all"
