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
echo "$C Enter Full Path Of Image File"
read fulpath
}

getdevpath()
{
echo "$C Enter Full Path Of Device  File (eg ./dev/block/sda)"
read devpath
}




getfs()
{
echo "$C Enter FileSystem Of Image "
read fs
}

getmpath()
{
echo "$C Enter place to mount image eg (/sdcard/something )"
read mpath
}

getfsoptions()
{
echo "$C Enter filesystem of image"
echo " $B Enter The FileSystem You Want In Image File "
echo " Don't Choose vfat If You Are Installing Linux It Wont Work"
echo "Choose Out Of"
echo "$Y =>$G vfat"
echo "$Y =>$G ext2"
echo "$Y =>$G ext3"
echo "$Y =>$G ext4"
read fs
}

pete()
{
echo Press Enter To Exit
read doom
}

formaterrmsg()
{
echo "$B If you Saw Any Error in FileSystem Implementation "
echo "$B Choose ext2 It  Will Work Fine"
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
if [ -b /dev/block/loop279 ]
then
echo ?Loop device exists?
echo "Removing Any Previous Image"
losetup -d /dev/bolck/loop279
else
echo "Creating Loop Device 1 "
busybox mknod /dev/block/loop279 b 7 279
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
if [[ $isini == "" ]]
then
getfulpath
getfsoptions
fi
echo "$Y ==>Implementating FileSystem ********************$G"
echo "$BSetting New Image fs$G "
mkfs.$fs -F $fulpath
echo ""
pete
cls
formaterrmsg
if [[ $isini == "" ]]
then
pete
fi
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
cls
echo "$C Where Do i create file input file path(eg. /sdcard/NewImage.img) $G"
getfulpath
echo "$C Give size of image in MB$G"
read siz
cls
getfsoptions
export isini=true
fi
cls
echo "$C It May Take Some Time Depending Upon Size Of Image"
formaterrmsg
echo "Creating Image With Selected FileSystem "
echo "$Y==>Making Image******************** $B"
busybox dd if=/dev/zero of=$fulpath bs=1M count=$siz
imgformat
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
busybox losetup /dev/block/loop279 $fulpath
echo "Mounting $fulpath At $mpath"
busybox mount -o rw,sync -t $fs /dev/block/loop279 $mpath
if [[ $isinit == "" ]]
then
echo "Press Enter To Unmount Image And Go To Main Menu"
read dpath
echo "It May Take Some Time To Unmount"
umount $mpath
fi
}


pdmount()     #req vars "fulpath mpath fs"
{
#ASK AND MOUNT PEN DRIVE TO MAKE DESIRED CHANGES
cls
if [[ $isinit == "" ]]
then
getdevpath
getmpath
getfs
fi
echo "Creating Image Mount Path Under $mpath"
if [[ ! -d $mpath ]]
then
mkdir $mpath
fi
echo "Mounting $devpath At $mpath"
busybox mount -o rw,sync -t $fs $devpath $mpath
if [[ $isinit == "" ]]
then
echo "Press Enter To Unmount Image And Go To Main Menu"
read dpath
echo "It May Take Some Time To Unmount"
umount $mpath
fi
export um=umount $mpath
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
echo "export fulpath="$fulpath>>/sdcard/boot.sh
echo "export mpath="$mpath>>/sdcard/boot.sh
echo "export fs=$fs" >>/sdcard/boot.sh
echo "export isinit=ready ">>/sdcard/boot.sh
echo "sh u.sh boot \$@" >>/sdcard/boot.sh
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

makepermissions()
{
#It Gives Linux Some Permissions To Be Able To Use Android Resources 
echo "Setting Up user And Permissions In Linux****************************************************************************************************"
echo "Creating User Permissions Script"
echo '#!/bin/sh'>>$mpath/users.sh
echo 'echo "=>> Adding android groups for various permissions "'>>$mpath/users.sh
 

echo 'groupadd -g 1000 aid_system'>>$mpath/users.sh
echo 'groupadd -g 1001 aid_radio'>>$mpath/users.sh
echo 'groupadd -g 1002 aid_bluetooth'>>$mpath/users.sh
echo 'groupadd -g 1003 aid_graphics'>>$mpath/users.sh
echo 'groupadd -g 1004 aid_input'>>$mpath/users.sh
echo 'groupadd -g 1005 aid_audio'>>$mpath/users.sh
echo 'groupadd -g 1006 aid_camera'>>$mpath/users.sh
echo 'groupadd -g 1007 aid_log'>>$mpath/users.sh
echo 'groupadd -g 1008 aid_compass'>>$mpath/users.sh
echo 'groupadd -g 1009 aid_mount'>>$mpath/users.sh
echo 'groupadd -g 1010 aid_wifi'>>$mpath/users.sh
echo 'groupadd -g 1011 aid_adb'>>$mpath/users.sh
echo 'groupadd -g 1012 aid_install'>>$mpath/users.sh
echo 'groupadd -g 1013 aid_media'>>$mpath/users.sh
echo 'groupadd -g 1014 aid_dhcp'>>$mpath/users.sh
echo 'groupadd -g 1015 aid_sdcard_rw'>>$mpath/users.sh
echo 'groupadd -g 1016 aid_vpn'>>$mpath/users.sh
echo 'groupadd -g 1017 aid_keystore'>>$mpath/users.sh
echo 'groupadd -g 1018 aid_usb'>>$mpath/users.sh
echo 'groupadd -g 1019 aid_drm'>>$mpath/users.sh
echo 'groupadd -g 1020 aid_mdnsr'>>$mpath/users.sh
echo 'groupadd -g 1021 aid_gps'>>$mpath/users.sh
echo 'groupadd -g 1023 aid_media_rw'>>$mpath/users.sh
echo 'groupadd -g 1024 aid_mtp'>>$mpath/users.sh
echo 'groupadd -g 1026 aid_drmrpc'>>$mpath/users.sh
echo 'groupadd -g 1027 aid_nfc'>>$mpath/users.sh
echo 'groupadd -g 1028 aid_sdcard_r'>>$mpath/users.sh
echo 'groupadd -g 1029 aid_clat'>>$mpath/users.sh
echo 'groupadd -g 1030 aid_loop_radio'>>$mpath/users.sh
echo 'groupadd -g 1031 aid_media_drm'>>$mpath/users.sh
echo 'groupadd -g 1032 aid_package_info'>>$mpath/users.sh
echo 'groupadd -g 1033 aid_sdcard_pics'>>$mpath/users.sh
echo 'groupadd -g 1034 aid_sdcard_av'>>$mpath/users.sh
echo 'groupadd -g 1035 aid_sdcard_all'>>$mpath/users.sh
echo 'groupadd -g 1036 aid_logd'>>$mpath/users.sh
echo 'groupadd -g 1037 aid_shared_relro'>>$mpath/users.sh
echo 'groupadd -g 1038 aid_dbus'>>$mpath/users.sh
echo 'groupadd -g 1039 aid_tlsdate'>>$mpath/users.sh
echo 'groupadd -g 1040 aid_media_ex'>>$mpath/users.sh
echo 'groupadd -g 1041 aid_audioserver'>>$mpath/users.sh
echo 'groupadd -g 1042 aid_metrics_coll'>>$mpath/users.sh
echo 'groupadd -g 1043 aid_metricsd'>>$mpath/users.sh
echo 'groupadd -g 1044 aid_webserv'>>$mpath/users.sh
echo 'groupadd -g 1045 aid_debuggerd'>>$mpath/users.sh
echo 'groupadd -g 1046 aid_media_codec'>>$mpath/users.sh
echo 'groupadd -g 1047 aid_cameraserver'>>$mpath/users.sh
echo 'groupadd -g 1048 aid_firewall'>>$mpath/users.sh
echo 'groupadd -g 1049 aid_trunks'>>$mpath/users.sh
echo 'groupadd -g 1050 aid_nvram'>>$mpath/users.sh
echo 'groupadd -g 1051 aid_dns'>>$mpath/users.sh
echo 'groupadd -g 1052 aid_dns_tether'>>$mpath/users.sh
echo 'groupadd -g 1053 aid_webview_zygote'>>$mpath/users.sh
echo 'groupadd -g 1054 aid_vehicle_network'>>$mpath/users.sh
echo 'groupadd -g 1055 aid_media_audio'>>$mpath/users.sh
echo 'groupadd -g 1056 aid_media_video'>>$mpath/users.sh
echo 'groupadd -g 1057 aid_media_image'>>$mpath/users.sh
echo 'groupadd -g 1058 aid_tombstoned'>>$mpath/users.sh
echo 'groupadd -g 1059 aid_media_obb'>>$mpath/users.sh
echo 'groupadd -g 1060 aid_ese'>>$mpath/users.sh
echo 'groupadd -g 1061 aid_ota_update'>>$mpath/users.sh
echo 'groupadd -g 1062 aid_automotive_evs'>>$mpath/users.sh
echo 'groupadd -g 1063 aid_lowpan'>>$mpath/users.sh
echo 'groupadd -g 1064 aid_hsm'>>$mpath/users.sh
echo 'groupadd -g 1065 aid_reserved_disk'>>$mpath/users.sh
echo 'groupadd -g 1066 aid_statsd'>>$mpath/users.sh
echo 'groupadd -g 1067 aid_incidentd'>>$mpath/users.sh
echo 'groupadd -g 1068 aid_secure_element'>>$mpath/users.sh
echo 'groupadd -g 1069 aid_lmkd'>>$mpath/users.sh
echo 'groupadd -g 1070 aid_llkd'>>$mpath/users.sh
echo 'groupadd -g 1071 aid_iorapd'>>$mpath/users.sh
echo 'groupadd -g 1072 aid_gpu_service'>>$mpath/users.sh
echo 'groupadd -g 1073 aid_network_stack'>>$mpath/users.sh
echo 'groupadd -g 2000 aid_shell'>>$mpath/users.sh
echo 'groupadd -g 2001 aid_cache'>>$mpath/users.sh
echo 'groupadd -g 2002 aid_diag'>>$mpath/users.sh
echo 'groupadd -g 2900 aid_oem_reserved_start'>>$mpath/users.sh
echo 'groupadd -g 2999 aid_oem_reserved_end'>>$mpath/users.sh
echo 'groupadd -g 3001 aid_net_bt_admin'>>$mpath/users.sh
echo 'groupadd -g 3002 aid_net_bt'>>$mpath/users.sh
echo 'groupadd -g 3003 aid_inet'>>$mpath/users.sh
echo 'groupadd -g 3004 aid_net_raw'>>$mpath/users.sh
echo 'groupadd -g 3005 aid_net_admin'>>$mpath/users.sh
echo 'groupadd -g 3006 aid_net_bw_stats'>>$mpath/users.sh
echo 'groupadd -g 3007 aid_net_bw_acct'>>$mpath/users.sh
echo 'groupadd -g 3009 aid_readproc'>>$mpath/users.sh
echo 'groupadd -g 3010 aid_wakelock'>>$mpath/users.sh
echo 'groupadd -g 3011 aid_uhid'>>$mpath/users.sh
echo 'groupadd -g 9997 aid_everybody'>>$mpath/users.sh
echo 'groupadd -g 9998 aid_misc'>>$mpath/users.sh
echo 'groupadd -g 9999 aid_nobody'>>$mpath/users.sh
echo 'groupadd -g 10000 aid_app_start'>>$mpath/users.sh
echo 'groupadd -g 19999 aid_app_end'>>$mpath/users.sh
echo 'groupadd -g 20000 aid_cache_gid_start'>>$mpath/users.sh
echo 'groupadd -g 29999 aid_cache_gid_end'>>$mpath/users.sh
echo 'groupadd -g 30000 aid_ext_gid_start'>>$mpath/users.sh
echo 'groupadd -g 39999 aid_ext_gid_end'>>$mpath/users.sh
echo 'groupadd -g 40000 aid_ext_cache_gid_start'>>$mpath/users.sh
echo 'groupadd -g 49999 aid_ext_cache_gid_end'>>$mpath/users.sh
echo 'groupadd -g 50000 aid_shared_gid_start'>>$mpath/users.sh
echo 'groupadd -g 59999 aid_shared_gid_end'>>$mpath/users.sh
echo 'groupadd -g 65534 aid_overflowuid'>>$mpath/users.sh
echo 'groupadd -g 99000 aid_isolated_start'>>$mpath/users.sh
echo 'groupadd -g 99999 aid_isolated_end'>>$mpath/users.sh
echo 'groupadd -g 100000 aid_user_offset'>>$mpath/users.sh


echo ''>>$mpath/users.sh
echo ''>>$mpath/users.sh
}


givepermissions()
{

if [[ $username == "root" ]]
then
echo root
else
echo 'echo "=>> Creating user account "'>>$mpath/users.sh
echo 'adduser '$username>>$mpath/users.sh
fi

echo 'echo "=>> Adding your user to permission groups"'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_system'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_radio'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_bluetooth'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_graphics'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_input'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_audio'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_camera'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_log'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_compass'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_mount'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_wifi'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_adb'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_install'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_media'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_dhcp'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_sdcard_rw'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_vpn'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_keystore'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_usb'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_drm'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_mdnsr'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_gps'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_media_rw'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_mtp'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_drmrpc'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_nfc'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_sdcard_r'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_clat'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_loop_radio'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_media_drm'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_package_info'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_sdcard_pics'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_sdcard_av'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_sdcard_all'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_logd'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_shared_relro'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_dbus'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_tlsdate'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_media_ex'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_audioserver'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_metrics_coll'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_metricsd'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_webserv'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_debuggerd'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_media_codec'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_cameraserver'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_firewall'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_trunks'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_nvram'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_dns'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_dns_tether'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_webview_zygote'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_vehicle_network'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_media_audio'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_media_video'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_media_image'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_tombstoned'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_media_obb'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_ese'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_ota_update'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_automotive_evs'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_lowpan'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_hsm'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_reserved_disk'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_statsd'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_incidentd'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_secure_element'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_lmkd'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_llkd'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_iorapd'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_gpu_service'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_network_stack'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_shell'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_cache'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_diag'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_oem_reserved_start'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_oem_reserved_end'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_net_bt_admin'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_net_bt'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_inet'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_net_raw'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_net_admin'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_net_bw_stats'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_net_bw_acct'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_readproc'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_wakelock'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_uhid'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_everybody'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_misc'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_nobody'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_app_start'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_app_end'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_cache_gid_start'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_cache_gid_end'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_ext_gid_start'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_ext_gid_end'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_ext_cache_gid_start'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_ext_cache_gid_end'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_shared_gid_start'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_shared_gid_end'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_overflowuid'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_isolated_start'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_isolated_end'>>$mpath/users.sh
echo 'gpasswd -a '$username' aid_user_offset'>>$mpath/users.sh
}

#LINUX CONFIGS ---------END


#BOOT TOOLS --------------BEGIN


boot()   #req vars fulpath mpath fs
#INBUILT FUNCTION TO BOOT ANY IMAGE WITH INTERACTIVE MOOD
{
export agentloc=$mpath/root/trap.sh
export isinit=true
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
echo configlink $@ $action
chroot  $mpath/ /bin/bash /root/trap.sh configlink $@ $action
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
if [[ $1$action == "login" ]] 
then
clear
su $2 $3 $4 $5 $6 $7 $8 $9
elif [[ $1 == "run" ]]
then
clear
$2 $3 $4 $5 $6 $7 $8 $9
elif [[ $1 == "install" ]] 
then
clear
apt-get install $2 $3 $4 $5 $6 $7 $8 $9
pete
elif [[ $1 == "custom" ]] 
then
$2 
$3 
$4 
$5 
$6 
$7 
$8 
$9
clear
fi
echo "Exiting Linux"
exit

}

addpermissiongroups()
{
#It Gives Linux Some Permissions To Be Able To Use Android Resources 
echo "Setting Up user And Permissions In Linux****************************************************************************************************"
echo "Creating User Permissions Script"
#!/bin/sh
echo "=> Adding android groups for various permissions "

groupadd -g 1000 aid_system
groupadd -g 1001 aid_radio
groupadd -g 1002 aid_bluetooth
groupadd -g 1003 aid_graphics
groupadd -g 1004 aid_input
groupadd -g 1005 aid_audio
groupadd -g 1006 aid_camera
groupadd -g 1007 aid_log
groupadd -g 1008 aid_compass
groupadd -g 1009 aid_mount
groupadd -g 1010 aid_wifi
groupadd -g 1011 aid_adb
groupadd -g 1012 aid_install
groupadd -g 1013 aid_media
groupadd -g 1014 aid_dhcp
groupadd -g 1015 aid_sdcard_rw
groupadd -g 1016 aid_vpn
groupadd -g 1017 aid_keystore
groupadd -g 1018 aid_usb
groupadd -g 1019 aid_drm
groupadd -g 1020 aid_mdnsr
groupadd -g 1021 aid_gps
groupadd -g 1023 aid_media_rw
groupadd -g 1024 aid_mtp
groupadd -g 1026 aid_drmrpc
groupadd -g 1027 aid_nfc
groupadd -g 1028 aid_sdcard_r
groupadd -g 1029 aid_clat
groupadd -g 1030 aid_loop_radio
groupadd -g 1031 aid_media_drm
groupadd -g 1032 aid_package_info
groupadd -g 1033 aid_sdcard_pics
groupadd -g 1034 aid_sdcard_av
groupadd -g 1035 aid_sdcard_all
groupadd -g 1036 aid_logd
groupadd -g 1037 aid_shared_relro
groupadd -g 1038 aid_dbus
groupadd -g 1039 aid_tlsdate
groupadd -g 1040 aid_media_ex
groupadd -g 1041 aid_audioserver
groupadd -g 1042 aid_metrics_coll
groupadd -g 1043 aid_metricsd
groupadd -g 1044 aid_webserv
groupadd -g 1045 aid_debuggerd
groupadd -g 1046 aid_media_codec
groupadd -g 1047 aid_cameraserver
groupadd -g 1048 aid_firewall
groupadd -g 1049 aid_trunks
groupadd -g 1050 aid_nvram
groupadd -g 1051 aid_dns
groupadd -g 1052 aid_dns_tether
groupadd -g 1053 aid_webview_zygote
groupadd -g 1054 aid_vehicle_network
groupadd -g 1055 aid_media_audio
groupadd -g 1056 aid_media_video
groupadd -g 1057 aid_media_image
groupadd -g 1058 aid_tombstoned
groupadd -g 1059 aid_media_obb
groupadd -g 1060 aid_ese
groupadd -g 1061 aid_ota_update
groupadd -g 1062 aid_automotive_evs
groupadd -g 1063 aid_lowpan
groupadd -g 1064 aid_hsm
groupadd -g 1065 aid_reserved_disk
groupadd -g 1066 aid_statsd
groupadd -g 1067 aid_incidentd
groupadd -g 1068 aid_secure_element
groupadd -g 1069 aid_lmkd
groupadd -g 1070 aid_llkd
groupadd -g 1071 aid_iorapd
groupadd -g 1072 aid_gpu_service
groupadd -g 1073 aid_network_stack
groupadd -g 2000 aid_shell
groupadd -g 2001 aid_cache
groupadd -g 2002 aid_diag
groupadd -g 2900 aid_oem_reserved_start
groupadd -g 2999 aid_oem_reserved_end
groupadd -g 3001 aid_net_bt_admin
groupadd -g 3002 aid_net_bt
groupadd -g 3003 aid_inet
groupadd -g 3004 aid_net_raw
groupadd -g 3005 aid_net_admin
groupadd -g 3006 aid_net_bw_stats
groupadd -g 3007 aid_net_bw_acct
groupadd -g 3009 aid_readproc
groupadd -g 3010 aid_wakelock
groupadd -g 3011 aid_uhid
groupadd -g 9997 aid_everybody
groupadd -g 9998 aid_misc
groupadd -g 9999 aid_nobody
groupadd -g 10000 aid_app_start
groupadd -g 19999 aid_app_end
groupadd -g 20000 aid_cache_gid_start
groupadd -g 29999 aid_cache_gid_end
groupadd -g 30000 aid_ext_gid_start
groupadd -g 39999 aid_ext_gid_end
groupadd -g 40000 aid_ext_cache_gid_start
groupadd -g 49999 aid_ext_cache_gid_end
groupadd -g 50000 aid_shared_gid_start
groupadd -g 59999 aid_shared_gid_end
groupadd -g 65534 aid_overflowuid
groupadd -g 99000 aid_isolated_start
groupadd -g 99999 aid_isolated_end
groupadd -g 100000 aid_user_offset


}


addusername()
{
if [[ $username == "" ]]
then
echo "$C Enter User Name For Linux Installation$G"
read username
fi
echo "=> Creating user account "
adduser $username
addpermissiongroups
echo "=>> Adding your user to permission groups"

gpasswd -a $username aid_system
gpasswd -a $username aid_radio
gpasswd -a $username aid_bluetooth
gpasswd -a $username aid_graphics
gpasswd -a $username aid_input
gpasswd -a $username aid_audio
gpasswd -a $username aid_camera
gpasswd -a $username aid_log
gpasswd -a $username aid_compass
gpasswd -a $username aid_mount
gpasswd -a $username aid_wifi
gpasswd -a $username aid_adb
gpasswd -a $username aid_install
gpasswd -a $username aid_media
gpasswd -a $username aid_dhcp
gpasswd -a $username aid_sdcard_rw
gpasswd -a $username aid_vpn
gpasswd -a $username aid_keystore
gpasswd -a $username aid_usb
gpasswd -a $username aid_drm
gpasswd -a $username aid_mdnsr
gpasswd -a $username aid_gps
gpasswd -a $username aid_media_rw
gpasswd -a $username aid_mtp
gpasswd -a $username aid_drmrpc
gpasswd -a $username aid_nfc
gpasswd -a $username aid_sdcard_r
gpasswd -a $username aid_clat
gpasswd -a $username aid_loop_radio
gpasswd -a $username aid_media_drm
gpasswd -a $username aid_package_info
gpasswd -a $username aid_sdcard_pics
gpasswd -a $username aid_sdcard_av
gpasswd -a $username aid_sdcard_all
gpasswd -a $username aid_logd
gpasswd -a $username aid_shared_relro
gpasswd -a $username aid_dbus
gpasswd -a $username aid_tlsdate
gpasswd -a $username aid_media_ex
gpasswd -a $username aid_audioserver
gpasswd -a $username aid_metrics_coll
gpasswd -a $username aid_metricsd
gpasswd -a $username aid_webserv
gpasswd -a $username aid_debuggerd
gpasswd -a $username aid_media_codec
gpasswd -a $username aid_cameraserver
gpasswd -a $username aid_firewall
gpasswd -a $username aid_trunks
gpasswd -a $username aid_nvram
gpasswd -a $username aid_dns
gpasswd -a $username aid_dns_tether
gpasswd -a $username aid_webview_zygote
gpasswd -a $username aid_vehicle_network
gpasswd -a $username aid_media_audio
gpasswd -a $username aid_media_video
gpasswd -a $username aid_media_image
gpasswd -a $username aid_tombstoned
gpasswd -a $username aid_media_obb
gpasswd -a $username aid_ese
gpasswd -a $username aid_ota_update
gpasswd -a $username aid_automotive_evs
gpasswd -a $username aid_lowpan
gpasswd -a $username aid_hsm
gpasswd -a $username aid_reserved_disk
gpasswd -a $username aid_statsd
gpasswd -a $username aid_incidentd
gpasswd -a $username aid_secure_element
gpasswd -a $username aid_lmkd
gpasswd -a $username aid_llkd
gpasswd -a $username aid_iorapd
gpasswd -a $username aid_gpu_service
gpasswd -a $username aid_network_stack
gpasswd -a $username aid_shell
gpasswd -a $username aid_cache
gpasswd -a $username aid_diag
gpasswd -a $username aid_oem_reserved_start
gpasswd -a $username aid_oem_reserved_end
gpasswd -a $username aid_net_bt_admin
gpasswd -a $username aid_net_bt
gpasswd -a $username aid_inet
gpasswd -a $username aid_net_raw
gpasswd -a $username aid_net_admin
gpasswd -a $username aid_net_bw_stats
gpasswd -a $username aid_net_bw_acct
gpasswd -a $username aid_readproc
gpasswd -a $username aid_wakelock
gpasswd -a $username aid_uhid
gpasswd -a $username aid_everybody
gpasswd -a $username aid_misc
gpasswd -a $username aid_nobody
gpasswd -a $username aid_app_start
gpasswd -a $username aid_app_end
gpasswd -a $username aid_cache_gid_start
gpasswd -a $username aid_cache_gid_end
gpasswd -a $username aid_ext_gid_start
gpasswd -a $username aid_ext_gid_end
gpasswd -a $username aid_ext_cache_gid_start
gpasswd -a $username aid_ext_cache_gid_end
gpasswd -a $username aid_shared_gid_start
gpasswd -a $username aid_shared_gid_end
gpasswd -a $username aid_overflowuid
gpasswd -a $username aid_isolated_start
gpasswd -a $username aid_isolated_end
gpasswd -a $username aid_user_offset

echo "New user can now have all permisdions"
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


#INSTALLER FUNC-----------------------------------BEGIN

installer()
{
echo "which mode installer will you preffer (old/new)"
read inp
installerextcom
installerint$inp

}

installerextcom()
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
tar -xvf $dpath -C $mpath
echo "$B Extraction Complete "

}

installerintnew()
{
umount $mpath
export action="custom instinternal"
boot 
export mpath=$mpathw
accessscriptnew #req mpath fulpath fs
}


instinternal()
{
echo $chuser the usee
read
export username=$chuser
addusername
export username=root
addusername

# A fix for apt package manager
apt_fix

if [[ ! -d /etc/initiallisedux7/ ]]
then
mkdir /etc/initiallisedux7/
fi
echo "user setup ">>/etc/initiallisedux7/usersetup
echo "=> Done"

}


apt_fix()
{
    gpasswd -a aid_inet _apt
    usermod -g aid_inet _apt
}


installerintold()
{
echo "$C Enter User Name For Linux Installation$G"
read username
cls
makepermissions
givepermissions     #req mpath
export username=root
givepermissions      #req mpath

# A fix for apt package manager
echo "echo Alllying apt fix" >>$mpath/users.sh
echo 'gpasswd -a aid_inet _apt ;usermod -g aid_inet _apt'>>$mpath/users.sh  



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


#INSTALLER FUNC-----------------------------------END


#MENU INTERFACE --------------------*-**BEGIN

#chkroot

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
installer
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
internalconfig
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
internalconfig
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
fiho $1 $2
$@
fi
