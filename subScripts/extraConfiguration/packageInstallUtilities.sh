#!/bin/bash

chroot $TEMPMOUNT /bin/bash -c "apt -y update"

chroot $TEMPMOUNT /bin/bash -c "apt dist-upgrade --yes && echo '---> apt dist-upgrade succeeded <--------------------------------------------------------------' || { echo 'apt dist-upgrade failed'; exit 1; }" || exit 1

chroot $TEMPMOUNT /bin/bash -c "apt -y install zsh zsh-antigen wget git irssi lynx elinks lm-sensors net-tools screen tmux sysstat htop iotop ripgrep nmap iftop vim tcpdump cups samba smartmontools make cmake build-essential libsystemd-dev pkg-config && echo '---> apt install zsh zsh-antigen wget git irssi lynx elinks lm-sensors net-tools screen tmux sysstat htop iotop ripgrep nmap iftop vim thermald tcpdump cups samba pv smartmontools make cmake build-essential libsystemd-dev pkg-config succeeded <--------------------------------------------------------------' || { echo 'apt install zsh zsh-antigen wget git irssi lynx elinks lm-sensors net-tools screen tmux sysstat htop iotop ripgrep nmap iftop vim thermald tcpdump cups samba pv smartmontools make cmake build-essential libsystemd-dev pkg-config failed'; exit 1; }" || exit 1

if [ -n "$ZFS" ]
then

chroot $TEMPMOUNT /bin/bash -c "apt install -y debhelper libcapture-tiny-perl libconfig-inifiles-perl pv lzop mbuffer && echo '---> apt install debhelper libcapture-tiny-perl libconfig-inifiles-perl pv lzop mbuffer succeeded <--------------------------------------------------------------' || { echo 'apt install debhelper libcapture-tiny-perl libconfig-inifiles-perl pv lzop mbuffer failed'; exit 1; }" || exit 1

chroot $TEMPMOUNT /bin/bash -c "cd /tmp && git clone https://github.com/jimsalterjrs/sanoid.git"

chroot $TEMPMOUNT /bin/bash -c "cd /tmp/sanoid && git checkout $(git tag | grep '^v' | tail -n 1) && ln -s packages/debian . && dpkg-buildpackage -uc -us && echo '---> sanoid build succeeded <--------------------------------------------------------------' || { echo 'sanoid build failed'; exit 1; }" || exit 1

chroot $TEMPMOUNT /bin/bash -c "apt install -y /tmp/sanoid_*_all.deb && echo '---> apt install /tmp/sanoid_*_all.deb succeeded <--------------------------------------------------------------' || { echo 'apt install /tmp/sanoid_*_all.deb failed'; exit 1; }" || exit 1

chroot $TEMPMOUNT /bin/bash -c "systemctl enable sanoid.timer"

fi
