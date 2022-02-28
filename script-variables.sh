#!/bin/bash

export SCRIPTDIR=$(pwd)
# Sets a reusable variable with the location of the installation script, this is used to simpflify editing sub scripts during the installation process

export LOGDIR="/logs/$HOSTNAME"

export OUTPUTLOG="$LOGDIR/$HOSTNAME-$(date -I)"

export CONFIGREPO="https://github.com/samuelmcpherson/config-files.git"
# This variable is used for bringing in configuration files present in a separate repository, this will be cloned in the configured user's home directory

export CONFIGDIR="$TEMPMOUNT/home/$USER/$(echo $CONFIGREPO | cut -d '/' -f5 | sed -r 's/.{4}$//')"

export DEBIAN_FRONTEND=noninteractive
# Disables interactive prompts during package installation, this is required for the scripts to function

export TEMPMOUNT=/mnt
# Sets an alternate root mountpoint for the system to be installed, this is required

export TIMEOUT=20 
# Number of seconds before selecting the default menu option


#####################################################
### Storage configuration options:

export MANUAL_LAYOUT=
# Setting this option will skip all of the storage setup steps and assumes that you have manually setup the filesystems for the installation and that they are mounted at the $TEMPMOUNT location

export EFI=yes

export LEGACY=

export ZFS=yes

    export USE_FULL_DISK=

        export DISK1=

        export DISK2=

        export MIRROR=

    export USE_EXISTING_PARTITIONS=

        export ZFSPART=

        export EFIPART=

#####################################################



export HOSTNAME=

export DOMAIN=

export RELEASE=bullseye

export LANG=en_US.UTF-8

export TIMEZONE=America/Los_Angeles



export NETDEVICE=

    export DHCP=yes

    export STATIC=

    export IP=

    export NETMASK=24

    export GATEWAY=



# extra variables to futher customize the install after a minimal base is in place

export ANSIBLE=

export HIDPI=

export USERSHELL=/bin/zsh

export ROOTSHELL=/bin/bash

export DESKTOP=

