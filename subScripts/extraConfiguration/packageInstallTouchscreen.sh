chroot $TEMPMOUNT /bin/bash -c "apt install -y libqt5virtualkeyboard5 onboard iio-sensor-proxy && echo '---> apt install libqt5virtualkeyboard5 onboard iio-sensor-proxy succeeded <--------------------------------------------------------------' || echo '---> apt install libqt5virtualkeyboard5 onboard iio-sensor-proxy failed <--------------------------------------------------------------'" 

chroot $TEMPMOUNT /bin/bash -c "echo 'MOZ_USE_XINPUT2=1' >> /etc/environment"

cp $WORKDIR/$FILEREPO/surface/30-touchpad.conf $TEMPMOUNT/etc/X11/xorg.conf.d/