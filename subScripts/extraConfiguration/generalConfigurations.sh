#!/bin/bash

cd $TEMPMOUNT/home/$USER && git clone $CONFIGREPO


if [ -n "$EFI" ]
then 

    if [ -n "$SURFACE" ]
    then
        rm -r $TEMPMOUNT/boot/efi/EFI/zbm
        cp -r $CONFIGDIR/boot/efi/EFI/debian-surface $TEMPMOUNT/boot/efi/EFI/zbm

    elif [ -n "$MAC" ]
    then
        rm -r $TEMPMOUNT/boot/efi/EFI/zbm
        cp -r $CONFIGDIR/boot/efi/EFI/debian-mac $TEMPMOUNT/boot/efi/EFI/zbm

    elif [ -n "$THINKPAD" ]
    then
        rm -r $TEMPMOUNT/boot/efi/EFI/zbm
        cp -r $CONFIGDIR/boot/efi/EFI/debian-thinkpad $TEMPMOUNT/boot/efi/EFI/zbm

    else
        echo "No zbm initramfs and kernel for this hardware, leaving default release in place."
    
    fi

fi

cp $CONFIGDIR/etc/ssh/ssh_config $TEMPMOUNT/etc/ssh/ssh_config

cp $CONFIGDIR/etc/ssh/sshd_config $TEMPMOUNT/etc/ssh/sshd_config

if [ -n "$ZFS" ]
then

    mkdir $TEMPMOUNT/etc/sanoid
    
    cp $CONFIGDIR/etc/sanoid/ubuntu/sanoid.conf $TEMPMOUNT/etc/sanoid/sanoid.conf

fi

if [ -n "$HIDPI" ]
then

cp $CONFIGDIR/etc/default/console-setup $TEMPMOUNT/etc/default/console-setup

fi

cp $CONFIGDIR/home/.gitconfig $TEMPMOUNT/home/$USER/.gitconfig

cp $CONFIGDIR/home/.vimrc $TEMPMOUNT/home/$USER/.vimrc

mkdir -p $TEMPMOUNT/home/$USER/.ssh

cp $CONFIGDIR/home/.ssh/config $TEMPMOUNT/home/$USER/.ssh/config

chroot $TEMPMOUNT /bin/bash -c "usermod -s $ROOTSHELL root"

if [[ "$ROOTSHELL" = "/bin/zsh" || "$ROOTSHELL" = "/usr/bin/zsh" ]]
then

    cp $TEMPMOUNT/usr/share/zsh-antigen/antigen.zsh $TEMPMOUNT/root/antigen.zsh

    cp $CONFIGDIR/home/.zshrc $TEMPMOUNT/root/.zshrc
    
    chroot $TEMPMOUNT /bin/bash -c "chown -R root:root /root"
fi

chroot $TEMPMOUNT /bin/bash -c "usermod -s $USERSHELL $USER"

if [[ "$USERSHELL" = "/bin/zsh" || "$USERSHELL" = "/usr/bin/zsh" ]]
then
 
    cp $TEMPMOUNT/usr/share/zsh-antigen/antigen.zsh $TEMPMOUNT/home/$USER/antigen.zsh

    cp $CONFIGDIR/home/.zshrc $TEMPMOUNT/home/$USER/.zshrc

    chroot $TEMPMOUNT /bin/bash -c "chown -R $USER:users /home/$USER"
fi

sed -i 's/PATH="\/usr\/local\/bin:\/usr\/bin:\/bin:\/usr\/games"/PATH="\/usr\/local\/sbin:\/usr\/local\/bin:\/usr\/sbin:\/usr\/bin:\/sbin:\/bin:\/usr\/games"/g' $TEMPMOUNT/etc/zsh/zshenv
