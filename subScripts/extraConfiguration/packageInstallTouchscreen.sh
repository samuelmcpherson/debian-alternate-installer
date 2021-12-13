chroot $TEMPMOUNT /bin/bash -c "apt-get install -y libqt5virtualkeyboard5 onboard iio-sensor-proxy && echo '---> apt install libqt5virtualkeyboard5 onboard iio-sensor-proxy succeeded <--------------------------------------------------------------' || echo '---> apt install libqt5virtualkeyboard5 onboard iio-sensor-proxy failed <--------------------------------------------------------------'" 

chroot $TEMPMOUNT /bin/bash -c "mkdir /etc/security"

chroot $TEMPMOUNT /bin/bash -c "echo 'MOZ_USE_XINPUT2 DEFAULT=1' >> /etc/security/pam_env.conf"

cp $CONFIGDIR/onboard_toggle.sh $TEMPMOUNT/usr/bin/onboard_toggle.sh

chroot $TEMPMOUNT /bin/bash -c "chmod +x /usr/bin/onboard_toggle.sh"

echo '{d1184627-6521-4558-85f9-480c6ad45fab}=Meta+Alt+Space,none,toggle_onboard' >> $TEMPMOUNT/home/$USER/.config/kglobalshortcutsrc

cp $CONFIGDIR/home/.config/autostart/onboard.desktop $TEMPMOUNT/home/$USER/.config/autostart/onboard.desktop

cp -r $CONFIGDIR/home/touchscreenextras-master $TEMPMOUNT/home/$USER/

cp -r $CONFIGDIR/home/touchscreenextras-master/.TouchscreenExtras.cfg $TEMPMOUNT/home/$USER/

cp $CONFIGDIR/home/.config/autostart/launch_touchScreenExtras.desktop $TEMPMOUNT/home/$USER/.config/autostart/launch_touchScreenExtras.desktop

chroot $TEMPMOUNT /bin/bash -c "chown -R $USER:users /home/$USER"
