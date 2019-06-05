cls()
{
clear 
color
banner
}
color()
{
export R='\033[1;31m'
export B='\033[1;34m'
export C='\033[0;36m'
export G='\033[1;32m'
export W='\033[1;37m'
export Y='\033[1;33m'
}
banner()
{
if [[ isabt == "true" ]] then
clear
echo $B"       ############################################"
echo $B"       ##          $Y" Ux7 Linux Installer "$B         ##  "
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
echo $B"##                  $Y" Ux7 Linux Installer "$B                 ##"
echo $B"############################################################ "
echo 
echo $W
fi
}


#IMAGE TOOLS ------BEGIN


lodevinit()
{
echo "Creating Loop Device 1 "
busybox mknod /dev/block/loop277 b 7 277
echo "Device Creation Compleated"
echo "Creating Loop Device 2"
busybox mknod /dev/block/loop278 b 7 278
cls
}

imgmenu()
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
if [[ "$iput" -eq 1 ]] then
imgmake
elif [[ "$iput" -eq 2 ]] then
imgmount
elif [[ "$iput" -eq 3 ]] then
imgformat
elif [[ "$iput" -eq 4 ]] then
exit
fi
}

imgformat()
{
lodevinit
echo "Enter Full Path Of Image File"
read fulpath
echo "Removing Any Previous Image"
losetup -d /dev/bolck/loop277
echo "Setting New Image "
busybox losetup /dev/block/loop277 $fulpath
echo "Enter filesystem of image"
echo " Enter The FileSystem You Want In Image File "
echo " Don't Choose vfat If You Are Installing Linux It Wont Work"
echo "Choose Out Of"
echo "vfat"
echo "ext2"
echo "ext3"
echo "ext4"
read fs
echo "If you Saw Any Error in FileSystem Implementation "
echo "Choose ext2 It  Will Work Fine"
mkfs.$fs /dev/block/loop277
echo "Operation Compleated"
read iii

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
if [[ $isini == "" ]] then
lodevinit
cls
echo "Where Do i create file input path(eg. /sdcard/"
read impath
cls
echo "Give size of image in MB"
read siz
cls
echo "Enter Name Of New Image eg.( debian.img)"
read imname
cls
echo " Enter The FileSystem You Want In Image File "
echo " Don't Choose vfat If You Are Installing Linux It Wont Work"
echo "Choose Out Of"
echo "vfat"
echo "ext2"
echo "ext3"
echo "ext4"
echo "exfat"
read fs
fi
cls
echo "It May Take Some Time Depending Upon Size Of Image"
echo "If you Saw Any Error in FileSystem Implementation "
echo "Choose ext2 It  Will Work Fine"
echo "Creating Image With Selected FileSystem "
echo "==>Making Image********************"
busybox dd if=/dev/zero of=$impath/$imname bs=1M count=$siz
echo "==>Implementating FileSystem ********************"
echo "Removing Any Previous Image"
losetup -d /dev/bolck/loop277
echo "Setting New Image "
busybox losetup /dev/block/loop277 $impath$imname
mkfs.$fs /dev/block/loop277
echo ""
echo " Press Enter To Get Back To The Main Menu"
export newimgpath=$impath$imname
read iput
echo $iput
cls
}




imgmount()     #req vars "fulpath mpath fs"
{
#ASK AND MOUNT IMAGE TO MAKE DESIRED CHANGES
cls
lodevinit
if [[ $isinit == "" ]] then
echo "Enter Full Path Of The Image"
read fulpath
echo "Enter place to mount image eg (/sdcard/something )"
read mpath
echo "Enter FileSystem Of Image "
read fs
fi
echo "Creating Image Mount Path Under $mpath"
mkdir $mpath
echo "Removing Any Previous Image"
losetup -d /dev/bolck/loop277
echo "Setting New Image "
busybox losetup /dev/block/loop277 $fulpath
echo "Mounting $fulpath At $mpath"
busybox mount -o rw,sync -t $fs /dev/block/loop277 $mpath
if [[ isinit == "" ]] then
echo "Press Enter To Unmount Image And Go To Main Menu"
read dpath
umount $mpath
echo "It May Take Some Time To Unmount"
echo $iput
fi
}

#IMAGE TOOLS ------END











#LINUX CONFIGS ---------BEGIN

confmenu()
{
cls
echo "$R WELCOME TO MAIN MENU $Y"
echo " Type item no. and press enter."
echo "     $G 1$C. Create Access Script"
echo "     $G 2$C. Recreate Internal Access Script"
echo "     $G 3$C. Configure Xorg Files"
echo "     $G 4$C. Exit"
echo ""
echo ""
echo "Enter Choice  :$G"
read iput
if [[ "$iput" -eq 1 ]] then
accessscript
elif [[ "$iput" -eq 2 ]] then
internalconfig
elif [[ "$iput" -eq 3 ]] then
xorgconfl
elif [[ "$iput" -eq 4 ]] then
exit
fi
}


confxorg()   #req vars " fulpath fs"
{
#AUTOMATICALLY CONFIGURE  XORG SERVER AND RUN ON DEVICE NATIVELY 
if [[ isinit == "" ]] then
echo you must install xorg by using apt-get install
echo "Enter Full Path Of The Image"
read fulpath
echo "Enter FileSystem Of Image "
read fs
fi

export mpath=/cache/debian_tmp
mkdir $mpath

export isinit="true"
imgmount



mkdir $mpath/etc/X11
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





accessscript ()
{
#CREATE SCRIPT TO START LINUX DISTRO 
if [[ isinit == "" ]] then
clear
echo "Enter Full Path Of The Image"
read fulpath
echo "Enter place to mount image eg (/sdcard/something )"
read mpath
echo "Enter FileSystem Of Image "
read fs
fi
echo "Creating ACCESS SCRIPT************************************************************************************************************************"
rm /sdcard/boot.sh
echo "echo prepairing directory">>/sdcard/boot.sh
echo "mkdir "$mpath>>/sdcard/boot.sh
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
echo 'echo "=>mounting storage"'>>/sdcard/boot.sh
echo 'mount -o bind /sdcard '$mpath'/sdcard'>>/sdcard/boot.sh
echo 'echo "=>fireing up chroot environment "'>>/sdcard/boot.sh
echo 'chroot  '$mpath'/ /root/tap.sh $@'>>/sdcard/boot.sh
echo 'PREFIX='$mpath>>/sdcard/boot.sh
echo 'FOUND=0'>>/sdcard/boot.sh
echo ''>>/sdcard/boot.sh
echo 'for ROOT in /proc/*/root; do'>>/sdcard/boot.sh
echo '    LINK=$(readlink $ROOT)'>>/sdcard/boot.sh
echo '    if [ "x$LINK" != "x" ]; then'>>/sdcard/boot.sh
echo '        if [ "x${LINK:0:${#PREFIX}}" = "x$PREFIX" ]; then'>>/sdcard/boot.sh
echo '            PID=$(basename $(dirname "$ROOT"))'>>/sdcard/boot.sh
echo '            kill -9 "$PID"'>>/sdcard/boot.sh
echo '            FOUND=1'>>/sdcard/boot.sh
echo '        fi'>>/sdcard/boot.sh
echo '    fi'>>/sdcard/boot.sh
echo 'done'>>/sdcard/boot.sh
echo ''>>/sdcard/boot.sh
echo '   if [ "x$FOUND" = "x1" ]; then'>>/sdcard/boot.sh
echo '   echo found # repeat the above, the script Im cargo-culting this from just re-execs itself'>>/sdcard/boot.sh
echo '   fi'>>/sdcard/boot.sh
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
echo "Access Script Created*****************"
echo "Anytime To Use Your Linux Type This In terminal 'sh /sdcard/boot.sh'"
read iput
echo $iput
}





internalconfig()
{
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







permissions()
{
#It Gives Linux Some Permissions To Be Able To Use Android Resources 
echo "Setting Up user And Permissions In Linux****************************************************************************************************"
echo "Creating User Permissions Script"
echo '#!/bin/sh'>>$mpath/users.sh
echo 'echo "=>> Creating user account "'>>$mpath/users.sh
echo 'adduser '$username>>$mpath/users.sh
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

}


#LINUX CONFIGS ---------END





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

#SMALL FUNC ------------END


linuxinst()
{
#ASK FOR PATH AND FILESYSTEM OF IMAGE IF NOT AVAILABLE GIVE OPTION TO MAKE A NEW ONE
#ASK USERNAME TO BE USED
#ASK LOCATION OF DEBIAN PACKAGES IF NOT AVAILABLE GIVE OPTION TO DOWNLOAD A NEW ONE
#INSTALL LINUX IN THE IMAGE AS A CHROOT
cls
echo "Enter Full Path Of The Image ."
echo "If you dont have one type newimg and press enter"
read fulpath
cls
if [[ $fulpath == "newimg" ]] then
imgmake     #req nothing here
export fulpath=$newimgpath
export fs=$fs
else 
echo "Enter FileSystem Of Image "
read fs
fi
echo "Enter User Name For Linux Installation"
read chuser

export isinit=true
export mpath="/sdcard/debian_tmp"
echo "Enter Location To Mount Your Linux. if unsure anout this option type /cache/linux"
read mpathw
imgmount     #req mpath fs fulpath
cls
echo "Enter Path Of Linux Base. if you dont have them type getbase and press enter "
read dpath
if [[ dpath == "getbase" ]] then
getbase
echo ""
echo""
echo ""
echo "Enter Path Of Linux Base. if you dont have them type getbase and press enter "
read dpath
fi

echo "It May Take Some Time In Extracting System Base"
tar -xzvf $dpath -C $mpath
mv /sdcard/debian_tmp/Debian/* /sdcard/debian_tmp/
mv /sdcard/debian_tmp/Ubuntu/* /sdcard/debian_tmp/
mv /sdcard/debian_tmp/Kali/* /sdcard/debian_tmp/
echo "Extraction Complete "

export username=$chuser
permissions     #req mpath
export username=root
permissions      #req mpath





#this user _apt cause package installation problems so i removed it 
echo 'deluser _apt'>>$mpath/users.sh
echo 'mkdir /etc/initiallisedux7/'>>$mpath/users.sh
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
read iput
echo $iput
umount  $mpath

export mpath=$mpathw
accessscript #req mpath fulpath fs

}

menu()
{
cls
echo "$R WELCOME TO MAIN MENU $Y"
echo " Type item no. and press enter."
echo "     $G 1$C. Linux installer"
echo "     $G 2$C. Image Tools"
echo "     $G 3$C. Linux Configuration"
echo "     $G 4$C. Help And Trouble Shooting"
echo "     $G 5$C. About"
echo "     $G 6$C. Exit"
echo ""
echo ""
echo "Enter Choice  :$G"
read iput
if [[ "$iput" -eq 1 ]] then
linuxinst
elif [[ "$iput" -eq 2 ]] then
imgmenu
elif [[ "$iput" -eq 3 ]] then
confmenu
elif [[ "$iput" -eq 4 ]] then
help
elif [[ "$iput" -eq 5 ]] then
about
elif [[ "$iput" -eq 6 ]] then
exit
fi
}



help()
{
export isabt=true
banner
echo "$R WELCOME TO HELP MENU $W"
echo " Type item no. and press enter "
echo "     1. Get Linux Base"
echo "     2. Create Image File"
echo "     3. Mount An Image File "
echo "     4. Recreate  external access script (boot.sh) after changing image file"
echo "     5. Recreate internal access script (/root/tap.sh) after accidentally removing it"
echo "     6. "


}

#COMMAND LINE ACCEPTORS
if [[ $@ == "" ]] then
menu
exit
elif [[ $@ == "linuxinst" ]] then
linuxinst
exit
elif [[ $@ == "imgmount" ]] then
imgmount
exit
elif [[ $@ == "imgmake" ]] then
imgmake
exit
elif [[ $@ == "confxorg" ]] then
confxorg
exit
elif [[ $@ == "lboot" ]] then
accessscript
exit
elif [[ $@ == "help" ]] then
help
exit
elif [[ $@ == "" ]] then
menu
exit
else
$@
fi