#!/bin/bash


chroot $TEMPMOUNT /bin/bash -c "/usr/bin/rsync -a /boot/efi/ /boot/efi2"

#chroot $TEMPMOUNT /bin/bash -c "efibootmgr -cgd $EFIPART_2 -p 1 -L 'debian-2' -l '\EFI\debian\grubx64.efi'"


#echo "[Unit]" >> $TEMPMOUNT/usr/lib/systemd/system/efis-sync.path
#echo "Description=Monitor changes in EFI system partition" >> $TEMPMOUNT/usr/lib/systemd/system/efis-sync.path

#echo "" >> $TEMPMOUNT/usr/lib/systemd/system/efis-sync.path

#echo "[Path]" >> $TEMPMOUNT/usr/lib/systemd/system/efis-sync.path
#echo "PathModified=/boot/efi/EFI" >> $TEMPMOUNT/usr/lib/systemd/system/efis-sync.path

#echo "" >> $TEMPMOUNT/usr/lib/systemd/system/efis-sync.path

#echo "[Install]" >> $TEMPMOUNT/usr/lib/systemd/system/efis-sync.path
#echo "WantedBy=multi-user.target" >> $TEMPMOUNT/usr/lib/systemd/system/efis-sync.path


#echo "[Unit]" >> $TEMPMOUNT/usr/lib/systemd/system/efis-sync.service
#echo "Description=Sync EFI system partition contents to backups" >> $TEMPMOUNT/usr/lib/systemd/system/efis-sync.service

#echo "" >> $TEMPMOUNT/usr/lib/systemd/system/efis-sync.service

#echo "[Service]" >> $TEMPMOUNT/usr/lib/systemd/system/efis-sync.service
#echo "Type=oneshot" >> $TEMPMOUNT/usr/lib/systemd/system/efis-sync.service
#echo "ExecStart=/bin/bash -c '/usr/bin/rsync -a /boot/efi/ /boot/efi2'" >> $TEMPMOUNT/usr/lib/systemd/system/efis-sync.service


#chroot $TEMPMOUNT /bin/bash -c "systemctl enable efis-sync.path"
