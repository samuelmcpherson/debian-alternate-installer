#!/bin/bash

chroot $TEMPMOUNT /bin/bash -c "apt-get update"

chroot $TEMPMOUNT /bin/bash -c "apt-get -y install xinput wireless-tools x11-apps x11-session-utils notification-daemon mesa-utils alsa-utils avahi-autoipd hspell-gui hspell hunspell hyphen-en-us i2c-tools uim-data uim-fep uim-gtk2.0-immodule uim-gtk2.0 uim-gtk3-immodule uim-gtk3 uim-plugins uim-qt5-immodule uim-qt5 uim-xim uim ubertooth-firmware-source bertooth-firmware ubertooth uim-data task-english"


chroot $TEMPMOUNT /bin/bash -c "apt-get -y install xinput thermald xcape gnome-keyring flatpak xfsprogs wireshark-doc thunderbird libreoffice hunspell conky-all vlc openshot-qt gimp inkscape libudev-dev xdotool libinput-tools libinput-dev calibre audacity gparted pass wireshark profile-sync-daemon pandoc && echo '---> apt install xinput thermald xcape gnome-keyring flatpak xfsprogs wireshark-doc firefox-esr thunderbird libreoffice hunspell conky-all vlc openshot-qt gimp inkscape libudev-dev xdotool libinput-tools libinput-dev calibre audacity gparted pass wireshark profile-sync-daemon succeeded <--------------------------------------------------------------' || { echo 'apt install xinput thermald xcape gnome-keyring flatpak xfsprogs wireshark-doc firefox-esr thunderbird libreoffice hunspell conky-all vlc openshot-qt gimp inkscape libudev-dev xdotool libinput-tools libinput-dev calibre audacity gparted pass wireshark profile-sync-daemon failed'; exit 1; }" || exit 1

chroot $TEMPMOUNT /bin/bash -c "apt-get install -y texlive-base texlive-latex-base texlive-latex-extra texlive-latex-extra-doc texlive-latex-base-doc texlive-fonts-extra texlive-bibtex-extra && echo '---> apt install texlive-base texlive-latex-base texlive-latex-extra texlive-latex-extra-doc texlive-latex-base-doc texlive-fonts-extra texlive-bibtex-extra succeeded <--------------------------------------------------------------' || echo '---> apt install texlive-base texlive-latex-base texlive-latex-extra texlive-latex-extra-doc texlive-latex-base-doc texlive-fonts-extra texlive-bibtex-extra failed <--------------------------------------------------------------'"

{
    
    echo '#!/bin/bash'

    echo 'apt-get install -y midisport-firmware'
    echo 'apt-get install -y gnome-firmware'
    echo 'apt-get install -y hdmi2usb-fx2-firmware'
    echo 'apt-get install -y dns323-firmware-tools'
    echo 'apt-get install -y atmel-firmware'
    echo 'apt-get install -y firmware-amd-graphics'
    echo 'apt-get install -y firmware-ath9k-htc'
    echo 'apt-get install -y firmware-atheros'
    echo 'apt-get install -y firmware-bnx2'
    echo 'apt-get install -y firmware-bnx2x'
    echo 'apt-get install -y firmware-brcm80211'
    echo 'apt-get install -y firmware-cavium'
    echo 'apt-get install -y firmware-intel-sound'
    echo 'apt-get install -y firmware-intelwimax'
    echo 'apt-get install -y firmware-ipw2x00'
    echo 'apt-get install -y firmware-ivtv'
    echo 'apt-get install -y firmware-iwlwifi'
    echo 'apt-get install -y firmware-libertas'
    echo 'apt-get install -y firmware-linux-free'
    echo 'apt-get install -y firmware-linux-nonfree'
    echo 'apt-get install -y firmware-linux'
    echo 'apt-get install -y firmware-misc-nonfree'
    echo 'apt-get install -y firmware-myricom'
    echo 'apt-get install -y firmware-netronome'
    echo 'apt-get install -y firmware-netxen'
    echo 'apt-get install -y firmware-qlogic'
    echo 'apt-get install -y firmware-realtek'
    echo 'apt-get install -y firmware-samsung'
    echo 'apt-get install -y firmware-siano'
    echo 'apt-get install -y firmware-zd1211'
    echo 'apt-get install -y bluez-firmware'

    echo 'update-initramfs -c -k all'

} >> $TEMPMOUNT/home/$USER/firmwareToInstall.sh


{
    
    echo '#!/bin/bash'

    echo 'flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo'
    echo 'flatpak install -y flathub app/com.github.eloston.ungoogledchromium/x86_64/stable'
    echo 'flatpak install -y flathub org.mozilla.firefox/x86_64/stable'
    echo 'flatpak install -y flathub com.todoist.todoist'
    echo 'flatpak install -y flathub com.vscodium.codium'
    echo 'flatpak install -y flathub com.slack.slack'
    echo 'flatpak install -y flathub ch.protonmail.protonmail-bridge'
    echo 'flatpak install -y flathub com.jgraph.drawio.desktop'
    echo 'flatpak install -y flathub com.discordapp.discord'
    echo 'flatpak install -y flathub com.github.xournalpp.xournalpp'
    echo 'flatpak install -y flathub us.zoom.zoom'
    echo 'flatpak install -y flathub tech.feliciano.pocket-casts'
    echo 'flatpak install -y flathub com.axosoft.gitkraken'

} >> $TEMPMOUNT/home/$USER/flatpaksToInstall.sh


# old-non-repo-apps

#chroot $TEMPMOUNT /bin/bash -c "cd /tmp && wget https://download.teamviewer.com/download/linux/signature/TeamViewer2017.asc"
#chroot $TEMPMOUNT /bin/bash -c "cd /tmp && apt-key add TeamViewer2017.asc"
#chroot $TEMPMOUNT /bin/bash -c "echo 'deb http://linux.teamviewer.com/deb stable main' >> /etc/apt/sources.list.d/teamviewer.list"

#chroot $TEMPMOUNT /bin/bash -c 'echo -en "\n" | apt install -y teamviewer && echo "---> apt install teamviewer succeeded <--------------------------------------------------------------" || echo "---> apt install teamviewer failed <--------------------------------------------------------------"'


#chroot $TEMPMOUNT /bin/bash -c "cd /tmp && wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb"



#chroot $TEMPMOUNT /bin/bash -c "wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | gpg --dearmor | sudo dd of=/etc/apt/trusted.gpg.d/vscodium.gpg"

#chroot $TEMPMOUNT /bin/bash -c "echo 'deb https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs/ vscodium main' >> /etc/apt/sources.list.d/vscodium.list"



#chroot $TEMPMOUNT /bin/bash -c "wget -qO - https://protonmail.com/download/bridge_pubkey.gpg | gpg --dearmor | sudo dd of=/etc/apt/trusted.gpg.d/bridge_pubkey.gpg"

#chroot $TEMPMOUNT /bin/bash -c "cd /tmp && wget -O protonmail-bridge.deb 'https://protonmail.com/download/bridge/protonmail-bridge_1.8.9-1_amd64.deb'"



#chroot $TEMPMOUNT /bin/bash -c "cd /tmp && wget -O discord.deb 'https://discordapp.com/api/download?platform=linux&format=deb'"



#chroot $TEMPMOUNT /bin/bash -c "cd /tmp && wget -O slack-desktop.deb https://downloads.slack-edge.com/linux_releases/slack-desktop-4.13.0-amd64.deb"



#chroot $TEMPMOUNT /bin/bash -c "cd /tmp && wget https://zoom.us/client/latest/zoom_amd64.deb"



#chroot $TEMPMOUNT /bin/bash -c "cd /tmp && wget https://github.com/jgraph/drawio-desktop/releases/download/v15.4.0/drawio-amd64-15.4.0.deb"

#chroot $TEMPMOUNT /bin/bash -c "cd /tmp && wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"



#chroot $TEMPMOUNT /bin/bash -c "cd /tmp && wget https://github.com/xournalpp/xournalpp/releases/download/1.1.0/xournalpp-1.1.0-Debian-buster-x86_64.deb"

#chroot $TEMPMOUNT /bin/bash -c "apt update"


#chroot $TEMPMOUNT /bin/bash -c "apt install -y /tmp/teamviewer_amd64.deb"


#chroot $TEMPMOUNT /bin/bash -c "apt install -y codium && echo '---> apt install codium succeeded <--------------------------------------------------------------' || echo '---> apt install codium failed <--------------------------------------------------------------'" 

#chroot $TEMPMOUNT /bin/bash -c "apt install -y /tmp/protonmail-bridge.deb && echo '---> apt install /tmp/protonmail-bridge.deb succeeded <--------------------------------------------------------------' || echo '---> apt install /tmp/protonmail-bridge.deb failed <--------------------------------------------------------------'"

#chroot $TEMPMOUNT /bin/bash -c "apt install -y /tmp/discord.deb && echo '---> apt install /tmp/discord.deb succeeded <--------------------------------------------------------------' || echo '---> apt install /tmp/discord.deb failed <--------------------------------------------------------------'"

#chroot $TEMPMOUNT /bin/bash -c "apt install -y /tmp/slack-desktop.deb && echo '---> apt install /tmp/slack-desktop.deb succeeded <--------------------------------------------------------------' || echo '---> apt install /tmp/slack-desktop.deb failed <--------------------------------------------------------------'"

#chroot $TEMPMOUNT /bin/bash -c "apt install -y /tmp/zoom_amd64.deb && echo '---> apt install zoom_amd64.deb succeeded <--------------------------------------------------------------' || echo '---> apt install zoom_amd64.deb failed <--------------------------------------------------------------'"

#chroot $TEMPMOUNT /bin/bash -c "apt install -y /tmp/draw.io-amd64-* && echo '---> apt install /tmp/draw.io-amd64-* succeeded <--------------------------------------------------------------' || echo '---> apt install /tmp/draw.io-amd64-* failed <--------------------------------------------------------------'"

#chroot $TEMPMOUNT /bin/bash -c "apt install -y /tmp/xournalpp-* && echo '---> apt install /tmp/xournalpp-* succeeded <--------------------------------------------------------------' || echo '---> apt install /tmp/xournalpp-* failed <--------------------------------------------------------------'"

#chroot $TEMPMOUNT /bin/bash -c "apt install -y /tmp/google-chrome-stable_current_amd64.deb && echo '---> apt install /tmp/google-chrome-stable_current_amd64.deb succeeded <--------------------------------------------------------------' || echo '---> apt install /tmp/google-chrome-stable_current_amd64.deb failed <--------------------------------------------------------------'"
