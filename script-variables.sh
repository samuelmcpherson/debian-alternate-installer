#!/bin/bash

### Required variables

export SCRIPTDIR=$(pwd)

export TEMPMOUNT=/mnt



export EFI=yes

export MANUAL_LAYOUT=

export ZFS=yes

export MIRROR=

export ZFSPART=

export EFIPART=

export DISK1=

export DISK2=





export HOSTNAME=

export LOGDIR="/logs/$HOSTNAME"

export OUTPUTLOG="$LOGDIR/$HOSTNAME-$(date -I)"

export CONFIGREPO="https://github.com/samuelmcpherson/config-files.git"
# This variable is used for bringing in configuration files present in a separate repository, this will be cloned in the configured user's home directory

export CONFIGDIR="$TEMPMOUNT/home/$USER/$(echo $CONFIGREPO | cut -d '/' -f5 | sed -r 's/.{4}$//')"

export DEBIAN_FRONTEND=noninteractive

### Required vars:

export TIMEOUT=20 # number of seconds before selecting the default menu option

export DOMAIN=

export NETDEVICE=

    export DHCP=yes

    export STATIC=

    export IP=

    export NETMASK=24

    export GATEWAY=

export RELEASE=bullseye

export LANG=en_US.UTF-8

export TIMEZONE=America/Los_Angeles

# extra variables to futher customize the install after a minimal base is in place

export CONFIGREPO="https://github.com/samuelmcpherson/config-files.git"
# This variable is used for bringing in configuration files present in a separate repository, this will be cloned in the configured user's home directory

export CONFIGDIR="$TEMPMOUNT/home/$USER/$(echo $CONFIGREPO | cut -d '/' -f5 | sed -r 's/.{4}$//')"

export ANSIBLE=

export DOCKER=

export DESKTOP=

    export KDE=
        
        export KDEREPO=

        export PARACHUTE=

        export BISMUTH=

        export KROHNKITE=
    
    export GESTURES=

    export TOUCHSCREEN=

    export HIDPI=

    export THINKPAD=

        export THINKPADTRACKPOINT=

    export SURFACE=

    export MAC=

        export MACWIFIWL=

        export MACWIFIB43=

        export FNKEYMODESWAP=

        export ALTCMDKEYSWAP=

    export GAMES=

export USERSHELL=/bin/zsh

export ROOTSHELL=/bin/bash


