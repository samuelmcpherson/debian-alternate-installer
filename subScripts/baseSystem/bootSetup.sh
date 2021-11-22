#!/bin/bash

chroot $TEMPMOUNT /bin/bash -c "cd /root && git clone 'https://github.com/zbm-dev/zfsbootmenu.git'"
chroot $TEMPMOUNT /bin/bash -c "cd /root/zfsbootmenu && make install"

chroot $TEMPMOUNT /bin/bash -c "echo yes | cpan 'YAML::PP'"

chroot $TEMPMOUNT /bin/bash -c "mkdir -p /etc/dracut.conf.d"

chroot $TEMPMOUNT /bin/bash -c "rm /etc/dracut.conf.d/*"

chroot $TEMPMOUNT /bin/bash -c "touch /etc/dracut.conf.d/100-zol.conf"
{    
  echo "hostonly=\"no\"" 
  echo "nofsck=\"yes\"" 
  echo "add_dracutmodules+=\" zfs \"" 
  echo "omit_dracutmodules+=\" btrfs \"" 
  #echo "install_items+=\" /etc/zfs/zroot.key \""
} > $TEMPMOUNT/etc/dracut.conf.d/100-zol.conf

chroot $TEMPMOUNT /bin/bash -c "mkdir -p /etc/zfsbootmenu"
chroot $TEMPMOUNT /bin/bash -c "touch /etc/zfsbootmenu/config.yaml"
{
  echo "Global:"
  echo "  ManageImages: true"
  echo "  BootMountPoint: /boot/efi"
  echo "  DracutConfDir: /etc/zfsbootmenu/dracut.conf.d"
  echo "Components:"
  echo "  ImageDir: /boot/efi/EFI/debian"
  echo "  Versions: 3"
  echo "  Enabled: true"
  echo "  syslinux:"
  echo "    Config: /boot/syslinux/syslinux.cfg"
  echo "    Enabled: false"
  echo "EFI:"
  echo "  ImageDir: /boot/efi/EFI/debian"
  echo "  Versions: 2"
  echo "  Enabled: true"
  #echo "  Stub: /usr/lib/systemd/boot/efi/linuxx64.efi.stub"
  echo "Kernel:"
  echo "  CommandLine: ro quiet loglevel=0"
} > $TEMPMOUNT/etc/zfsbootmenu/config.yaml




chroot $TEMPMOUNT /bin/bash -c "dracut --force --kver $(ls $TEMPMOUNT/lib/modules)"

chroot $TEMPMOUNT /bin/bash -c "generate-zbm"

chroot $TEMPMOUNT /bin/bash -c "refind-install"

chroot $TEMPMOUNT /bin/bash -c "mkdir -p /boot/efi/EFI/debian"
chroot $TEMPMOUNT /bin/bash -c "touch /boot/efi/EFI/debian/refind_linux.conf"
echo "\"Boot default\"  \"zfsbootmenu:POOL=zroot zbm.import_policy=hostid zbm.set_hostid zbm.timeout=30 ro quiet loglevel=0\"" > $TEMPMOUNT/boot/efi/EFI/debian/refind_linux.conf
echo "\"Boot to menu\"  \"zfsbootmenu:POOL=zroot zbm.import_policy=hostid zbm.set_hostid zbm.show ro quiet loglevel=0\"" >> $TEMPMOUNT/boot/efi/EFI/debian/refind_linux.conf

#cd $TEMPMOUNT/boot/efi/EFI/debian && wget https://github.com/zbm-dev/zfsbootmenu/releases/download/v1.11.0/zfsbootmenu-x86_64-v1.11.0.EFI
