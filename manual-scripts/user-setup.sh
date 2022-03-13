#!/bin/bash

HOSTNAME=$(hostname)

USER=$1

USERPASS=$2


zfs create -o canmount=off -o mountpoint=/home zroot/"$HOSTNAME"/DATA/home
    
zfs create -o canmount=on -o mountpoint=/home/$USER zroot/"$HOSTNAME"/DATA/home/"$USER"


mkdir /home/$USER

useradd -M -g users -G sudo,adm,plugdev,dip -s /bin/bash -d /home/$USER $USER

cp -a /etc/skel/. /home/$USER

mkdir -p /home/$USER/.ssh

chown -R $USER:users /home/$USER

echo $USER:$USERPASS | chpasswd

#cp $CONFIGDIR/onboard_toggle.sh $TEMPMOUNT/usr/bin/onboard_toggle.sh

#chroot $TEMPMOUNT /bin/bash -c "chmod +x /usr/bin/onboard_toggle.sh"

#echo '{d1184627-6521-4558-85f9-480c6ad45fab}=Meta+Alt+Space,none,toggle_onboard.sh' >> $TEMPMOUNT/home/$USER/.config/kglobalshortcutsrc

#cp $CONFIGDIR/home/.config/autostart/onboard.desktop $TEMPMOUNT/home/$USER/.config/autostart/onboard.desktop

su - $USER -c "systemctl --user enable surface-dtx-userd.service"

usermod -aG audio,video,games $USER

#cp $CONFIGDIR/home/.conkyrc $TEMPMOUNT/home/$USER/

#cp $CONFIGDIR/home/.conkyrc2 $TEMPMOUNT/home/$USER/

su - $USER -c "systemctl --user enable psd.service"

#mkdir -p $TEMPMOUNT/home/$USER/.config/autostart

#cp $CONFIGDIR/home/.config/autostart/conky* $TEMPMOUNT/home/$USER/.config/autostart/

#cp $CONFIGDIR/home/.config/autostart/caps_remap.desktop $TEMPMOUNT/home/$USER/.config/autostart/caps_remap.desktop


#cp $CONFIGDIR/etc/X11/xorg.conf.d/30-touchpad.conf $TEMPMOUNT/etc/X11/xorg.conf.d/30-touchpad.conf

#cp $CONFIGDIR/caps_remap.sh $TEMPMOUNT/usr/bin/caps_remap.sh

#chroot $TEMPMOUNT /bin/bash -c "chmod +x /usr/bin/caps_remap.sh"


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

chown -R $USER:users /home/$USER