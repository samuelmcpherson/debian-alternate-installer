#!/bin/bash

chroot $TEMPMOUNT /bin/bash -c "apt update"

chroot $TEMPMOUNT /bin/bash -c "apt-get install -y kde-plasma-desktop network-manager plasma-nm && echo '---> apt install kde-plasma-desktop succeeded <--------------------------------------------------------------' || { echo 'apt install kde-plasma-desktop failed'; exit 1; }" || exit 1

chroot $TEMPMOUNT /bin/bash -c "apt-get install -y plasma-discover-backend-flatpak okular-extra-backends plasma-pass libreoffice-plasma ark gwenview plasma-runners-addons plasma-widgets-addons kcalc kmahjongg kmines plasma-integration krdc ksudoku kde-spectacle ksystemlog kate okular yakuake akregator marble kdenlive kigo kompare krfb ktimer kmousetool node-typescript npm && echo '---> apt install plasma-discover-backend-flatpak okular-extra-backends plasma-pass libreoffice-plasma ark gwenview plasma-runners-addons plasma-widgets-addons kcalc kmahjongg kmines plasma-integration krdc ksudoku kde-spectacle ksystemlog kate okular yakuake akregator marble kdenlive kigo kompare korganizer krfb ktimer kmousetool node-typescript npm succeeded <--------------------------------------------------------------' || { echo 'apt install plasma-discover-backend-flatpak okular-extra-backends plasma-pass libreoffice-plasma ark gwenview plasma-runners-addons plasma-widgets-addons kcalc kmahjongg kmines plasma-integration krdc ksudoku kde-spectacle ksystemlog kate okular yakuake akregator kalarm kapman kblocks kbreakout marble kdenlive kigo kompare korganizer krfb ktimer kmousetool node-typescript npm failed'; exit 1; }" || exit 1

