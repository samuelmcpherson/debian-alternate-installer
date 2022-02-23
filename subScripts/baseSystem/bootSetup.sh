#!/bin/bash

if [ -n "$EFI" ]
then 

    chroot $TEMPMOUNT /bin/bash -c "mkdir -p /boot/efi/EFI/zbm"
    chroot $TEMPMOUNT /bin/bash -c "touch /boot/efi/EFI/zbm/refind_linux.conf"
    echo "\"Boot default\"  \"zfsbootmenu:POOL=zroot zbm.import_policy=hostid zbm.set_hostid zbm.timeout=30 ro quiet loglevel=0\"" > $TEMPMOUNT/boot/efi/EFI/zbm/refind_linux.conf
    echo "\"Boot to menu\"  \"zfsbootmenu:POOL=zroot zbm.import_policy=hostid zbm.set_hostid zbm.show ro quiet loglevel=0\"" >> $TEMPMOUNT/boot/efi/EFI/zbm/refind_linux.conf

    cd $TEMPMOUNT/boot/efi/EFI/zbm && wget https://github.com/zbm-dev/zfsbootmenu/releases/download/v1.11.0/zfsbootmenu-x86_64-v1.11.0.EFI
        
    chroot $TEMPMOUNT /bin/bash -c "mkdir -p /boot/efi/EFI/debian"
    chroot $TEMPMOUNT /bin/bash -c "touch /boot/efi/EFI/debian/refind_linux.conf"
    echo "\"Standard boot\"   \"dozfs=force root=ZFS=zroot/$HOSTNAME/ROOT/default rw\"" > $TEMPMOUNT/boot/efi/EFI/debian/refind_linux.conf


    if [ "$EFIPART_2" ]
    then
        chroot $TEMPMOUNT /bin/bash -c "/usr/bin/rsync -a /boot/efi/ /boot/efi2"
    fi

    chroot $TEMPMOUNT /bin/bash -c "mkdir -p /etc/initramfs/post-update.d"

    chroot $TEMPMOUNT /bin/bash -c "touch /etc/initramfs/post-update.d/10-copytoefi"


    {
    echo '#!/usr/bin/env bash'
    
    echo ''
    
    echo 'mount /boot/efi && cp -fv $(realpath /{vmlinuz,initrd.img}) /boot/efi/EFI/debian && umount /boot/efi'

    if [ "$EFIPART_2" ]
    then
        echo ''
        
        echo "mount /boot/efi2 && cp -fv $(realpath /{vmlinuz,initrd.img}) /boot/efi2/EFI/debian && umount /boot/efi2"
    fi 
    } > $TEMPMOUNT/etc/initramfs/post-update.d/10-copytoefi


    chroot $TEMPMOUNT /bin/bash -c "chmod +x /etc/initramfs/post-update.d/10-copytoefi"

    chroot $TEMPMOUNT /bin/bash -c "/etc/initramfs/post-update.d/10-copytoefi"

fi
