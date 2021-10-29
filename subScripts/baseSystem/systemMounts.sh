#!/bin/bash

umount -Rl $TEMPMOUNT

if [ -n "$ZFS" ] && [ -n "$EFI" ] && [ -z "$BIOS" ]
then

    zpool export zroot

    zpool import -N -R $TEMPMOUNT zroot

    zfs mount zroot/ROOT/debian/default && echo "---> mounted ZFS boot environment successfully <--------------------------------------------------------------" || { echo "failed to mount ZFS boot environment"; exit 1; }
    

    zfs mount -a && echo "---> mounted all ZFS datasets successfully <--------------------------------------------------------------" || { echo "failed to mount all ZFS datasets"; exit 1; }
    
    mkdir -p $TEMPMOUNT/boot/efi

    mount $EFIPART $TEMPMOUNT/boot/efi && echo "---> mounted EFI partition: $EFIPART to $TEMPMOUNT/boot/efi <--------------------------------------------------------------" || { echo "failed to mount EFI partition: $EFIPART to $TEMPMOUNT/boot/efi"; exit 1; }

    if [ -n "$EFIPART_2" ]
    then

    mkdir -p $TEMPMOUNT/boot/efi2

    mount $EFIPART_2 $TEMPMOUNT/boot/efi2 && echo "---> mounted second EFI partition: $EFIPART_2 to $TEMPMOUNT/boot/efi2 <--------------------------------------------------------------" || { echo "failed to mount second EFI partition: $EFIPART_2 to $TEMPMOUNT/boot/efi2"; exit 1; }

    fi

elif [ -n "$ZFS" ] && [ -z "$EFI" ] && [ -n "$BIOS" ] 
then

    zpool export zroot

    zpool import -N -R $TEMPMOUNT zroot

    zfs mount zroot/ROOT/debian/default && echo "---> mounted ZFS boot environment successfully <--------------------------------------------------------------" || { echo "failed to mount ZFS boot environment"; exit 1; }
    

    zfs mount -a && echo "---> mounted all ZFS datasets successfully <--------------------------------------------------------------" || { echo "failed to mount all ZFS datasets"; exit 1; }


fi


echo /dev/zvol/zroot/swap none swap defaults 0 0 > $TEMPMOUNT/etc/fstab

MOUNT=1

while [ -n "$(mount | grep /mnt | sed -n "$MOUNT"p)" ]
do

if [ -n "$(blkid -s UUID -o value $(mount | grep /mnt | sed -n "$MOUNT"p))" ]
then
    echo /dev/disk/by-uuid/$(blkid -s UUID -o value $(mount | grep /mnt | sed -n "$MOUNT"p)) $(mount | grep /mnt | sed -n "$MOUNT"p | cut -d ' ' -f 3,5) defaults 0 0 >> $TEMPMOUNT/etc/fstab
fi
    MOUNT=$(( $MOUNT+1 ))
done

sed -Ei "s|$TEMPMOUNT/?|/|" $TEMPMOUNT/etc/fstab

mkdir -p $TEMPMOUNT/dev

mkdir -p $TEMPMOUNT/proc

mkdir -p $TEMPMOUNT/sys

mount --rbind /dev $TEMPMOUNT/dev

mount --rbind /proc $TEMPMOUNT/proc

mount --rbind /sys $TEMPMOUNT/sys




 
