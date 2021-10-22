#!/bin/bash

### imutable variables

export SCRIPTDIR=$(pwd)

export EFI=yes

export MANUAL_LAYOUT=

export ZFS=yes

export MIRROR=mirror

export ZFSPART= 

export EFIPART=

export DISK1=/dev/disk/by-id/

export DISK2=/dev/disk/by-id/

export TEMPMOUNT=/mnt

export LOGDIR="/logs/$HOSTNAME"

export OUTPUTLOG="$LOGDIR/$HOSTNAME-$(date -I)"

export CONFIGREPO="https://github.com/samuelmcpherson/config-files.git"
# This variable is used for bringing in configuration files present in a separate repository, this will be cloned in the configured user's home directory

export CONFIGDIR="$TEMPMOUNT/home/$USER/$(echo $CONFIGREPO | cut -d '/' -f5 | sed -r 's/.{4}$//')"

export DEBIAN_FRONTEND=noninteractive

### Required vars:

export HOSTNAME=thinkpad-t430-debian

export TIMEOUT=20 # number of seconds before selecting the default menu option

export DOMAIN=housenet.lan

export NETDEVICE=enp0s25

    export DHCP=yes

    export STATIC=

    export IP=

    export NETMASK=24

    export GATEWAY=192.168.10.1

export RELEASE=bookworm # groovy, focal or hirsute

export LANG=en_US.UTF-8

export TIMEZONE=America/Los_Angeles

# extra variables to futher customize the install after a minimal base is in place

export CONFIGREPO="https://github.com/samuelmcpherson/config-files.git"
# This variable is used for bringing in configuration files present in a separate repository, this will be cloned in the configured user's home directory

export CONFIGDIR="$TEMPMOUNT/home/$USER/$(echo $CONFIGREPO | cut -d '/' -f5 | sed -r 's/.{4}$//')"

export ANSIBLE=

export HIDPI=

export USERSHELL=/bin/zsh

export ROOTSHELL=/bin/bash

export DESKTOP=

