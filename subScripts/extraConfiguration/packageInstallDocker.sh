#!/bin/bash


chroot $TEMPMOUNT /bin/bash -c "apt-get install -y docker.io docker-compose && echo '---> apt install docker.io docker-compose succeeded <--------------------------------------------------------------' || { echo 'apt install docker.io docker-compose failed'; exit 1; }" || exit 1
