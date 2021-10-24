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




if [[ -z "$DESKTOP" ]] && [[ -n "$DESKTOP" ]]
then

  chroot $TEMPMOUNT /bin/bash -c "git -C /tmp clone 'https://github.com/dracut-crypt-ssh/dracut-crypt-ssh.git'"

  chroot $TEMPMOUNT /bin/bash -c "cp -r /tmp/dracut-crypt-ssh/modules/60crypt-ssh /usr/lib/dracut/modules.d/60crypt-ssh"

  chroot $TEMPMOUNT /bin/bash -c "rm /usr/lib/dracut/modules.d/60crypt-ssh/Makefile"
		
  sed -i 's,  inst "\$moddir"/helper/console_auth /bin/console_auth,  #inst "\$moddir"/helper/console_auth /bin/console_auth,' "$TEMPMOUNT/usr/lib/dracut/modules.d/60crypt-ssh/module-setup.sh"
	
  sed -i 's,  inst "\$moddir"/helper/console_peek.sh /bin/console_peek,  #inst "\$moddir"/helper/console_peek.sh /bin/console_peek,' "$TEMPMOUNT/usr/lib/dracut/modules.d/60crypt-ssh/module-setup.sh"

  sed -i 's,  inst "\$moddir"/helper/unlock /bin/unlock,  #inst "\$moddir"/helper/unlock /bin/unlock,' "$TEMPMOUNT/usr/lib/dracut/modules.d/60crypt-ssh/module-setup.sh"

  sed -i 's,  inst "\$moddir"/helper/unlock-reap-success.sh /sbin/unlock-reap-success,  #inst "\$moddir"/helper/unlock-reap-success.sh /sbin/unlock-reap-success,' "$TEMPMOUNT/usr/lib/dracut/modules.d/60crypt-ssh/module-setup.sh"

  chroot $TEMPMOUNT /bin/bash -c "mkdir -p /etc/dropbear"
		
  chroot $TEMPMOUNT /bin/bash -c 'ssh-keygen -t rsa -m PEM -f /etc/dropbear/ssh_host_rsa_key -N ""'

  chroot $TEMPMOUNT /bin/bash -c 'ssh-keygen -t ecdsa -m PEM -f /etc/dropbear/ssh_host_ecdsa_key -N ""'
		
  chroot $TEMPMOUNT /bin/bash -c "mkdir -p /etc/cmdline.d"

  chroot $TEMPMOUNT /bin/bash -c 'echo "ip=dhcp rd.neednet=1" > /etc/cmdline.d/dracut-network.conf'


  chroot $TEMPMOUNT /bin/bash -c "touch /etc/zfsbootmenu/dracut.conf.d/zbm"
  {
    echo "#!/bin/sh"

    echo "rm /zfsbootmenu/active"

    echo "zfsbootmenu"		
  } >> $TEMPMOUNT/etc/zfsbootmenu/dracut.conf.d/zbm

  chroot $TEMPMOUNT /bin/bash -c "chmod 755 /etc/zfsbootmenu/dracut.conf.d/zbm"

  chroot $TEMPMOUNT /bin/bash -c "touch /etc/zfsbootmenu/dracut.conf.d/banner.txt"

  echo 'Welcome to the ZFSBootMenu initramfs shell. Enter "zbm" to start ZFSBootMenu.' > $TEMPMOUNT/etc/zfsbootmenu/dracut.conf.d/banner.txt

  chroot $TEMPMOUNT /bin/bash -c "chmod 755 /etc/zfsbootmenu/dracut.conf.d/banner.txt"

  sed -i 's,  /sbin/dropbear -s -j -k -p \${dropbear_port} -P /tmp/dropbear.pid,  /sbin/dropbear -s -j -k -p \${dropbear_port} -P /tmp/dropbear.pid -b /etc/banner.txt,' $TEMPMOUNT/usr/lib/dracut/modules.d/60crypt-ssh/dropbear-start.sh
		
  sed -i '$ s,^},,' "$TEMPMOUNT/usr/lib/dracut/modules.d/60crypt-ssh/module-setup.sh"

  {
    echo "  ##Copy ZFSBootMenu start helper script" 
    echo "  inst /etc/zfsbootmenu/dracut.conf.d/zbm /usr/bin/zbm" 
    echo "" 
    echo "  ##Copy dropbear welcome message" 
    echo "  inst /etc/zfsbootmenu/dracut.conf.d/banner.txt /etc/banner.txt" 
    echo "}" 
  } >> "$TEMPMOUNT/usr/lib/dracut/modules.d/60crypt-ssh/module-setup.sh"
		
  chroot $TEMPMOUNT /bin/bash -c "touch /etc/zfsbootmenu/dracut.conf.d/dropbear.conf"
  {			
    echo '## Enable dropbear ssh server and pull in network configuration args'
    echo '##The default configuration will start dropbear on TCP port 222.'
	  echo '##This can be overridden with the dropbear_port configuration option.'
	  echo '##You do not want the server listening on the default port 22.'
	  echo '##Clients that expect to find your normal host keys when connecting to an SSH server on port 22 will'
	  echo '##refuse to connect when they find different keys provided by dropbear.'
	  echo 'add_dracutmodules+=" crypt-ssh "'
	  echo 'install_optional_items+=" /etc/cmdline.d/dracut-network.conf "'
	  echo '## Copy system keys for consistent access'
	  echo 'dropbear_rsa_key=/etc/dropbear/ssh_host_rsa_key'
	  echo 'dropbear_ecdsa_key=/etc/dropbear/ssh_host_ecdsa_key'
	  echo '##Access by authorized keys only. No password.'
	  echo '##By default, the list of authorized keys is taken from /root/.ssh/authorized_keys on the host.'
	  echo '##Remember to "generate-zbm" after adding the remote user key to the authorized_keys file.'
	  echo '##The last line is optional and assumes the specified user provides an authorized_keys file'
	  echo '##that will determine remote access to the ZFSBootMenu image.'
	  echo '##Note that login to dropbear is "root" regardless of which authorized_keys is used.'
	  echo "dropbear_acl=/home/$USER/.ssh/authorized_keys"
  } > $TEMPMOUNT/etc/zfsbootmenu/dracut.conf.d/dropbear.conf

fi		

chroot $TEMPMOUNT /bin/bash -c "systemctl stop dropbear"

chroot $TEMPMOUNT /bin/bash -c "systemctl disable dropbear"
		



chroot $TEMPMOUNT /bin/bash -c "dracut --force --kver $(ls $TEMPMOUNT/lib/modules)"

chroot $TEMPMOUNT /bin/bash -c "generate-zbm"

chroot $TEMPMOUNT /bin/bash -c "refind-install"

chroot $TEMPMOUNT /bin/bash -c "mkdir -p /boot/efi/EFI/debian"
chroot $TEMPMOUNT /bin/bash -c "touch /boot/efi/EFI/debian/refind_linux.conf"
echo "\"Boot default\"  \"zfsbootmenu:POOL=zroot zbm.import_policy=hostid zbm.set_hostid zbm.timeout=30 ro quiet loglevel=0\"" > $TEMPMOUNT/boot/efi/EFI/debian/refind_linux.conf
echo "\"Boot to menu\"  \"zfsbootmenu:POOL=zroot zbm.import_policy=hostid zbm.set_hostid zbm.show ro quiet loglevel=0\"" >> $TEMPMOUNT/boot/efi/EFI/debian/refind_linux.conf
