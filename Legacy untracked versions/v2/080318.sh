chkroot()
{
cls
echo "$B checking for root..........."
perm=$(id|cut -b 5)
if [ ?$perm? != ?0? ]
then
echo ?$R This script requires root! Type: su?
exit
else
echo "$B Root acces $G OK"
fi
}

cls() #used to retain header every time the screen is cleared
{
clear 
color
banner
}
color() #used to store color variables for other functions
{
export R='\033[1;31m'
export B='\033[1;34m'
export C='\033[0;36m'
export G='\033[1;32m'
export W='\033[1;37m'
export Y='\033[1;33m'
}
banner()  #req varaibles "isabt" true means about banner else headder banner
{
if [[ $isabt == "true" ]]
then
clear
echo $B"       ############################################"
echo $B"       ##          $Y" Para Linux Installer "$B        ##  "
echo $B"       ##        $G" Author "$B": "$R" Utkarsh Yadav"$B        ## "           
echo $B"       ##            $G" Codename "$B": "$R"imv"$B             ##"
echo $B"       ##              $G" Team "$B": "$R"UX7"$B               ## "                      
echo $B"       ############################################ "
echo 
echo
echo
echo $W
else
clear
echo $B"############################################################"
echo $B"##                  $Y" Para Linux Installer "$B                ##"
echo $B"############################################################ "
echo 
echo $W
fi
}


#INTERACT FUNCTIONS---------------------BEGIN

getfulpath()
{
echo "Enter Full Path Of Image File"
read fulpath
}

getfs()
{
echo "Enter FileSystem Of Image "
read fs
}

getmpath()
{
echo "Enter place to mount image eg (/sdcard/something )"
read mpath
}

getfsoptions()
{
echo "Enter filesystem of image"
echo " Enter The FileSystem You Want In Image File "
echo " Don't Choose vfat If You Are Installing Linux It Wont Work"
echo "Choose Out Of"
echo "vfat"
echo "ext2"
echo "ext3"
echo "ext4"
read fs
}

pete()
{
echo Press Enter To Exit
read doom
}

formaterrmsg()
{
echo "If you Saw Any Error in FileSystem Implementation "
echo "Choose ext2 It  Will Work Fine"
}

newscriptmsg()
{
echo "$C Do you want to make the script available as command?(Y/N) $G"
read isinit
if [[ $isinit == "Y" ]]
then
cp /sdcard/boot.sh /system/xbin/boot
fi
echo "$B Access Script Created*****************"
echo "$B Anytime To Use Your Linux Type This In terminal 'sh /sdcard/boot.sh'"
echo "$B If You Enabled Script As Command
then Just Type 'boot login'"
pete
}


#INTERACT FUNCTIONS--------------------END




#IMAGE TOOLS ------BEGIN


lodevinit() 
#create two loop devices /dev/block/loop277 and /dev/block/loop278.
#used for mounting image and sometimes for formating the image
{

if [ -b /dev/block/loop277 ]
then
echo ?Loop device exists?
echo "Removing Any Previous Image"
losetup -d /dev/bolck/loop277
else
echo "Creating Loop Device 1 "
busybox mknod /dev/block/loop277 b 7 277
fi


if [ -b /dev/block/loop278 ]
then
echo ?Loop device exists?
echo "Removing Any Previous Image"
losetup -d /dev/bolck/loop278
else
echo "Creating Loop Device 2"
busybox mknod /dev/block/loop278 b 7 278
fi

echo "Device Creation Compleated"

cls
}


imgformat() #req variables fulpath fs
{ 
#enable user to format an existing image
lodevinit
getfulpath
getfsoptions
echo "Removing Any Previous Image"
losetup -d /dev/bolck/loop278
echo "Setting New Image "
busybox losetup /dev/block/loop278 $fulpath
mkfs.$fs /dev/block/loop278
echo "Operation Compleated"
formaterrmsg
pete
}

imgmake()      # req varrs "impath imname fs siz
{
#__________________________________________
#ASK FOR PATH TO CREATE FILE 
#ASK FOR SIZE OF IMAGE
# ASK FOR NAME OF IMAGE
#ASK FOR FILESYSTEM OF IMAGE
#__________________________________________
#CREATE IMAGE BASED ON USER INPUT
if [[ $isini == "" ]]
then
lodevinit
echo "Where Do i create file input file path(eg. /sdcard/NewImage.img)"
getfulpath
echo "Give size of image in MB"
read siz
cls
getfsoptions
fi
cls
echo "It May Take Some Time Depending Upon Size Of Image"
formaterrmsg
echo "Creating Image With Selected FileSystem "
echo "==>Making Image********************"
busybox dd if=/dev/zero of=$fulpath bs=1M count=$siz
echo "==>Implementating FileSystem ********************"
echo "Removing Any Previous Image"
losetup -d /dev/bolck/loop277
echo "Setting New Image "
busybox losetup /dev/block/loop277 $fulpath
mkfs.$fs /dev/block/loop277
echo ""
pete
cls
}




imgmount()     #req vars "fulpath mpath fs"
{
#ASK AND MOUNT IMAGE TO MAKE DESIRED CHANGES
cls
lodevinit
if [[ $isinit == "" ]]
then
getfulpath
getmpath
getfs
fi
echo "Creating Image Mount Path Under $mpath"
if [[ ! -d $mpath ]]
then
mkdir $mpath
fi
echo "Setting New Image "
busybox losetup /dev/block/loop277 $fulpath
echo "Mounting $fulpath At $mpath"
busybox mount -o rw,sync -t $fs /dev/block/loop277 $mpath
if [[ $isinit == "" ]]
then
echo "Press Enter To Unmount Image And Go To Main Menu"
read dpath
echo "It May Take Some Time To Unmount"
umount $mpath
fi
}

#IMAGE TOOLS ------END











#LINUX CONFIGS ---------BEGIN


injectaccess()
{
cls
echo "$C Is The Script Located In /sdcard/boot.sh ?(Y/N)"
if [[ $isinit == "Y" ]]
then
cp /sdcard/boot.sh /system/xbin/boot
fi
if [[ $isinit == "N" ]]
then
accessscript
fi
}

confxorg()   #req vars " fulpath fs"
{
#AUTOMATICALLY CONFIGURE  XORG SERVER AND RUN ON DEVICE NATIVELY 
if [[ $isinit == "" ]]
then
echo you must install xorg by using apt-get install
getfulpath
getfs
fi

export mpath=/cache/debian_tmp

if [[ ! -d $mpath ]]
then
mkdir $mpath
fi


export isinit="true"
imgmount

if [[ ! -d $mpath/etc/X11 ]]
then
mkdir $mpath/etc/X11
fi

rm $mpath/etc/X11/xorg.conf

echo 'Section "ServerLayout" '>>$mpath/etc/X11/xorg.conf
echo 'Identifier "Andnux"' >>$mpath/etc/X11/xorg.conf
echo 'Screen "screen0" '>>$mpath/etc/X11/xorg.conf
echo 'InputDevice "mouse1"'>>$mpath/etc/X11/xorg.conf
echo 'InputDevice "mouse0" "CorePointer"'>>$mpath/etc/X11/xorg.conf
echo 'InputDevice "keyboard0" "CoreKeyboard"'>>$mpath/etc/X11/xorg.conf
echo 'Option "AutoAddDevices" "off"'>>$mpath/etc/X11/xorg.conf
echo 'EndSection'>>$mpath/etc/X11/xorg.conf
echo ''>>$mpath/etc/X11/xorg.conf
echo ''>>$mpath/etc/X11/xorg.conf
echo '#screen setup section'>>$mpath/etc/X11/xorg.conf
echo ''>>$mpath/etc/X11/xorg.conf
echo 'Section "Screen" '>>$mpath/etc/X11/xorg.conf
echo 'Identifier "screen0"'>>$mpath/etc/X11/xorg.conf 
echo 'Device "Framebuffer" '>>$mpath/etc/X11/xorg.conf
echo 'EndSection'>>$mpath/etc/X11/xorg.conf
echo 'Section "Device"'>>$mpath/etc/X11/xorg.conf
echo 'Identifier     "Framebuffer"'>>$mpath/etc/X11/xorg.conf
echo 'Driver "fbdev"'>>$mpath/etc/X11/xorg.conf
echo 'Option "fbdev" "/dev/graphics/fb0"'>>$mpath/etc/X11/xorg.conf
echo 'EndSection'>>$mpath/etc/X11/xorg.conf
echo ''>>$mpath/etc/X11/xorg.conf
echo '#touchpad '>>$mpath/etc/X11/xorg.conf
echo 'Section "InputDevice" '>>$mpath/etc/X11/xorg.conf
echo 'Identifier "mouse1" '>>$mpath/etc/X11/xorg.conf
echo 'Driver "multitouch" '>>$mpath/etc/X11/xorg.conf
echo 'Option "Device" "/dev/input/event2"'>>$mpath/etc/X11/xorg.conf
echo 'Option "Protocol" "auto"'>>$mpath/etc/X11/xorg.conf
echo 'EndSection'>>$mpath/etc/X11/xorg.conf
echo ''>>$mpath/etc/X11/xorg.conf
echo 'Section "InputDevice" '>>$mpath/etc/X11/xorg.conf
echo 'Identifier "mouse0" '>>$mpath/etc/X11/xorg.conf
echo 'Driver "mouse" '>>$mpath/etc/X11/xorg.conf
echo 'Option "mouse" "/dev/input/mice"'>>$mpath/etc/X11/xorg.conf
echo 'EndSection'>>$mpath/etc/X11/xorg.conf
echo ''>>$mpath/etc/X11/xorg.conf
echo ''>>$mpath/etc/X11/xorg.conf
echo 'Section "InputDevice" '>>$mpath/etc/X11/xorg.conf
echo 'Identifier "keyboard0" '>>$mpath/etc/X11/xorg.conf
echo 'Driver "kbd" '>>$mpath/etc/X11/xorg.conf
echo 'Option "kbd" "/dev/input/event0"'>>$mpath/etc/X11/xorg.conf
echo 'EndSection'>>$mpath/etc/X11/xorg.conf
echo xorg.conf created run startx it might need some tweaking
read iput
umount $mpath
}


accessscriptnew()
{
#CREATE SCRIPT TO START LINUX DISTRO (newmethod)
if [[ $isinit == "" ]]
then
clear
getfulpath
getmpath
getfs
fi
echo "Creating ACCESS SCRIPT************************************************************************************************************************"
rm /sdcard/boot.sh
echo "echo export fulpath=" $fulpath>>/sdcard/boot.sh
echo "echo export mpath=" $mpath>>/sdcard/boot.sh
echo "echo export fs=$fs" >>/sdcard/boot.sh
echo "echo export isinit=ready ">>/sdcard/boot.sh
echo "u.sh boot $@" >>/sdcard/boot.sh
newscriptmsg
}


accessscript()
{
#CREATE SCRIPT TO START LINUX DISTRO (oldmethod) use the new one instead
if [[ $isinit == "" ]]
then
clear
getfulpath
getmpath
getfs
fi
echo "Creating ACCESS SCRIPT************************************************************************************************************************"
rm /sdcard/boot.sh
echo "echo prepairing directory">>/sdcard/boot.sh
echo "if [[ ! -d "$mpath" ]]">>/sdcard/boot.sh
echo "then">>/sdcard/boot.sh
echo "mkdir "$mpath>>/sdcard/boot.sh
echo "fi">>/sdcard/boot.sh
echo 'echo "Creating Loop Device "'>>/sdcard/boot.sh
echo 'busybox mknod /dev/block/loop279 b 7 279'>>/sdcard/boot.sh
echo 'echo "Device Creation Compleated"'
echo 'echo "=>mounting chroot image"'>>/sdcard/boot.sh
echo 'echo "Removing Any Previous Image"'>>/sdcard/boot.sh
echo 'losetup -d /dev/bolck/loop279'>>/sdcard/boot.sh
echo 'echo "Setting New Image "'>>/sdcard/boot.sh
echo 'busybox losetup /dev/block/loop279 '$fulpath>>/sdcard/boot.sh
echo 'echo "Mounting' $fulpath 'At' $mpath'"'>>/sdcard/boot.sh
echo 'busybox mount -o rw,sync -t '$fs '/dev/block/loop279' $mpath>>/sdcard/boot.sh
echo 'echo "mounting /dev"'>>/sdcard/boot.sh
echo 'mount -o bind /dev '$mpath'/dev'>>/sdcard/boot.sh
echo 'echo "=>mounting /dev/pts "'>>/sdcard/boot.sh
echo 'mount -t devpts devpts '$mpath'/dev/pts'>>/sdcard/boot.sh
echo 'echo "=>mounting /proc "'>>/sdcard/boot.sh
echo 'mount -t proc proc '$mpath'/proc'>>/sdcard/boot.sh
echo 'echo "=>mounting sys"'>>/sdcard/boot.sh
echo 'mount -t sysfs sysfs '$mpath'/sys'>>/sdcard/boot.sh
echo 'echo "=>mounting tmp"'>>/sdcard/boot.sh
echo 'mount -t tmpfs tmpfs '$mpath'/tmp'>>/sdcard/boot.sh
echo 'echo "=>mounting storage"'>>/sdcard/boot.sh
echo 'mount -o bind /sdcard '$mpath'/sdcard'>>/sdcard/boot.sh
echo 'echo "=>fireing up chroot environment "'>>/sdcard/boot.sh
echo 'chroot  '$mpath'/ /root/tap.sh $@'>>/sdcard/boot.sh
echo 'PREFIX='$mpath>>/sdcard/boot.sh
echo 'FOUND=0'>>/sdcard/boot.sh
echo ''>>/sdcard/boot.sh
echo 'for ROOT in /proc/*/root; do'>>/sdcard/boot.sh
echo '    LINK=$(readlink $ROOT)'>>/sdcard/boot.sh
echo '    if [ "x$LINK" != "x" ];
then'>>/sdcard/boot.sh
echo '        if [ "x${LINK:0:${#PREFIX}}" = "x$PREFIX" ];
then'>>/sdcard/boot.sh
echo '            PID=$(basename $(dirname "$ROOT"))'>>/sdcard/boot.sh
echo '            kill -9 "$PID"'>>/sdcard/boot.sh
echo '            FOUND=1'>>/sdcard/boot.sh
echo '        fi'>>/sdcard/boot.sh
echo '    fi'>>/sdcard/boot.sh
echo 'done'>>/sdcard/boot.sh
echo ''>>/sdcard/boot.sh
echo '   if [ "x$FOUND" = "x1" ];
then'>>/sdcard/boot.sh
echo '   echo found # repeat the above, the script Im cargo-culting this from just re-execs itself'>>/sdcard/boot.sh
echo '   fi'>>/sdcard/boot.sh
echo 'echo "=>unmounting /tmp"'>>/sdcard/boot.sh
echo 'umount '$mpath'/tmp'>>/sdcard/boot.sh
echo 'echo "=>unmounting /dev/pts"'>>/sdcard/boot.sh
echo 'umount '$mpath'/dev/pts'>>/sdcard/boot.sh
echo 'echo "=>unmounting /proc "'>>/sdcard/boot.sh
echo 'umount '$mpath'/proc'>>/sdcard/boot.sh
echo 'echo "=>unmounting /sys"'>>/sdcard/boot.sh
echo 'umount '$mpath'/sys'>>/sdcard/boot.sh
echo 'echo "=>unmounting /dev"'>>/sdcard/boot.sh
echo 'umount '$mpath'/dev'>>/sdcard/boot.sh
echo 'echo "=>unmounting /sdcard"'>>/sdcard/boot.sh
echo 'umount '$mpath'/sdcard'>>/sdcard/boot.sh
echo 'echo "=>unmounting chroot image "'>>/sdcard/boot.sh
echo 'umount '$mpath>>/sdcard/boot.sh
newscriptmsg
}







internalconfig()
{ #Access Script Chroot Part (oldmethod) not needed now the function is integrated
if [[ $isinit == "" ]]
then
echo you must install xorg by using apt-get install
getfulpath
getfs
export mpath=/cache/debian_tmp

if [[ ! -d $mpath ]]
then
mkdir $mpath
fi

imgmount
fi


#This Is The Script To Be Used By User To Log In
echo "Creating Boot Script**************************************************************************************************************************"
echo '#!/bin/bash'>>$mpath/root/tap.sh
echo 'export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/sbin'>>$mpath/root/tap.sh
echo 'export TERM=linux'>>$mpath/root/tap.sh
echo 'export HOME=/root'>>$mpath/root/tap.sh
echo 'dpkg-divert --local --rename --add /sbin/initctl>>/dev/null 2>&1'>>$mpath/root/tap.sh
echo 'ln -s /bin/true /sbin/initctl > /dev/null 2>&1'>>$mpath/root/tap.sh
echo 'if [ $1 == "login" ] '>>$mpath/root/tap.sh
echo 'then'>>$mpath/root/tap.sh
echo 'clear'>>$mpath/root/tap.sh
echo 'su $2'>>$mpath/root/tap.sh
echo 'elif [ $1 == "run" ]'>>$mpath/root/tap.sh
echo 'then'>>$mpath/root/tap.sh
echo 'clear'>>$mpath/root/tap.sh
echo '$2 $3 $4 $5 $6 $7 $8 $9'>>$mpath/root/tap.sh
echo 'elif [ $1 == "install" ] '>>$mpath/root/tap.sh
echo 'then'>>$mpath/root/tap.sh
echo 'clear'>>$mpath/root/tap.sh
echo 'apt-get install $2 $3 $4 $5 $6 $7 $8 $9'>>$mpath/root/tap.sh
echo 'echo Press Enter To Exit'>>$mpath/root/tap.sh
echo 'read uip'>>$mpath/root/tap.sh
echo 'fi'>>$mpath/root/tap.sh
echo 'echo "Exiting Linux"'>>$mpath/root/tap.sh
echo 'exit'>>$mpath/root/tap.sh
chmod 755 $mpath/root/tap.sh
echo ""
echo ""
}

addpermissiongroups()
{
#It Gives Linux Some Permissions To Be Able To Use Android Resources 
echo "Setting Up user And Permissions In Linux****************************************************************************************************"
echo "Creating User Permissions Script"
#!/bin/sh
echo "=> Adding android groups for various permissions "
groupadd -g 1003 aid_graphics
groupadd -g 1004 aid_input
groupadd -g 1007 aid_log
groupadd -g 1009 aid_mount
groupadd -g 1010 aid_wifi
groupadd -g 1011 aid_adb
groupadd -g 1015 aid_sdcard_rw
groupadd -g 1018 aid_usb
groupadd -g 1020 aid_mdnsr
groupadd -g 1023 aid_media_rw
groupadd -g 1028 aid_sdcard_r
groupadd -g 1035 aid_sdcard_all
groupadd -g 2000 aid_shell
groupadd -g 3001 aid_net_bt_admin
groupadd -g 3002 aid_net_bt
groupadd -g 3003 aid_inet
groupadd -g 3004 aid_inet_raw
groupadd -g 3005 aid_inet_admin
groupadd -g 3006 aid_net_bw_stats
groupadd -g 3007 aid_net_bw_acct
groupadd -g 3008 aid_net_bt_stack   
}


addusertogroups()
{
echo "=>> Adding your user to permission groups"
gpasswd -a $username aid_net_bt_admin
gpasswd -a $username aid_net_bt
gpasswd -a $username aid_inet
gpasswd -a $username aid_inet_raw
gpasswd -a $username aid_inet_admin
gpasswd -a $username aid_net_bw_stats
gpasswd -a $username aid_net_bw_acct
gpasswd -a $username aid_net_bt_stack
gpasswd -a $username adm
gpasswd -a $username sudo
gpasswd -a $username admin
gpasswd -a $username aid_graphics
gpasswd -a $username aid_input
gpasswd -a $username aid_log
gpasswd -a $username aid_mount
gpasswd -a $username aid_wifi
gpasswd -a $username aid_sdcard_rw
gpasswd -a $username aid_usb
gpasswd -a $username aid_mdnsr
gpasswd -a $username aid_media_rw
gpasswd -a $username aid_sdcard_r
gpasswd -a $username aid_sdcard_all
gpasswd -a $username aid_shell
echo "New user can now have all permisdions"
}


permissions()
{
#It Gives Linux Some Permissions To Be Able To Use Android Resources 
echo "Setting Up user And Permissions In Linux****************************************************************************************************"
echo "Creating User Permissions Script"
echo '#!/bin/sh'>>$mpath/users.sh
echo 'echo "=>> Adding android groups for various permissions "'>>$mpath/users.sh
echo 'groupadd -g 1003 aid_graphics'>>$mpath/users.sh
echo 'groupadd -g 1004 aid_input'>>$mpath/users.sh
echo 'groupadd -g 1007 aid_log'>>$mpath/users.sh
echo 'groupadd -g 1009 aid_mount'>>$mpath/users.sh
echo 'groupadd -g 1010 aid_wifi'>>$mpath/users.sh
echo 'groupadd -g 1011 aid_adb'>>$mpath/users.sh
echo 'groupadd -g 1015 aid_sdcard_rw'>>$mpath/users.sh
echo 'groupadd -g 1018 aid_usb'>>$mpath/users.sh
echo 'groupadd -g 1020 aid_mdnsr'>>$mpath/users.sh
echo 'groupadd -g 1023 aid_media_rw'>>$mpath/users.sh
echo 'groupadd -g 1028 aid_sdcard_r'>>$mpath/users.sh
echo 'groupadd -g 1035 aid_sdcard_all'>>$mpath/users.sh
echo 'groupadd -g 2000 aid_shell'>>$mpath/users.sh
echo 'groupadd -g 3001 aid_net_bt_admin'>>$mpath/users.sh
echo 'groupadd -g 3002 aid_net_bt'>>$mpath/users.sh
echo 'groupadd -g 3003 aid_inet'>>$mpath/users.sh
echo 'groupadd -g 3004 aid_inet_raw'>>$mpath/users.sh
echo 'groupadd -g 3005 aid_inet_admin'>>$mpath/users.sh
echo 'groupadd -g 3006 aid_net_bw_stats'>>$mpath/users.sh
echo 'groupadd -g 3007 aid_net_bw_acct'>>$mpath/users.sh
echo 'groupadd -g 3008 aid_net_bt_stack'>>$mpath/users.sh   
echo ''>>$mpath/users.sh
echo ''>>$mpath/users.sh


if [[ $username == "root" ]]
then
echo root
else
echo 'echo "=>> Creating user account "'>>$mpath/users.sh
echo 'adduser '$username>>$mpath/users.sh
fi

echo 'echo "=>> Adding your user to permission groups"'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_net_bt_admin'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_net_bt'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_inet'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_inet_raw'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_inet_admin'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_net_bw_stats'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_net_bw_acct'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_net_bt_stack'>>$mpath/users.sh
echo 'gpasswd -a '$username' adm'>>$mpath/users.sh
echo 'gpasswd -a '$username' sudo'>>$mpath/users.sh
echo 'gpasswd -a '$username' admin'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_graphics'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_input'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_log'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_mount'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_wifi'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_sdcard_rw'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_usb'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_mdnsr'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_media_rw'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_sdcard_r'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_sdcard_all'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_shell'>>$mpath/users.sh

}


#LINUX CONFIGS ---------END


#BOOT TOOLS --------------BEGIN




boot()   #req vars fulpath mpath fs
#INBUILT FUNCTION TO BOOT ANY IMAGE WITH INTERACTIVE MOOD
{
if [[ $isinit == "ready" ]]
then
export agentloc=$mpath/root/trap.sh
fi
imgmount
cp u.sh $agentloc
chmod 777 $agentloc
echo "mounting /dev"
mount -o bind /dev $mpath/dev
echo "=>mounting /dev/pts "
mount -t devpts devpts $mpath/dev/pts
echo "=>mounting /proc "
mount -t proc proc $mpath/proc
echo "=>mounting sys"
mount -t sysfs sysfs $mpath/sys
echo "=>mounting tmp"
mount -t tmpfs tmpfs $mpath/tmp
echo "=>mounting storage"
mount -o bind /sdcard $mpath/sdcard
echo "=>fireing up chroot environment "
chroot  $mpath/ /bin/bash /root/trap.sh configlink $@
#linux killer
PREFIX=$mpath
FOUND=0

for ROOT in /proc/*/root; do
    LINK=$(readlink $ROOT)
    if [ "x$LINK" != "x" ];
then
        if [ "x${LINK:0:${#PREFIX}}" = "x$PREFIX" ];
then
            PID=$(basename $(dirname "$ROOT"))
            kill -9 "$PID"
            FOUND=1
        fi
    fi
done

   if [ "x$FOUND" = "x1" ];
then
   found # repeat the above, the script Im cargo-culting this from just re-execs itself
   fi
rm $mpath/root/trap.sh
echo "=>unmounting /tmp"
umount $mpath/tmp
echo "=>unmounting /dev/pts"
umount $mpath/dev/pts
echo "=>unmounting /proc "
umount $mpath/proc
echo "=>unmounting /sys"
umount $mpath/sys
echo "=>unmounting /dev"
umount $mpath/dev
echo "=>unmounting /sdcard"
umount $mpath/sdcard
echo "=>unmounting chroot image "
umount $mpath
exit
}

configlink()
{
echo welcome
#!/bin/bash
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/sbin
export TERM=linux
export HOME=/root
dpkg-divert --local --rename --add /sbin/initctl>>/dev/null 2>&1
ln -s /bin/true /sbin/initctl > /dev/null 2>&1
if [[ $1 == "login" ]] 
then
clear
su $3
elif [[ $1 == "run" ]]
then
clear
$2 $3 $4 $5 $6 $7 $8 $9
elif [[ $1 == "install" ]] 
then
clear
apt-get install $2 $3 $4 $5 $6 $7 $8 $9
pete
elif [[ $1 == "adduser" ]] 
then
echo Enter the Username
read username
echo "=> Creating user account "
adduser $username
addpermissiongroups
addusertogroups
clear
fi
echo "Exiting Linux"
exit

}


#BOOT TOOLS --------------END


#SMALL FUNC ------------BEGIN
getbase()
{
cls
echo "Debian Jessie ">>/sdcard/LiBaLinks.txt
echo "copied">>/sdcard/LiBaLinks.txt
echo "Ubuntu">>/sdcard/LiBaLinks.txt
echo "copied">>/sdcard/LiBaLinks.txt
echo "KALI linux">>/sdcard/LiBaLinks.txt
echo "copied">>/sdcard/LiBaLinks.txt
clear
echo "Link Of Linux Base Has been"
echo "Coppied in /sdcard/LiBaLinks.txt"
echo "Download your preferred one"
echo " Press Enter To Get Back."
read iput
echo $iput
}

about()
{
export isabt=true
cls
export isabt=false
}


#SMALL FUNC ------------END


linuxinst()
{
#ASK FOR PATH AND FILESYSTEM OF IMAGE 
#IF NOT AVAILABLE GIVE OPTION TO MAKE A NEW ONE
#ASK USERNAME TO BE USED
#ASK LOCATION OF DEBIAN PACKAGES 
#IF NOT AVAILABLE GIVE OPTION TO DOWNLOAD A NEW ONE
#INSTALL LINUX IN THE IMAGE AS A CHROOT
cls
echo "$C Enter Full Path Of The Image ."
echo "$R If you dont have one type newimg and press enter$G"
read fulpath
cls
if [[ $fulpath == "newimg" ]]
then
imgmake     #req nothing here
else 
getfs
cls
fi
echo "$C Enter User Name For Linux Installation$G"
read chuser
cls
export isinit=true
export mpath="/sdcard/debian_tmp"
echo "$C Enter Location To Mount Your Linux. "
echo "$R if unsure anout this option type /cache/linux$G"
read mpathw
cls
imgmount     #req mpath fs fulpath
echo "$C Enter Path Of Linux Base."
echo "$R if you dont have them type getbase and press enter $G"
read dpath
cls
if [[ dpath == "getbase" ]]
then
getbase
echo ""
echo""
echo ""
echo "$C Enter Path Of Linux Base.$G"
read dpath
cls
fi

echo "$BIt May Take Some Time In Extracting System Base"
tar -xzvf $dpath -C $mpath
mv /sdcard/debian_tmp/Debian/* /sdcard/debian_tmp/
mv /sdcard/debian_tmp/Ubuntu/* /sdcard/debian_tmp/
mv /sdcard/debian_tmp/Kali/* /sdcard/debian_tmp/
echo "$B Extraction Complete "

export username=$chuser
permissions     #req mpath
export username=root
permissions      #req mpath







#this user _apt cause package installation problems so i removed it 
#echo 'deluser _apt'>>$mpath/users.sh    #issue fixed on adding the user to inet group
echo 'gpasswd -a _apt aid_inet'>>$mpath/users.sh

echo 'if [[ ! -d /etc/initiallisedux7/ ]]'>>$mpath/users.sh
echo 'then'>>$mpath/users.sh
echo 'mkdir /etc/initiallisedux7/'>>$mpath/users.sh
echo 'fi'>>$mpath/users.sh
echo 'echo "user setup ">>/etc/initiallisedux7/usersetup'>>$mpath/users.sh
echo 'echo "=> Done"'>>$mpath/users.sh
echo 'echo "Press Enter"'>> $mpath/users.sh
echo 'read s'>>$mpath/users.sh
echo 'exit'>>$mpath/users.sh
chmod 755 $mpath/users.sh
echo "Permission Script Completed*******************************************************************************************************************"
echo ""
echo ""
echo ""


internalconfig       #req mpath


# Open Bash To Executes The Permissions Script 
echo "Creating Boot Script**************************************************************************************************************************"
echo '#!/bin/bash'>>$mpath/tap.sh
echo 'export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/sbin'>>$mpath/tap.sh
echo 'export TERM=linux'>>$mpath/tap.sh
echo 'export HOME=/root'>>$mpath/tap.sh
echo 'dpkg-divert --local --rename --add /sbin/initctl > /dev/null 2>&1'>>$mpath/tap.sh
echo 'ln -s /bin/true /sbin/initctl > /dev/null 2>&1'>>$mpath/tap.sh
echo '/bin/bash /users.sh'>>$mpath/tap.sh
echo 'echo "Exiting Linux"'>>$mpath/tap.sh
echo 'exit'>>$mpath/tap.sh
chmod 755 $mpath/tap.sh
echo "Boot Setup Script Created***************************************************************************************************************************"



#This Script Boots Linux And Do initial setup
echo "mounting /dev"
mount -o bind /dev $mpath/dev
echo "=>mounting /dev/pts"
mount -t devpts devpts $mpath/dev/pts
echo "=>mounting /proc "
mount -t proc proc $mpath/proc
echo "=>mounting sys"
mount -t sysfs sysfs $mpath/sys
echo "=>fireing up chroot environment "
chroot  $mpath/ /tap.sh
echo "=>unmounting /dev/pts"
umount $mpath/dev/pts
echo "=>unmounting /proc "
umount $mpath/proc
echo "=>unmounting /sys"
umount $mpath/sys
echo "=>unmounting /dev"
umount $mpath/dev
echo "=>unmounting chroot image "
umount $mpath
echo " Press Enter To Get Back To The Main Menu"
umount  $mpath

export mpath=$mpathw
accessscript #req mpath fulpath fs

}


#MENU INTERFACE --------------------*-**BEGIN

chkroot

menu()
{
cls
echo "$R WELCOME TO MAIN MENU $Y"
echo " Type menu no. and press enter."
echo "     $G 1$C. Linux installer"
echo "     $G 2$C. Image Tools"
echo "     $G 3$C. Boot Tools"
echo "     $G 4$C. Linux Configuration"
echo "     $G 5$C. Help And Trouble Shooting"
echo "     $G 6$C. About"
echo "     $G 7$C. Exit"
echo ""
echo ""
echo "Enter Choice  :$G"
read iput
if [[ "$iput" -eq 1 ]]
then
linuxinst
elif [[ "$iput" -eq 2 ]]
then
imgmenu
elif [[ "$iput" -eq 3 ]]
then
boot
elif [[ "$iput" -eq 4 ]]
then
confmenu
elif [[ "$iput" -eq 5 ]]
then
help
elif [[ "$iput" -eq 6 ]]
then
about
elif [[ "$iput" -eq 7 ]]
then
exit
fi
}

imgmenu()
#display a menu to access image related tools
{
cls
echo "$R WELCOME TO MAIN MENU $Y"
echo " Type item no. and press enter."
echo "     $G 1$C. Create Image "
echo "     $G 2$C. Mount Image"
echo "     $G 3$C. Format An Existing Image"
echo "     $G 4$C. Exit"
echo ""
echo ""
echo "Enter Choice  :$G"
read iput
if [[ "$iput" -eq 1 ]]
then
imgmake
elif [[ "$iput" -eq 2 ]]
then
imgmount
elif [[ "$iput" -eq 3 ]]
then
imgformat
elif [[ "$iput" -eq 4 ]]
then
exit
fi
}

confmenu()
#display a menu to access configuration related tools
{
cls
echo "$R WELCOME TO MAIN MENU $Y"
echo " Type item no. and press enter."
echo "     $G 1$C. Create Access Script"
echo "     $G 2$C. Make Access Script Available As Command"
echo "     $G 3$C. Recreate Internal Access Script"
echo "     $G 4$C. Configure Xorg Files"
echo "     $G 5$C. Conf New User"
echo "     $G 6$C. Exit"
echo ""
echo ""
echo "Enter Choice  :$G"
read iput
if [[ "$iput" -eq 1 ]]
then
accessscript
elif [[ "$iput" -eq 2 ]]
then
injectaccess
elif [[ "$iput" -eq 3 ]]
then
internalconfigold
export isinit=nomount
elif [[ "$iput" -eq 4 ]]
then
confxorg
elif [[ "$iput" -eq 6 ]]
then
exit
fi
}

help()
{ #display a menu to access help
banner
echo "$R WELCOME TO HELP MENU $W"
echo " Type item no. and press enter "
echo "     1. Get Linux Base"
echo "     2. Create Image File"
echo "     3. Mount An Image File "
echo "     4. Recreate  external access script (boot.sh) after changing image file"
echo "     5. Recreate internal access script (/root/tap.sh) after accidentally removing it"
echo "     6. Permision Issues with new users"
echo "Enter Choice  :$G"
read iput
if [[ "$iput" -eq 1 ]]
then
accessscript
elif [[ "$iput" -eq 2 ]]
then
injectaccess
elif [[ "$iput" -eq 3 ]]
then
internalconfigold
export isinit=nomount
elif [[ "$iput" -eq 4 ]]
then
confxorg
elif [[ "$iput" -eq 6 ]]
then
exit
fi
}

#MENU INTERFACE -------------------------END



#COMMAND LINE ACCEPTORS
if [[ $@ == "" ]]
then
menu
exit
elif [[ $@ == "linuxinst" ]]
then
linuxinst
exit
elif [[ $@ == "imgmount" ]]
then
imgmount
exit
elif [[ $@ == "imgmake" ]]
then
imgmake
exit
elif [[ $@ == "confxorg" ]]
then
confxorg
exit
elif [[ $@ == "lboot" ]]
then
accessscript
exit
elif [[ $@ == "help" ]]
then
help
exit
elif [[ $@ == "" ]]
then
menu
exit
else
echo $1 $2
$@
fi