#!/bin/bash



debootstrap $RELEASE $TEMPMOUNT && echo "---> Successfully bootstrapped system at $TEMPMOUNT <--------------------------------------------------------------" || { echo "failed to bootstrap system at $TEMPMOUNT"; exit 1; }

if [[ -z "$DESKTOP" ]]
then 
    mkdir -p $TEMPMOUNT/etc/network/interfaces.d
    touch $TEMPMOUNT/etc/network/interfaces.d/$NETDEVICE
    {
    echo "auto $NETDEVICE"
    echo "iface $NETDEVICE inet dhcp"
    } > $TEMPMOUNT/etc/network/interfaces.d/$NETDEVICE
fi

cp /etc/hostid $TEMPMOUNT/etc/hostid
cp /etc/resolv.conf $TEMPMOUNT/etc/resolv.conf


mkdir -p $TEMPMOUNT/etc/apt/sources.list.d

{
    
echo "deb http://deb.debian.org/debian $RELEASE main contrib non-free" 
echo "deb-src http://deb.debian.org/debian $RELEASE main contrib non-free" 
echo "#deb http://security.debian.org/debian-security $RELEASE/updates main contrib non-free" 
echo "#deb-src http://security.debian.org/debian-security $RELEASE/updates main contrib non-free" 
echo "deb http://deb.debian.org/debian $RELEASE-updates main contrib non-free" 
echo "deb-src http://deb.debian.org/debian $RELEASE-updates main contrib non-free" 

} > $TEMPMOUNT/etc/apt/sources.list

echo "deb http://deb.debian.org/debian $RELEASE-backports main contrib non-free" > $TEMPMOUNT/etc/apt/sources.list.d/$RELEASE-backports.list
echo "deb-src http://deb.debian.org/debian $RELEASE-backports main contrib" >> $TEMPMOUNT/etc/apt/sources.list.d/$RELEASE-backports.list
