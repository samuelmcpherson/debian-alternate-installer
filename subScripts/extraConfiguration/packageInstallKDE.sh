#!/bin/bash

if [[ -n "$KDEREPO" ]]
then

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

chroot $TEMPMOUNT /bin/bash -c "touch /etc/apt/preferences.d/70_kde"

{
    
echo 'Package: *'
echo 'Pin: origin download.opensuse.org'
echo 'Pin-Priority: 700'

} > $TEMPMOUNT/etc/apt/preferences.d/70_kde

fi

chroot $TEMPMOUNT /bin/bash -c "apt-get update"

chroot $TEMPMOUNT /bin/bash -c "apt-get install -y kde-plasma-desktop network-manager plasma-nm plasma-workspace-wayland && echo '---> apt install kde-plasma-desktop network-manager plasma-nm plasma-workspace-wayland succeeded <--------------------------------------------------------------' || { echo 'apt install kde-plasma-desktop network-manager plasma-nm plasma-workspace-wayland failed'; exit 1; }" || exit 1


chroot $TEMPMOUNT /bin/bash -c "apt-get install -y accountwizard acpid akonadi-backend-mysql akonadi-server akregator debconf-kde-data debconf-kde-helper k3b-data k3b-i18n k3b kde-config-fcitx5 kde-config-fcitx kde-standard kdeaccessibility kdepim-addons kdepim-runtime kdepim-themeeditors keyutils kio-ldap klibc-utils kmag 
kmail kmailtransport-akonadi kmousetool kmouth knotes konq-plugins kontrast korganizer inentry-qt pkg-config plasma-integration plasma-runners-addons plasma-wallpapers-addons plasma-widgets-addons powermgmt-base powertop python3-pyatspi python3-pyside2.qtcore python3-pyside2.qtgui python3-pyside2.qtwidgets qtgstreamer-plugins-qt5"
  

chroot $TEMPMOUNT /bin/bash -c "apt-get install -y plasma-discover-backend-flatpak okular-extra-backends libreoffice-plasma ark gwenview plasma-runners-addons plasma-widgets-addons kcalc kmahjongg kmines plasma-integration krdc ksudoku kde-spectacle ksystemlog kate okular yakuake akregator marble kdenlive kigo kompare krfb ktimer kmousetool node-typescript npm && echo '---> apt install plasma-discover-backend-flatpak okular-extra-backends libreoffice-plasma ark gwenview plasma-runners-addons plasma-widgets-addons kcalc kmahjongg kmines plasma-integration krdc ksudoku kde-spectacle ksystemlog kate okular yakuake akregator marble kdenlive kigo kompare korganizer krfb ktimer kmousetool node-typescript npm succeeded <--------------------------------------------------------------' || { echo 'apt install plasma-discover-backend-flatpak okular-extra-backends libreoffice-plasma ark gwenview plasma-runners-addons plasma-widgets-addons kcalc kmahjongg kmines plasma-integration krdc ksudoku kde-spectacle ksystemlog kate okular yakuake akregator kalarm kapman kblocks kbreakout marble kdenlive kigo kompare korganizer krfb ktimer kmousetool node-typescript npm failed'; exit 1; }" || exit 1

