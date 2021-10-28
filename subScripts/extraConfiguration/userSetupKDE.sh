#!/bin/bash

mkdir -p $TEMPMOUNT/home/$USER/.local

mkdir -p $TEMPMOUNT/home/$USER/.config

mkdir -p $TEMPMOUNT/home/$USER/.kde

if [ -n "$HIDPI" ]
then
    cp -r $CONFIGDIR/home/hidpi/kde/.local/* $TEMPMOUNT/home/$USER/.local/
    cp -r $CONFIGDIR/home/hidpi/kde/.config/* $TEMPMOUNT/home/$USER/.config/
    cp -r $CONFIGDIR/home/hidpi/kde/.kde/* $TEMPMOUNT/home/$USER/.kde/
else
    cp -r $CONFIGDIR/home/kde/.local/* $TEMPMOUNT/home/$USER/.local/
    cp -r $CONFIGDIR/home/kde/.config/* $TEMPMOUNT/home/$USER/.config/
    cp -r $CONFIGDIR/home/kde/.kde/* $TEMPMOUNT/home/$USER/.kde/
fi

cp $CONFIGDIR/wallpaper/* $TEMPMOUNT/usr/share/wallpapers/


if [[ -n "$PARACHUTE" ]]
then

#    cp -r $CONFIGDIR/home/kwin-scripts/Parachute $TEMPMOUNT/home/$USER/.local/share/kwin/scripts/

    cp -r $CONFIGDIR/home/kwin-scripts/toggleparachute $TEMPMOUNT/home/$USER/.local/share/kwin/scripts/

    {
    echo 'ParachuteEnabled=true' 
    echo 'toggleparachuteEnabled=true' 
    } >> $TEMPMOUNT/home/$USER/.config/kwinrc

fi

if [[ -n "$BISMUTH" ]]
then

#    cp -r $CONFIGDIR/home/kwin-scripts/bismuth $TEMPMOUNT/home/$USER/.local/share/kwin/scripts/

    echo 'bismuthEnabled=true' >> $TEMPMOUNT/home/$USER/.config/kwinrc

fi

if [[ -n "$KROHNKITE" ]]
then

#    cp -r $CONFIGDIR/home/kwin-scripts/krohnkite $TEMPMOUNT/home/$USER/.local/share/kwin/scripts/

    echo 'krohnkiteEnabled=true' >> $TEMPMOUNT/home/$USER/.config/kwinrc

fi

chroot $TEMPMOUNT /bin/bash -c "chown -R $USER:users /home/$USER"

chroot $TEMPMOUNT su - $USER -c "mkdir -p ~/.local/share/kservices5/"

if [[ -n "$PARACHUTE" ]]
then
    
    {
    echo ''
    echo '[ModifierOnlyShortcuts]'
    echo 'Meta=org.kde.kglobalaccel,/component/kwin,org.kde.kglobalaccel.Component,invokeShortcut,Parachute'
    echo ''
    echo '[Script-Parachute]'
    echo 'blurBackground=false'
    echo 'showNotificationWindows=false'
    echo ''
    echo '[Script-toggleparachute]'
    echo 'BorderActivate=7'
    } >> $TEMPMOUNT/home/$USER/.config/kwinrc

    chroot $TEMPMOUNT su - $USER -c "cd /home/$USER && git clone https://github.com/tcorreabr/Parachute.git"

    sleep 2

    chroot $TEMPMOUNT su - $USER -c "cd /home/$USER/Parachute && make install"

    sleep 2

fi

if [[ -n "$BISMUTH" ]]
then

    {
    echo ''
    echo '[Script-bismuth]'
    echo 'enableQuarterLayout=true'
    echo 'enableSpreadLayout=false'
    echo 'enableStairLayout=false'
    echo 'enableTileLayout=false'
    echo 'ignoreClass=yakuake,spectacle,conky'
    echo 'newWindowAsMaster=true'
    } >> $TEMPMOUNT/home/$USER/.config/kwinrc

chroot $TEMPMOUNT /bin/bash -c "{

echo 'Downloading the latest Bismuth release...'

wget -q --output-document /tmp/bismuth.tar.gz https://github.com/gikari/bismuth/releases/latest/download/bismuth.tar.gz

echo 'Extracting...'
mkdir -p /tmp/bismuth
tar xf /tmp/bismuth.tar.gz --directory=/tmp/bismuth

chmod +x /tmp/bismuth/install.sh
/tmp/bismuth/install.sh
}"
    
    chroot $TEMPMOUNT su - $USER -c "ln -s ~/.local/share/kwin/scripts/bismuth/metadata.desktop ~/.local/share/kservices5/bismuth.desktop"

fi

if [[ -n "$KROHNKITE" ]]
then

    {
    echo ''
    echo '[Script-krohnkite]'
    echo 'directionalKeyDwm=false'
    echo 'directionalKeyFocus=true'
    echo 'enableQuarterLayout=true'
    echo 'enableSpreadLayout=false'
    echo 'enableStairLayout=false'
    echo 'enableTileLayout=false'
    echo 'ignoreClass=krunner,yakuake,spectacle,kded5,conky'
    echo 'ignoreScreen=\s\s'
    echo 'layoutPerActivity=false'
    echo 'newWindowAsMaster=true'
    } >> $TEMPMOUNT/home/$USER/.config/kwinrc

    chroot $TEMPMOUNT su - $USER -c "cd /home/$USER && git clone https://github.com/esjeon/krohnkite.git"

    sleep 2

    chroot $TEMPMOUNT su - $USER -c "cd /home/$USER/krohnkite && make install"

    sleep 2

    chroot $TEMPMOUNT su - $USER -c "ln -s ~/.local/share/kwin/scripts/krohnkite/metadata.desktop ~/.local/share/kservices5/krohnkite.desktop"

fi
