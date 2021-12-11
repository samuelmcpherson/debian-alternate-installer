#!/bin/bash

if [ -n "$SURFACE" ]
then
  cp -r $CONFIGDIR/boot/efi/EFI/debian-surface /mnt/boot/efi/EFI/debian

elif [ -n "$MAC" ]
then
  cp -r $CONFIGDIR/boot/efi/EFI/debian-mac /mnt/boot/efi/EFI/debian

elif [ -n "$MAC" ]
then
  cp -r $CONFIGDIR/boot/efi/EFI/debian-thinkpad /mnt/boot/efi/EFI/debian

else
  chroot $TEMPMOUNT /bin/bash -c "mkdir -p /boot/efi/EFI/debian"
  chroot $TEMPMOUNT /bin/bash -c "touch /boot/efi/EFI/debian/refind_linux.conf"
  echo "\"Boot default\"  \"zfsbootmenu:POOL=zroot zbm.import_policy=hostid zbm.set_hostid zbm.timeout=30 ro quiet loglevel=0\"" > $TEMPMOUNT/boot/efi/EFI/debian/refind_linux.conf
  echo "\"Boot to menu\"  \"zfsbootmenu:POOL=zroot zbm.import_policy=hostid zbm.set_hostid zbm.show ro quiet loglevel=0\"" >> $TEMPMOUNT/boot/efi/EFI/debian/refind_linux.conf

  cd $TEMPMOUNT/boot/efi/EFI/debian && wget https://github.com/zbm-dev/zfsbootmenu/releases/download/v1.11.0/zfsbootmenu-x86_64-v1.11.0.EFI

fi
