#!/bin/bash

chroot $TEMPMOUNT /bin/bash -c "dpkg --add-architecture i386"
chroot $TEMPMOUNT /bin/bash -c "wget -O - https://dl.winehq.org/wine-builds/winehq.key | apt-key add -"
echo "deb https://dl.winehq.org/wine-builds/ubuntu/ $RELEASE main" > $TEMPMOUNT/etc/apt/sources.list.d/winehq.list

chroot $TEMPMOUNT /bin/bash -c "add-apt-repository -y ppa:lutris-team/lutris"

chroot $TEMPMOUNT /bin/bash -c "apt update && apt -y dist-upgrade"

chroot $TEMPMOUNT /bin/bash -c "apt install -y vulkan-tools libvulkan1 libvulkan1:i386 mesa-vulkan-drivers mesa-vulkan-drivers:i386 && echo '---> apt install vulkan-tools libvulkan1 libvulkan1:i386 mesa-vulkan-drivers mesa-vulkan-drivers:i386 succeeded <--------------------------------------------------------------' || { echo 'apt install vulkan-tools libvulkan1 libvulkan1:i386 mesa-vulkan-drivers mesa-vulkan-drivers:i386 failed'; exit 1; }" || exit 1

chroot $TEMPMOUNT /bin/bash -c "apt install -y winehq-staging lutris dxvk dxvk:i386 fonts-wine && echo '---> apt install winehq-staging lutris dxvk dxvk:i386 fonts-wine succeeded <--------------------------------------------------------------' || { echo 'apt install winehq-staging lutris dxvk dxvk:i386 fonts-wine failed'; exit 1; }" || exit 1 

chroot $TEMPMOUNT /bin/bash -c "apt install -y winetricks && echo '---> apt install winetricks succeeded <--------------------------------------------------------------' || { echo '---> apt install winetricks failed <-------------------------------------------'; exit 1; }"

if [ -n "$KDE" ] 
then
    chroot $TEMPMOUNT /bin/bash -c "apt install -y kajongg kmahjongg kalarm kapman kblocks kbreakout kspaceduel ksnakeduel kmines && echo '---> apt install kubuntu-desktop yakuake succeeded <--------------------------------------------------------------' || { echo '---> apt install kubuntu-desktop yakuake failed <--------------------------------------------------------------'; exit 1; }"

fi

chroot $TEMPMOUNT /bin/bash -c "apt install -y cmatrix sl nethack-common dwarf-fortress cowsay lolcat fortune-mod asciiart wesnoth && echo '---> apt install kubuntu-desktop yakuake succeeded <--------------------------------------------------------------' || { echo '---> apt install kubuntu-desktop yakuake failed <--------------------------------------------------------------'; exit 1; }"

# zork1 zork2 zork3 
