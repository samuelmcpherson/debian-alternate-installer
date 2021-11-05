#!/bin/bash

if [ "$RELEASE" == bullseye ]
then 
    DISTRIBUTION="Debian_11"

elif [ "$RELEASE" == bookworm ]
then 
    DISTRIBUTION="Debian_Testing"

elif [ "$RELEASE" == sid ]
then 
    DISTRIBUTION="Debian_Unstable"
else
    echo "No RELEASE variable set, how did you get here?"
fi

chroot $TEMPMOUNT /bin/bash -c "cd /tmp && wget https://www.preining.info/obs-npreining.asc"
chroot $TEMPMOUNT /bin/bash -c "cd /tmp && apt-key add obs-npreining.asc"

chroot $TEMPMOUNT /bin/bash -c "touch /etc/apt/sources.list.d/obs-npreining-kde.list"

{
    echo "deb https://download.opensuse.org/repositories/home:/npreining:/debian-kde:/other-deps/$DISTRIBUTION/ ./"
    
    echo "deb https://download.opensuse.org/repositories/home:/npreining:/debian-kde:/frameworks/$DISTRIBUTION/ ./"
    
    echo "deb https://download.opensuse.org/repositories/home:/npreining:/debian-kde:/plasma523/$DISTRIBUTION/ ./"

    echo "deb https://download.opensuse.org/repositories/home:/npreining:/debian-kde:/apps2108/$DISTRIBUTION/ ./"
    
    echo "deb https://download.opensuse.org/repositories/home:/npreining:/debian-kde:/other/$DISTRIBUTION/ ./"

} >> $TEMPMOUNT/etc/apt/sources.list.d/obs-npreining-kde.list

chroot $TEMPMOUNT /bin/bash -c "touch/etc/apt/preferences.d/70_kde"

{
    
echo 'Package: *'
echo 'Pin: origin download.opensuse.org'
echo 'Pin-Priority: 700'

} > $TEMPMOUNT/etc/apt/preferences.d/70_kde

chroot $TEMPMOUNT /bin/bash -c "apt update"

chroot $TEMPMOUNT /bin/bash -c "apt install -y kde-plasma-desktop network-manager plasma-nm plasma-workspace-wayland && echo '---> apt install kde-plasma-desktop network-manager plasma-nm plasma-workspace-wayland succeeded <--------------------------------------------------------------' || { echo 'apt install kde-plasma-desktop network-manager plasma-nm plasma-workspace-wayland failed'; exit 1; }" || exit 1

chroot $TEMPMOUNT /bin/bash -c "apt install -y plasma-discover-backend-flatpak okular-extra-backends libreoffice-plasma ark gwenview plasma-runners-addons plasma-widgets-addons kcalc kmahjongg kmines plasma-integration krdc ksudoku kde-spectacle ksystemlog kate okular yakuake akregator marble kdenlive kigo kompare krfb ktimer kmousetool node-typescript npm && echo '---> apt install plasma-discover-backend-flatpak okular-extra-backends libreoffice-plasma ark gwenview plasma-runners-addons plasma-widgets-addons kcalc kmahjongg kmines plasma-integration krdc ksudoku kde-spectacle ksystemlog kate okular yakuake akregator marble kdenlive kigo kompare korganizer krfb ktimer kmousetool node-typescript npm succeeded <--------------------------------------------------------------' || { echo 'apt install plasma-discover-backend-flatpak okular-extra-backends libreoffice-plasma ark gwenview plasma-runners-addons plasma-widgets-addons kcalc kmahjongg kmines plasma-integration krdc ksudoku kde-spectacle ksystemlog kate okular yakuake akregator kalarm kapman kblocks kbreakout marble kdenlive kigo kompare korganizer krfb ktimer kmousetool node-typescript npm failed'; exit 1; }" || exit 1

