#!/bin/bash

export USER=$1

export USERPASS=$2

export ROOTPASS=$3

logTrim()
{
sed -i '/\b\(^Get\|^Preparing\|^Setting\|^Unpacking\|^Selecting\|^Updating\|^Processing\)\b\|\(^I:\)/d' "$OUTPUTLOG-$(echo $CURRENTFUNC | cut -d '/' -f2)-log.txt"

sed -i '/Running in chroot/d' "$OUTPUTLOG-$(echo $CURRENTFUNC | cut -d '/' -f2)-log.txt"

sed -i '/(Reading database/d' "$OUTPUTLOG-$(echo $CURRENTFUNC | cut -d '/' -f2)-log.txt"

sed -i -e  '/^[[:blank:]]\+[[:digit:]]\+/d' "$OUTPUTLOG-$(echo $CURRENTFUNC | cut -d '/' -f2)-log.txt"
}

logExport()
{
echo "" >> "$OUTPUTLOG-log.txt"
cat "$OUTPUTLOG-$(echo $CURRENTFUNC | cut -d '/' -f2)-log.txt" >> "$OUTPUTLOG-log.txt"
echo "" >> "$OUTPUTLOG-log.txt"
cat "$OUTPUTLOG-$(echo $CURRENTFUNC | cut -d '/' -f2)-log.txt" >> "$OUTPUTLOG-log.txt"
}

menuStart()
{
RUNCOUNT=0    
while true
do    
n=
if (( RUNCOUNT < 1 ))
then 
DEFAULT=1
echo "Starting installation: $CURRENTFUNC $CURRENTARGS is the current function to run."
echo ""
elif (( RUNCOUNT >= 1 ))
then 
DEFAULT=4
else 
echo "Something weird happend with the functions RUNCOUNT that determines the correct default option to take when no user input is given. The timeout variable will be set to 10,000 seconds to avoid any issues that may result from this. This can be reversed by opening a shell to the live environment setting it to a new value with 'export TIMEOUT=#' with # being any number of seconds."
TIMEOUT=10000
fi

echo "select the operation ************"
echo ""
echo "  1)Run $CURRENTFUNC $CURRENTARGS"
echo "  2)Edit $CURRENTFUNC"
echo "  3)Open Shell to live environment"
echo "  4)Skip running $CURRENTFUNC $CURRENTARGS and continue to next function" 
echo "  5)Abort install"

read -rt $TIMEOUT n
if [ -z "$n" ]
then
    n=$DEFAULT
fi
case $n in
  1) "$SCRIPTDIR/subScripts/$CURRENTFUNC" "$CURRENTARGS" 2>&1 | tee -a "$OUTPUTLOG-$(echo $CURRENTFUNC | cut -d '/' -f2)-log.txt"; CURRENTFUNCSTATUS=${PIPESTATUS[0]}; logTrim ;;
  2) vim "$SCRIPTDIR/subScripts/$CURRENTFUNC" ;;
  3) /bin/bash ;;
  4) break ;;
  5) exit 1 ;;
  *) echo "invalid option";;
esac

echo ''

if [ $n = 1 ]
then
    if [ "$CURRENTFUNCSTATUS" == 1 ]
    then
        echo ""
        echo "$CURRENTFUNC $CURRENTARGS ran and FAILED"
        echo ""
    elif [ "$CURRENTFUNCSTATUS" == 0 ]
    then
        echo ""
        echo "$CURRENTFUNC $CURRENTARGS ran and SUCCEEDED"
        echo ""
        RUNCOUNT=$((RUNCOUNT + 1))
    fi
fi
done
}

menuPreSystem()
{
RUNCOUNT=0    
while true
do    
n=
if (( RUNCOUNT < 1 ))
then 
DEFAULT=1
echo "$LASTFUNC $LASTARGS was the previous function. $CURRENTFUNC $CURRENTARGS is the current function to run."
echo ""
elif (( RUNCOUNT >= 1 ))
then 
DEFAULT=4
else 
echo "Something weird happend with the functions RUNCOUNT that determines the correct default option to take when no user input is given. The timeout variable will be set to 10,000 seconds to avoid any issues that may result from this. This can be reversed by opening a shell to the live environment setting it to a new value with 'export TIMEOUT=#' with # being any number of seconds."
TIMEOUT=10000
fi

echo "select the operation ************"
echo ""
echo "  1)Run $CURRENTFUNC $CURRENTARGS"
echo "  2)Edit $CURRENTFUNC"
echo "  3)View logs from $CURRENTFUNC $CURRENTARGS"
echo "  4)View logs from $LASTFUNC $LASTARGS"
echo "  5)View full log"
echo "  6)Open Shell to live environment"
echo "  7)Skip running $CURRENTFUNC $CURRENTARGS and continue to next function" 
echo "  8)Go back to $LASTFUNC $LASTARGS"
echo "  9)Abort install"

read -rt $TIMEOUT n
if [ -z "$n" ]
then
    n=$DEFAULT
fi
case $n in
  1) "$SCRIPTDIR/subScripts/$CURRENTFUNC" "$CURRENTARGS" 2>&1 | tee -a "$OUTPUTLOG-$(echo $CURRENTFUNC | cut -d '/' -f2)-log.txt"; CURRENTFUNCSTATUS=${PIPESTATUS[0]}; logTrim ;;
  2) vim "$SCRIPTDIR/subScripts/$CURRENTFUNC" ;;
  3) less "$OUTPUTLOG-$(echo $CURRENTFUNC | cut -d '/' -f2)-log.txt" ;;
  4) less "$OUTPUTLOG-$(echo $LASTFUNC | cut -d '/' -f2)-log.txt" ;;
  5) less "$OUTPUTLOG-log.txt" ;;
  6) /bin/bash ;;
  7) break ;;
  8) NEXTFUNC=$CURRENTFUNC; NEXTARGS=$CURRENTARGS; CURRENTFUNC=$LASTFUNC; CURRENTARGS=$LASTARGS; menuPreSystemPrev ;;
  9) exit 1 ;;
  *) echo "invalid option";;
esac

echo ''

if [ $n = 1 ]
then
    if [ "$CURRENTFUNCSTATUS" == 1 ]
    then
        echo ""
        echo "$CURRENTFUNC $CURRENTARGS ran and FAILED"
        echo ""
        RUNCOUNT=0
    elif [ "$CURRENTFUNCSTATUS" == 0 ]
    then
        echo ""
        echo "$CURRENTFUNC $CURRENTARGS ran and SUCCEEDED"
        echo ""
        RUNCOUNT=$((RUNCOUNT + 1))
    fi
fi
done
}

menuPreSystemPrev()
{
RUNCOUNT=0    
while true
do    
n=
if (( RUNCOUNT < 1 ))
then 
DEFAULT=1
echo "$LASTFUNC $LASTARGS was the previous function. $CURRENTFUNC $CURRENTARGS is the current function to run."
echo ""
elif (( RUNCOUNT >= 1 ))
then 
DEFAULT=4
else 
echo "Something weird happend with the functions RUNCOUNT that determines the correct default option to take when no user input is given. The timeout variable will be set to 10,000 seconds to avoid any issues that may result from this. This can be reversed by opening a shell to the live environment setting it to a new value with 'export TIMEOUT=#' with # being any number of seconds."
TIMEOUT=10000
fi

echo "select the operation ************"
echo ""
echo "  1)Run $CURRENTFUNC $CURRENTARGS"
echo "  2)Edit $CURRENTFUNC"
echo "  3)View logs from $CURRENTFUNC $CURRENTARGS"
echo "  4)View logs from $LASTFUNC $LASTARGS"
echo "  5)View full log"
echo "  6)Open Shell to live environment"
echo "  7)Skip forward to $NEXTFUNC $NEXTARGS" 
echo "  8)Abort install"

read -rt $TIMEOUT n
if [ -z "$n" ]
then
    n=$DEFAULT
fi
case $n in
  1) "$SCRIPTDIR/subScripts/$CURRENTFUNC" "$CURRENTARGS" 2>&1 | tee -a "$OUTPUTLOG-$(echo $CURRENTFUNC | cut -d '/' -f2)-log.txt"; CURRENTFUNCSTATUS=${PIPESTATUS[0]}; logTrim ;;
  2) vim "$SCRIPTDIR/subScripts/$CURRENTFUNC" ;;
  3) less "$OUTPUTLOG-$(echo $CURRENTFUNC | cut -d '/' -f2)-log.txt" ;;
  4) less "$OUTPUTLOG-$(echo $LASTFUNC | cut -d '/' -f2)-log.txt" ;;
  5) less "$OUTPUTLOG-log.txt" ;;
  6) /bin/bash ;;
  7) LASTFUNC=$CURRENTFUNC; LASTARGS=$CURRENTARGS; CURRENTFUNC=$NEXTFUNC; CURRENTARGS=$NEXTARGS; break ;;
  8) exit 1 ;;
  *) echo "invalid option";;
esac

echo ''

if [ $n = 1 ]
then
    if [ "$CURRENTFUNCSTATUS" == 1 ]
    then
        echo ""
        echo "$CURRENTFUNC $CURRENTARGS ran and FAILED"
        echo ""
        RUNCOUNT=0
    elif [ "$CURRENTFUNCSTATUS" == 0 ]
    then
        echo ""
        echo "$CURRENTFUNC $CURRENTARGS ran and SUCCEEDED"
        echo ""
        RUNCOUNT=$((RUNCOUNT + 1))
    fi
fi
done
}

menuPreSystemPostZfs()
{
RUNCOUNT=0    
while true
do    
n=
if (( RUNCOUNT < 1 ))
then 
DEFAULT=1
echo "$LASTFUNC $LASTARGS was the previous function. $CURRENTFUNC $CURRENTARGS is the current function to run."
echo ""
elif (( RUNCOUNT >= 1 ))
then 
DEFAULT=5
else 
echo "Something weird happend with the functions RUNCOUNT that determines the correct default option to take when no user input is given. The timeout variable will be set to 10,000 seconds to avoid any issues that may result from this. This can be reversed by opening a shell to the live environment setting it to a new value with 'export TIMEOUT=#' with # being any number of seconds."
TIMEOUT=10000
fi

echo "select the operation ************"
echo ""
echo "  1)Run $CURRENTFUNC $CURRENTARGS"
echo "  2)Edit $CURRENTFUNC"
echo "  3)View logs from $CURRENTFUNC $CURRENTARGS"
echo "  4)View logs from $LASTFUNC $LASTARGS"
echo "  5)View full log"
echo "  6)**ONLY AVAILABLE FOR ZFS INSTALLS** Rollback system state to snapshot from before $CURRENTFUNC $CURRENTARGS was run"
echo "  7)Open Shell to live environment"
echo "  8)Skip running $CURRENTFUNC $CURRENTARGS and continue to next function" 
echo "  9)Go back to $LASTFUNC $LASTARGS"
echo "  10)Abort install"

read -rt $TIMEOUT n
if [ -z "$n" ]
then
    n=$DEFAULT
fi
case $n in
  1) "$SCRIPTDIR/subScripts/$CURRENTFUNC" "$CURRENTARGS" 2>&1 | tee -a "$OUTPUTLOG-$(echo $CURRENTFUNC | cut -d '/' -f2)-log.txt"; CURRENTFUNCSTATUS=${PIPESTATUS[0]}; logTrim ;;
  2) vim "$SCRIPTDIR/subScripts/$CURRENTFUNC" ;;
  3) less "$OUTPUTLOG-$(echo $CURRENTFUNC | cut -d '/' -f2)-log.txt" ;;
  4) less "$OUTPUTLOG-$(echo $LASTFUNC | cut -d '/' -f2)-log.txt" ;;
  5) less "$OUTPUTLOG-log.txt" ;;
  6) if [ -n "$ZFS" ]; then umount -Rl $TEMPMOUNT; $SCRIPTDIR/zfs-recursive-restore.sh zroot@"$(echo $CURRENTFUNC | cut -d '/' -f2)"; else echo "NOT A ZFS INSTALL"; fi ;;
  7) /bin/bash ;;
  8) break ;;
  9) NEXTFUNC=$CURRENTFUNC; NEXTARGS=$CURRENTARGS; CURRENTFUNC=$LASTFUNC; CURRENTARGS=$LASTARGS; menuPreSystemPostZfsPrev ;;
  10) exit 1 ;;
  *) echo "invalid option";;
esac

echo ''

if [ $n = 1 ]
then
    if [ "$CURRENTFUNCSTATUS" == 1 ]
    then
        echo ""
        echo "$CURRENTFUNC $CURRENTARGS ran and FAILED"
        echo ""
        RUNCOUNT=0
    elif [ "$CURRENTFUNCSTATUS" == 0 ]
    then
        echo ""
        echo "$CURRENTFUNC $CURRENTARGS ran and SUCCEEDED"
        echo ""
        RUNCOUNT=$((RUNCOUNT + 1))
    fi
fi
done
}

menuPreSystemPostZfsPrev()
{
RUNCOUNT=0    
while true
do    
n=
if (( RUNCOUNT < 1 ))
then 
DEFAULT=1
echo "$LASTFUNC $LASTARGS was the previous function. $CURRENTFUNC $CURRENTARGS is the current function to run."
echo ""
elif (( RUNCOUNT >= 1 ))
then 
DEFAULT=5
else 
echo "Something weird happend with the functions RUNCOUNT that determines the correct default option to take when no user input is given. The timeout variable will be set to 10,000 seconds to avoid any issues that may result from this. This can be reversed by opening a shell to the live environment setting it to a new value with 'export TIMEOUT=#' with # being any number of seconds."
TIMEOUT=10000
fi

echo "select the operation ************"
echo ""
echo "  1)Run $CURRENTFUNC $CURRENTARGS"
echo "  2)Edit $CURRENTFUNC $CURRENTARGS"
echo "  3)View logs from $CURRENTFUNC $CURRENTARGS"
echo "  4)View logs from $LASTFUNC $LASTARGS"
echo "  5)View full log"
echo "  6)**ONLY AVAILABLE FOR ZFS INSTALLS** Rollback system state to snapshot from before $CURRENTFUNC $CURRENTARGS was run"
echo "  7)Open Shell to live environment"
echo "  8)Skip forward to $NEXTFUNC $NEXTARGS" 
echo "  9)Abort install"

read -rt $TIMEOUT n
if [ -z "$n" ]
then
    n=$DEFAULT
fi
case $n in
  1) "$SCRIPTDIR/subScripts/$CURRENTFUNC" "$CURRENTARGS" 2>&1 | tee -a "$OUTPUTLOG-$(echo $CURRENTFUNC | cut -d '/' -f2)-log.txt"; CURRENTFUNCSTATUS=${PIPESTATUS[0]}; logTrim ;;
  2) vim "$SCRIPTDIR/subScripts/$CURRENTFUNC" ;;
  3) less "$OUTPUTLOG-$(echo $CURRENTFUNC | cut -d '/' -f2)-log.txt" ;;
  4) less "$OUTPUTLOG-$(echo $LASTFUNC | cut -d '/' -f2)-log.txt" ;;
  5) less "$OUTPUTLOG-log.txt" ;;
  6) if [ -n "$ZFS" ]; then umount -Rl $TEMPMOUNT; $SCRIPTDIR/zfs-recursive-restore.sh zroot@"$(echo $CURRENTFUNC | cut -d '/' -f2)"; else echo "NOT A ZFS INSTALL"; fi ;;
  7) /bin/bash ;;
  8) LASTFUNC=$CURRENTFUNC; LASTARGS=$CURRENTARGS; CURRENTFUNC=$NEXTFUNC; CURRENTARGS=$NEXTARGS; break ;;
  9) exit 1 ;;
  *) echo "invalid option";;
esac

echo ''

if [ $n = 1 ]
then
    if [ "$CURRENTFUNCSTATUS" == 1 ]
    then
        echo ""
        echo "$CURRENTFUNC $CURRENTARGS ran and FAILED"
        echo ""
        RUNCOUNT=0
    elif [ "$CURRENTFUNCSTATUS" == 0 ]
    then
        echo ""
        echo "$CURRENTFUNC $CURRENTARGS ran and SUCCEEDED"
        echo ""
        RUNCOUNT=$((RUNCOUNT + 1))
    fi
fi
done
}

menuFull()
{
RUNCOUNT=0    
while true
do    
n=
if (( RUNCOUNT < 1 ))
then 
DEFAULT=1
echo "$LASTFUNC $LASTARGS was the previous function. $CURRENTFUNC $CURRENTARGS is the current function to run."
echo ""
elif (( RUNCOUNT >= 1 ))
then 
DEFAULT=6
else 
echo "Something weird happend with the functions RUNCOUNT that determines the correct default option to take when no user input is given. The timeout variable will be set to 10,000 seconds to avoid any issues that may result from this. This can be reversed by opening a shell to the live environment setting it to a new value with 'export TIMEOUT=#' with # being any number of seconds."
TIMEOUT=10000
fi

echo "select the operation ************"
echo ""
echo "  1)Run $CURRENTFUNC $CURRENTARGS"
echo "  2)Edit $CURRENTFUNC $CURRENTARGS"
echo "  3)View logs from $CURRENTFUNC $CURRENTARGS"
echo "  4)View logs from $LASTFUNC $LASTARGS"
echo "  5)View full log"
echo "  6)**ONLY AVAILABLE FOR ZFS INSTALLS** Rollback system state to snapshot from before $CURRENTFUNC $CURRENTARGS was run"
echo "  7)Open Shell to live environment"
echo "  8)Open chroot to current install"
echo "  9)Skip running $CURRENTFUNC $CURRENTARGS and continue to next function" 
echo "  10)Go back to $LASTFUNC $LASTARGS"
echo "  11)Abort install"

read -rt $TIMEOUT n
if [ -z "$n" ]
then
    n=$DEFAULT
fi
case $n in
  1) "$SCRIPTDIR/subScripts/$CURRENTFUNC" "$CURRENTARGS" 2>&1 | tee -a "$OUTPUTLOG-$(echo $CURRENTFUNC | cut -d '/' -f2)-log.txt"; CURRENTFUNCSTATUS=${PIPESTATUS[0]}; logTrim ;;
  2) vim "$SCRIPTDIR/subScripts/$CURRENTFUNC" ;;
  3) less "$OUTPUTLOG-$(echo $CURRENTFUNC | cut -d '/' -f2)-log.txt" ;;
  4) less "$OUTPUTLOG-$(echo $LASTFUNC | cut -d '/' -f2)-log.txt" ;;
  5) less "$OUTPUTLOG-log.txt" ;;
  6) if [ -n "$ZFS" ]; then umount -Rl $TEMPMOUNT; $SCRIPTDIR/zfs-recursive-restore.sh zroot@"$(echo $CURRENTFUNC | cut -d '/' -f2)"; else echo "NOT A ZFS INSTALL"; fi ;;
  7) /bin/bash ;;
  8) chroot $TEMPMOUNT /bin/bash ;;
  9) break ;;
  10) NEXTFUNC=$CURRENTFUNC; NEXTARGS=$CURRENTARGS; CURRENTFUNC=$LASTFUNC; CURRENTARGS=$LASTARGS; menuFullPrev ;;
  11) exit 1 ;;
esac

echo ''

if [ $n = 1 ]
then
    if [ "$CURRENTFUNCSTATUS" == 1 ]
    then
        echo ""
        echo "$CURRENTFUNC $CURRENTARGS ran and FAILED"
        echo ""
        RUNCOUNT=0
    elif [ "$CURRENTFUNCSTATUS" == 0 ]
    then
        echo ""
        echo "$CURRENTFUNC $CURRENTARGS ran and SUCCEEDED"
        echo ""
        RUNCOUNT=$((RUNCOUNT + 1))
    fi
fi
done
}

menuFullPrev()
{
RUNCOUNT=0    
while true
do    
n=
if (( RUNCOUNT < 1 ))
then 
DEFAULT=1
echo "$LASTFUNC $LASTARGS was the previous function. $CURRENTFUNC $CURRENTARGS is the current function to run."
elif (( RUNCOUNT >= 1 ))
then 
DEFAULT=6
else 
echo "Something weird happend with the functions RUNCOUNT that determines the correct default option to take when no user input is given. The timeout variable will be set to 10,000 seconds to avoid any issues that may result from this. This can be reversed by opening a shell to the live environment setting it to a new value with 'export TIMEOUT=#' with # being any number of seconds."
TIMEOUT=10000
fi

echo "select the operation ************"
echo ""
echo "  1)Run $CURRENTFUNC $CURRENTARGS"
echo "  2)Edit $CURRENTFUNC $CURRENTARGS"
echo "  3)View logs from $CURRENTFUNC $CURRENTARGS"
echo "  4)View logs from $LASTFUNC $LASTARGS"
echo "  5)View full log"
echo "  6)**ONLY AVAILABLE FOR ZFS INSTALLS** Rollback system state to snapshot from before $CURRENTFUNC $CURRENTARGS was run"
echo "  7)Open Shell to live environment"
echo "  8)Open chroot to current install"
echo "  9)Skip forward to $NEXTFUNC $NEXTARGS" 
echo "  10)Abort install"

read -rt $TIMEOUT n
if [ -z "$n" ]
then
    n=$DEFAULT
fi
case $n in
  1) "$SCRIPTDIR/subScripts/$CURRENTFUNC" "$CURRENTARGS" 2>&1 | tee -a "$OUTPUTLOG-$(echo $CURRENTFUNC | cut -d '/' -f2)-log.txt"; CURRENTFUNCSTATUS=${PIPESTATUS[0]}; logTrim ;;
  2) vim "$SCRIPTDIR/subScripts/$CURRENTFUNC" ;"$(echo $CURRENTFUNC | cut -d '/' -f2)";
  3) less "$OUTPUTLOG-$(echo $CURRENTFUNC | cut -d '/' -f2)-log.txt" ;;
  4) less "$OUTPUTLOG-$(echo $LASTFUNC | cut -d '/' -f2)-log.txt" ;;
  5) less "$OUTPUTLOG-log.txt" ;;  
  6) if [ -n "$ZFS" ]; then umount -Rl $TEMPMOUNT; $SCRIPTDIR/zfs-recursive-restore.sh zroot@"$(echo $CURRENTFUNC | cut -d '/' -f2)"; else echo "NOT A ZFS INSTALL"; fi ;;
  7) /bin/bash ;;
  8) chroot $TEMPMOUNT /bin/bash ;;
  9) LASTFUNC=$CURRENTFUNC; LASTARGS=$CURRENTARGS; CURRENTFUNC=$NEXTFUNC; CURRENTARGS=$NEXTARGS; break ;;
  10) exit 1 ;;
esac

echo ''

if [ $n = 1 ]
then
    if [ "$CURRENTFUNCSTATUS" == 1 ]
    then
        echo ""
        echo "$CURRENTFUNC $CURRENTARGS ran and FAILED"
        echo ""
        RUNCOUNT=0
    elif [ "$CURRENTFUNCSTATUS" == 0 ]
    then
        echo ""
        echo "$CURRENTFUNC $CURRENTARGS ran and SUCCEEDED"
        echo ""
        RUNCOUNT=$((RUNCOUNT + 1))
    fi
fi
done
}

# environment prep

source ./script-variables.sh

mkdir -p $LOGDIR

{
echo "deb http://deb.debian.org/debian $RELEASE main contrib non-free"
#echo "deb http://deb.debian.org/debian $RELEASE-backports main contrib non-free"
} > /etc/apt/sources.list

apt update

apt install -y efibootmgr dosfstools debootstrap gdisk dkms dpkg-dev linux-headers-$(uname -r)

apt install -y --no-install-recommends zfs-dkms

modprobe zfs

apt install -y zfsutils-linux

modprobe efivarfs

source ./script-variables.sh

echo "Start $(date +%Y-%m-%d_%H:%M)"

if [ -n "$MANUAL_LAYOUT" ]
then

    echo "Manual storage setup selected: skipping disk setup, system will be installed to $TEMPMOUNT"

elif [ -z "$MANUAL_LAYOUT" ] && [ -n "$ZFS" ] 
then

    if [ -z "$ZFSPART" ] && [ -n "$DISK1" ] && [ -n "$DISK2" ]
    then

        export CURRENTFUNC="baseSystem/diskFormat.sh"
        export CURRENTARGS=$DISK1
        echo "Beginning automanted ubuntu zfs on root install with $CURRENTFUNC $CURRENTARGS"
        menuStart
    
        export LASTFUNC=$CURRENTFUNC
        export LASTARGS=$CURRENTARGS


        export CURRENTFUNC="baseSystem/diskFormat.sh"
        export CURRENTARGS=$DISK2
	    menuPreSystem
    
        export LASTFUNC=$CURRENTFUNC
        export LASTARGS=$CURRENTARGS  


        export CURRENTFUNC="baseSystem/zpoolSetup.sh"

        if [ -n "$EFI" ] && [ -z "$BIOS" ]
        then

            export CURRENTARGS="$DISK1-part2 $DISK2-part2"
    
        elif [ -z "$EFI" ] && [ -n "$BIOS" ]
        then

            export CURRENTARGS="$DISK1-part1 $DISK2-part1"

        else
    
            echo "Variables for EFI or BIOS install are both unset, aborting..."
            exit 1

        fi

        menuPreSystem
    
        export LASTFUNC=$CURRENTFUNC
        export LASTARGS=$CURRENTARGS

        if [ -n "$EFI" ] && [ -z "$BIOS" ] 
        then
        
            export EFIPART="$DISK1-part1"
            export EFIPART_2="$DISK2-part1"

        fi

    elif [ -z "$ZFSPART" ] && [ -n "$DISK1" ] && [ -z "$DISK2" ]
    then

        export CURRENTFUNC="baseSystem/diskFormat.sh"
        export CURRENTARGS=$DISK1
        echo "Beginning automanted ubuntu zfs on root install with $CURRENTFUNC $CURRENTARGS"
        menuStart
    
        export LASTFUNC=$CURRENTFUNC
        export LASTARGS=$CURRENTARGS


        export CURRENTFUNC="baseSystem/zpoolSetup.sh"

        if [ -n "$EFI" ] && [ -z "$BIOS" ]
        then

            export CURRENTARGS="$DISK1-part2"
    
        elif [ -z "$EFI" ] && [ -n "$BIOS" ]
        then

            export CURRENTARGS="$DISK1-part1"

        else
    
            echo "Variables for EFI or BIOS install are both unset, aborting..."
            exit 1

        fi

        menuPreSystem
    
        export LASTFUNC=$CURRENTFUNC
        export LASTARGS=$CURRENTARGS

        if [ -n "$EFI" ] && [ -z "$BIOS" ] 
        then
            export EFIPART="$DISK1-part1"
        fi

    elif [ -n "$ZFSPART" ] && [ -z "$DISK1" ] && [ -z "$DISK2" ] 
    then

        export CURRENTFUNC="baseSystem/zpoolSetup.sh"
        export CURRENTARGS=$ZFSPART
        menuPreSystem
    
        export LASTFUNC=$CURRENTFUNC
        export LASTARGS=$CURRENTARGS
   


    else
	
        echo "Failed to setup disks correctly"
	    exit 1
    
    fi

fi

if [ -n "$ZFS" ]
then

export CURRENTFUNC="baseSystem/createZfsDatasets.sh"
export CURRENTARGS=
menuPreSystem

export LASTFUNC=$CURRENTFUNC
export LASTARGS=$CURRENTARGS

fi
# -------------------------------------- zfs rollback able at this point

export CURRENTFUNC="baseSystem/bootstrap.sh"
export CURRENTARGS=

if [ -n "$ZFS" ]
then
zfs snapshot -r zroot@"$(echo $CURRENTFUNC | cut -d '/' -f2)"
fi

menuPreSystemPostZfs

export LASTFUNC=$CURRENTFUNC
export LASTARGS=$CURRENTARGS




export CURRENTFUNC="baseSystem/systemMounts.sh"
export CURRENTARGS=

if [ -n "$ZFS" ]
then
zfs snapshot -r zroot@"$(echo $CURRENTFUNC | cut -d '/' -f2)"
fi

menuPreSystemPostZfs

export LASTFUNC=$CURRENTFUNC
export LASTARGS=$CURRENTARGS

# ----------------------------- chrootable from this point

export CURRENTFUNC="baseSystem/baseChrootConfig.sh"
export CURRENTARGS=

if [ -n "$ZFS" ]
then
zfs snapshot -r zroot@"$(echo $CURRENTFUNC | cut -d '/' -f2)"
fi

menuFull

export LASTFUNC=$CURRENTFUNC
export LASTARGS=$CURRENTARGS


export CURRENTFUNC="baseSystem/packageInstallBase.sh"
export CURRENTARGS=

if [ -n "$ZFS" ]
then
zfs snapshot -r zroot@"$(echo $CURRENTFUNC | cut -d '/' -f2)"
fi

menuFull

export LASTFUNC=$CURRENTFUNC
export LASTARGS=$CURRENTARGS


export CURRENTFUNC="baseSystem/systemConfigPostInstall.sh"
export CURRENTARGS=

if [ -n "$ZFS" ]
then
zfs snapshot -r zroot@"$(echo $CURRENTFUNC | cut -d '/' -f2)"
fi

menuFull

export LASTFUNC=$CURRENTFUNC
export LASTARGS=$CURRENTARGS


export CURRENTFUNC="baseSystem/userSetup.sh"
export CURRENTARGS=

if [ -n "$ZFS" ]
then
zfs snapshot -r zroot@"$(echo $CURRENTFUNC | cut -d '/' -f2)"
fi

menuFull

export LASTFUNC=$CURRENTFUNC
export LASTARGS=$CURRENTARGS


export CURRENTFUNC="baseSystem/bootSetup.sh"
export CURRENTARGS=

if [ -n "$ZFS" ]
then
zfs snapshot -r zroot@"$(echo $CURRENTFUNC | cut -d '/' -f2)"
fi

menuFull

export LASTFUNC=$CURRENTFUNC
export LASTARGS=$CURRENTARGS


if [ -n "$MIRROR" ] && [ -n "$EFI" ]
then

    export CURRENTFUNC="baseSystem/syncEFIs.sh"
    export CURRENTARGS=
    
    if [ -n "$ZFS" ]
    then
    zfs snapshot -r zroot@"$(echo $CURRENTFUNC | cut -d '/' -f2)"
    fi
    
    menuFull
    
    export LASTFUNC=$CURRENTFUNC
    export LASTARGS=$CURRENTARGS

fi

if [ -n "$ZFS" ]
    then
    zfs snapshot -r zroot@base-install
fi

echo '#########################################################################################'
echo '#########################################################################################'
echo 'Minimal base system has been successfully installed, now performing extra configurations'
echo '#########################################################################################'
echo '#########################################################################################'

#if [ -n "$ZFS" ]
#then

#   export CURRENTFUNC="extraConfiguration/createExtraZfsDatasets.sh"
#   export CURRENTARGS=


#    if [ -n "$ZFS" ]
#    then
#        zfs snapshot -r zroot@"$(echo $CURRENTFUNC | cut -d '/' -f2)"
#    fi

#    menuFull

#    export LASTFUNC=$CURRENTFUNC
#    export LASTARGS=$CURRENTARGS

#fi


export CURRENTFUNC="extraConfiguration/packageInstallUtilities.sh"
export CURRENTARGS=

if [ -n "$ZFS" ]
then
    zfs snapshot -r zroot@"$(echo $CURRENTFUNC | cut -d '/' -f2)"
fi

menuFull

export LASTFUNC=$CURRENTFUNC
export LASTARGS=$CURRENTARGS


export CURRENTFUNC="extraConfiguration/generalConfigurations.sh"
export CURRENTARGS=

if [ -n "$ZFS" ]
then
    zfs snapshot -r zroot@"$(echo $CURRENTFUNC | cut -d '/' -f2)"
fi

menuFull

export LASTFUNC=$CURRENTFUNC
export LASTARGS=$CURRENTARGS


if [ -n "$ANSIBLE" ]
then

    export CURRENTFUNC="extraConfiguration/packageInstallAnsible.sh"
    export CURRENTARGS=

    if [ -n "$ZFS" ]
    then
        zfs snapshot -r zroot@"$(echo $CURRENTFUNC | cut -d '/' -f2)"
    fi

    menuFull

    export LASTFUNC=$CURRENTFUNC
    export LASTARGS=$CURRENTARGS

fi


if [ -n "$DOCKER" ]
then
    export CURRENTFUNC="extraConfiguration/packageInstallDocker.sh"
    export CURRENTARGS=

    if [ -n "$ZFS" ]
    then
        zfs snapshot -r zroot@"$(echo $CURRENTFUNC | cut -d '/' -f2)"
    fi

    menuFull

    export LASTFUNC=$CURRENTFUNC
    export LASTARGS=$CURRENTARGS

fi


if [ -n "$KDE" ]
then
    export CURRENTFUNC="extraConfiguration/packageInstallKDE.sh"
    export CURRENTARGS=

    if [ -n "$ZFS" ]
    then
        zfs snapshot -r zroot@"$(echo $CURRENTFUNC | cut -d '/' -f2)"
    fi

    menuFull

    export LASTFUNC=$CURRENTFUNC
    export LASTARGS=$CURRENTARGS

fi


if [ -n "$DESKTOP" ]
then
    export CURRENTFUNC="extraConfiguration/packageInstallDesktop.sh"
    export CURRENTARGS=

    if [ -n "$ZFS" ]
    then
        zfs snapshot -r zroot@"$(echo $CURRENTFUNC | cut -d '/' -f2)"
    fi

    menuFull

    export LASTFUNC=$CURRENTFUNC
    export LASTARGS=$CURRENTARGS

fi


if [ -n "$GAMES" ]
then
    export CURRENTFUNC="extraConfiguration/packageInstallGames.sh"
    export CURRENTARGS=

    if [ -n "$ZFS" ]
    then
        zfs snapshot -r zroot@"$(echo $CURRENTFUNC | cut -d '/' -f2)"
    fi

    menuFull

    export LASTFUNC=$CURRENTFUNC
    export LASTARGS=$CURRENTARGS

fi


if [ -n "$KDE" ]
then
    export CURRENTFUNC="extraConfiguration/userSetupKDE.sh"
    export CURRENTARGS=

    if [ -n "$ZFS" ]
    then
        zfs snapshot -r zroot@"$(echo $CURRENTFUNC | cut -d '/' -f2)"
    fi

    menuFull

    export LASTFUNC=$CURRENTFUNC
    export LASTARGS=$CURRENTARGS

fi


if [ -n "$DESKTOP" ]
then

    export CURRENTFUNC="extraConfiguration/userSetupDesktop.sh"
    export CURRENTARGS=

    if [ -n "$ZFS" ]
    then
        zfs snapshot -r zroot@"$(echo $CURRENTFUNC | cut -d '/' -f2)"
    fi

    menuFull

    export LASTFUNC=$CURRENTFUNC
    export LASTARGS=$CURRENTARGS

fi

if [ -n "$MAC" ]
then

    export CURRENTFUNC="extraConfiguration/systemConfigMac.sh"
    export CURRENTARGS=

    if [ -n "$ZFS" ]
    then
        zfs snapshot -r zroot@"$(echo $CURRENTFUNC | cut -d '/' -f2)"
    fi

    menuFull

    export LASTFUNC=$CURRENTFUNC
    export LASTARGS=$CURRENTARGS

fi

exit 0
