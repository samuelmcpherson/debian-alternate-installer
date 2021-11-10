#!/bin/bash

zfs create -o canmount=on -o mountpoint=/home/ansible zroot/"$HOSTNAME"/DATA/home/ansible

mkdir $TEMPMOUNT/home/ansible

chroot $TEMPMOUNT /bin/bash -c "apt install -y ansible && echo '---> apt install ansible succeeded <--------------------------------------------------------------' || { echo 'apt install ansible failed'; exit 1; }" || exit 1

chroot $TEMPMOUNT /bin/bash -c "useradd -M -s /bin/bash -d /home/ansible ansible"

chroot $TEMPMOUNT /bin/bash -c "touch /etc/sudoers.d/030_ansible-nopasswd"

chroot $TEMPMOUNT /bin/bash -c "echo 'ansible ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/030_ansible-nopasswd"

chroot $TEMPMOUNT /bin/bash -c "mkdir -p /home/ansible/.ssh" 

cp $CONFIGDIR/home/.ssh/ansible/authorized_keys $TEMPMOUNT/home/ansible/.ssh/

chroot $TEMPMOUNT /bin/bash -c "chown -R ansible:ansible /home/ansible"
