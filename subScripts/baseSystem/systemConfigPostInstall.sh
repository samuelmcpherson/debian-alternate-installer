#!/bin/bash


chroot $TEMPMOUNT /bin/bash -c "apt-file update"

if [ -n "$ZFS" ]
then

    cp ./zfs-recursive-restore.sh $TEMPMOUNT/usr/bin

    chroot $TEMPMOUNT /bin/bash -c "chmod +x /usr/bin/zfs-recursive-restore.sh"

    for file in $TEMPMOUNT/etc/logrotate.d/* ; do
        if grep -Eq "(^|[^#y])compress" "$file" ; then
            sed -i -r "s/(^|[^#y])(compress)/\1#\2/" "$file"
        fi
    done

    chroot $TEMPMOUNT /bin/bash -c "mkdir -p /etc/dkms"

    chroot $TEMPMOUNT /bin/bash -c "echo REMAKE_INITRD=yes > /etc/dkms/zfs.conf"

    cp /etc/hostid $TEMPMOUNT/etc/hostid

    cp /etc/resolv.conf $TEMPMOUNT/etc/resolv.conf

    chroot $TEMPMOUNT /bin/bash -c "zpool set cachefile=/etc/zfs/zpool.cache zroot"

    chroot $TEMPMOUNT /bin/bash -c "systemctl enable zfs.target"
    chroot $TEMPMOUNT /bin/bash -c "systemctl enable zfs-import-cache"
    chroot $TEMPMOUNT /bin/bash -c "systemctl enable zfs-mount"
    chroot $TEMPMOUNT /bin/bash -c "systemctl enable zfs-import.target"

    chroot $TEMPMOUNT /bin/bash -c "cp /usr/share/systemd/tmp.mount /etc/systemd/system/"
    chroot $TEMPMOUNT /bin/bash -c "systemctl enable tmp.mount"

fi

