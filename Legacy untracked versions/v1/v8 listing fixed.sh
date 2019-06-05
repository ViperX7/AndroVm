echo "Creating Loop Device 1 "
busybox mknod /dev/block/loop277 b 7 277
echo "Device Creation Compleated"
echo "Creating Loop Device 2"
busybox mknod /dev/block/loop278 b 7 278
clear 
echo "       Enter your choice"
echo "       "
echo "       "
echo " 100. XPRESS INSTALL (Recommended)"
echo " 1. PRINT SYSTEM REQUIREMENTS"
echo " 2. DOWNLOAD DEBIAN BASE"
echo " 3. CREATE AN IMAGE FILE AND FORMAT IT"
echo " 4. INSTALL DISTRO INSIDE IMAGE FILE"
echo " 5. MOUNT THE IMAGE ONLY"
echo " 6. CREATE ACCESS SCRIPTS"
echo " 7. FORMAT AN EXISTING IMAGE "
echo " 8. CONFIGURE X SERVER FOR RUNNING NATIVELY"
echo " 9. ABOUT AND HELP"
echo " 0. EXIT"
read iput
echo $iput

# PRINT BASIC REQUIREMENTS FOR THIS SCRIPT TO WORK 

if [[ "$iput" -eq 1 ]] then
clear
echo "SYSTEM REQUIREMENTS "
echo "   "
echo "=> Root Access  "
echo "=> Run This Script As Root"
echo "=> Kernel Should Support Loop Device (most devices have this by default)"
echo "=> Terminal Emulator "
echo "=>BusyBox Installed"
echo "=> Minimum Free Space 256 MB [Recommended 1.5Gb for non desktop users 2.5Gb for desktop users using lxde xfce and mate] "
echo ""
echo " Press Enter To Get Back To The Main Menu"
read iput
echo $iput

#PROVIDE LINK TO VARIOUS SEBIAN BASED DISTROS

elif [[ "$iput" -eq 2 ]] then
clear
echo "Debian Jessie ">>/sdcard/debian.txt
echo "copied">>/sdcard/debian.txt
echo "Ubuntu">>/sdcard/debian.txt
echo "copied">>/sdcard/debian.txt
echo "KALI linux">>/sdcard/debian.txt
echo "copied">>/sdcard/debian.txt
clear
echo "Link Of Debian Base Has been"
echo "Coppied in /sdcard/desbian.txt"
echo " Press Enter To Get Back To The Main Menu"
read iput
echo $iput
#__________________________________________
#ASK FOR PATH TO CREATE FILE 
#ASK FOR SIZE OF IMAGE
# ASK FOR NAME OF IMAGE
#ASK FOR FILESYSTEM OF IMAGE
#__________________________________________
#CREATE IMAGE BASED ON USER INPUT
elif [[ "$iput" -eq 3 ]] then
clear
echo "Where Do i create file input path"
read impath
echo "Give size of image in MB"
read siz
echo "Enter Name Of New Image eg.( debian.img)"
read imname
echo " Enter The FileSystem You Want In Image File "
echo " Don't Choose vfat If You Are Installing Linux It Wont Work"
echo "Choose Out Of"
echo "vfat"
echo "ext2"
echo "ext3"
echo "ext4"
read fs
echo "It May Take Some Time Depending Upon Size Of Image"
echo "If you Saw Any Error in FileSystem Implementation "
echo "Choose ext2 It  Will Work Fine"
echo "Creating Image With Selected FileSystem "
echo "==>Making Image********************"
busybox dd if=/dev/zero of=$impath/$imname bs=1M count=$siz
echo "==>Implementating FileSystem ********************"
mkfs.$fs -F $impath/$imname
echo ""
echo " Press Enter To Get Back To The Main Menu"
read iput
echo $iput

#ASK FOR PATH AND FILESYSTEM OF IMAGE
#ASK USERNAME TO BE USED
#ASK LOCATION OF DEBIAN PACKAGES
#INSTALL LINUX IN THE IMAGE AS A CHROOT
elif [[ "$iput" -eq 4 ]] then
clear
echo "Enter Full Path Of The Image"
read fulpath
echo "Enter FileSystem Of Image "
read fs
echo "Enter User Name For Linux Installation"
read chuser
export mpath="/sdcard/debian_tmp"
mkdir  $mpath
echo "Removing Any Previous Image"
losetup -d /dev/bolck/loop278
echo "Setting New Image "
busybox losetup /dev/block/loop278 $fulpath
echo "Mounting "$fulpath At $mpath
busybox mount -o rw,sync -t $fs /dev/block/loop278 $mpath
echo busybox mount -o rw,sync -t $fs /dev/block/loop278 $mpath
read me
echo "Enter Path Of Debian Package ie downloaded from step two if you dont see an error"
read dpath 
echo "It May Take Some Time In Extracting System"
tar -xzvf $dpath -C $mpath
mv /sdcard/debian_tmp/Debian/* /sdcard/debian_tmp/
mv /sdcard/debian_tmp/ubuntu/* /sdcard/debian_tmp/
mv /sdcard/debian_tmp/kali/* /sdcard/debian_tmp/
echo "Extraction Complete "
#It Gives Linux Some Permissions To Be Able To Use Android Resources 
echo "Setting Up user And Permissions In Linux****************************************************************************************************"
echo "Creating User Permissions Script"
echo '#!/bin/sh'>>$mpath/users.sh
echo 'echo "=>> Creating user account "'>>$mpath/users.sh
echo 'adduser '$chuser>>$mpath/users.sh
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
echo 'echo "=>> Adding root user to permission groups"'>>$mpath/users.sh
echo 'gpasswd -a root aid_net_bt_admin'>>$mpath/users.sh
echo 'gpasswd -a root aid_net_bt'>>$mpath/users.sh
echo 'gpasswd -a root aid_inet'>>$mpath/users.sh
echo 'gpasswd -a root aid_inet_raw'>>$mpath/users.sh
echo 'gpasswd -a root aid_inet_admin'>>$mpath/users.sh
echo 'gpasswd -a root aid_net_bw_stats'>>$mpath/users.sh
echo 'gpasswd -a root aid_net_bw_acct'>>$mpath/users.sh
echo 'gpasswd -a root aid_net_bt_stack'>>$mpath/users.sh
echo 'gpasswd -a root adm'>>$mpath/users.sh
echo 'gpasswd -a root sudo'>>$mpath/users.sh
echo 'gpasswd -a root admin'>>$mpath/users.sh
echo 'gpasswd -a root aid_graphics'>>$mpath/users.sh
echo 'gpasswd -a root aid_input'>>$mpath/users.sh
echo 'gpasswd -a root aid_log'>>$mpath/users.sh
echo 'gpasswd -a root aid_mount'>>$mpath/users.sh
echo 'gpasswd -a root aid_wifi'>>$mpath/users.sh
echo 'gpasswd -a root aid_sdcard_rw'>>$mpath/users.sh
echo 'gpasswd -a root aid_usb'>>$mpath/users.sh
echo 'gpasswd -a root aid_mdnsr'>>$mpath/users.sh
echo 'gpasswd -a root aid_media_rw'>>$mpath/users.sh
echo 'gpasswd -a root aid_sdcard_r'>>$mpath/users.sh
echo 'gpasswd -a root aid_sdcard_all'>>$mpath/users.sh
echo 'gpasswd -a root aid_shell'>>$mpath/users.sh
echo ''>>$mpath/users.sh
echo''>>$mpath/users.sh
echo 'echo "=>> Adding your user to permission groups"'>>$mpath/users.sh
echo 'gpasswd -a '$chuser' aid_net_bt_admin'>>$mpath/users.sh
echo 'gpasswd -a '$chuser' aid_net_bt'>>$mpath/users.sh
echo 'gpasswd -a '$chuser' aid_inet'>>$mpath/users.sh
echo 'gpasswd -a '$chuser' aid_inet_raw'>>$mpath/users.sh
echo 'gpasswd -a '$chuser' aid_inet_admin'>>$mpath/users.sh
echo 'gpasswd -a '$chuser' aid_net_bw_stats'>>$mpath/users.sh
echo 'gpasswd -a '$chuser' aid_net_bw_acct'>>$mpath/users.sh
echo 'gpasswd -a '$chuser' aid_net_bt_stack'>>$mpath/users.sh
echo 'gpasswd -a '$chuser' adm'>>$mpath/users.sh
echo 'gpasswd -a '$chuser' sudo'>>$mpath/users.sh
echo 'gpasswd -a '$chuser' admin'>>$mpath/users.sh
echo 'gpasswd -a '$chuser' aid_graphics'>>$mpath/users.sh
echo 'gpasswd -a '$chuser' aid_input'>>$mpath/users.sh
echo 'gpasswd -a '$chuser' aid_log'>>$mpath/users.sh
echo 'gpasswd -a '$chuser' aid_mount'>>$mpath/users.sh
echo 'gpasswd -a '$chuser' aid_wifi'>>$mpath/users.sh
echo 'gpasswd -a '$chuser' aid_sdcard_rw'>>$mpath/users.sh
echo 'gpasswd -a '$chuser' aid_usb'>>$mpath/users.sh
echo 'gpasswd -a '$chuser' aid_mdnsr'>>$mpath/users.sh
echo 'gpasswd -a '$chuser' aid_media_rw'>>$mpath/users.sh
echo 'gpasswd -a '$chuser' aid_sdcard_r'>>$mpath/users.sh
echo 'gpasswd -a '$chuser' aid_sdcard_all'>>$mpath/users.sh
echo 'gpasswd -a '$chuser' aid_shell'>>$mpath/users.sh
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
#This Is The Script To Be Used By User To Log In
echo "Creating Boot Script**************************************************************************************************************************"
echo '#!/bin/bash'>>$mpath/root/tap.sh
echo 'export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/sbin'>>$mpath/root/tap.sh
echo 'export TERM=linux'>>$mpath/root/tap.sh
echo 'export HOME=/root'>>$mpath/root/tap.sh
echo 'dpkg-divert --local --rename --add /sbin/initctl>>/dev/null 2>&1'>>$mpath/root/tap.sh
echo 'ln -s /bin/true /sbin/initctl > /dev/null 2>&1'>>$mpath/root/tap.sh
echo 'if [ $1 == "login" ]; '>>$mpath/root/tap.sh
echo 'then'>>$mpath/root/tap.sh
echo 'clear'>>$mpath/root/tap.sh
echo 'su $2'>>$mpath/root/tap.sh
echo 'elif [ $1 == "run" ];'>>$mpath/root/tap.sh
echo 'then'>>$mpath/root/tap.sh
echo 'clear'>>$mpath/root/tap.sh
echo '$2 $3 $4 $5 $6 $7 $8 $9'>>$mpath/root/tap.sh
echo 'elif [ $1 == "install" ]; '>>$mpath/root/tap.sh
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
echo "Now Go To Main Menu And Select 6 To Use your Linux"
echo " Press Enter To Get Back To The Main Menu"
read iput
echo $iput
umount  $mpath


#ASK AND MOUNT IMAGE TO MAKE DESIRED CHANGES
elif [[ "$iput" -eq 5 ]] then
clear
echo "Enter Full Path Of The Image"
read fulpath
echo "Enter place to mount image eg (/sdcard/something )"
read mpath
echo "Enter FileSystem Of Image "
read fs
echo "Creating Image Mount Path Under $mpath"
mkdir $mpath
echo "Removing Any Previous Image"
losetup -d /dev/bolck/loop277
echo "Setting New Image "
busybox losetup /dev/block/loop277 $fulpath
echo "Mounting $fulpath At $mpath"
busybox mount -o rw,sync -t $fs /dev/block/loop277 $mpath
echo "Press Enter To Unmount Image And Go To Main Menu"
read dpath
umount $mpath
echo "It May Take Some Time"
echo $iput

#CREATE SCRIPT TO START LINUX DISTRO 
elif [[ "$iput" -eq 6 ]] then
clear
echo "Enter Full Path Of The Image"
read fulpath
echo "Enter place to mount image eg (/sdcard/something )"
read mpath
echo "Enter FileSystem Of Image "
read fs
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


elif [[ "$iput" -eq 7 ]] then
echo "Enter Full Path Of Image File"
read directpath
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
mkfs.$fs -F $directpath
echo "Operation Compleated"
read iii



#AUTOMATICALLY CONFIGURE  XORG SERVER AND RUN ON DEVICE NATIVELY 
elif [[ "$iput" -eq 8 ]] then
echo you must install xorg by using apt-get install
echo "Enter Full Path Of The Image"
read fulpath
export mpath=/cache/debian_tmp
echo "Enter FileSystem Of Image "
read fs
mkdir $mpath


echo "Removing Any Previous Image"
losetup -d /dev/bolck/loop277
echo "Setting New Image "
busybox losetup /dev/block/loop277 $fulpath
echo "Mounting "$fulpath At $mpath
busybox mount -o rw,sync -t $fs /dev/block/loop277 $mpath
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




***********************************************
#OPTIMISED INSTALLER 
elif [[ "$iput" -eq 100 ]] then
clear
echo "Where Do i create file input path"
read impath
echo "Give size of image in MB"
read siz
echo "provide location of the package"
read dpath
export imname=linux
export fs=ext2
export fulpath=$impath/linux.img
echo "Enter User Name For Linux Installation"
read chuser
export mpath="/sdcard/debian_tmp"
mkdir  $mpath
mkdir $impath
echo "It May Take Some Time Depending Upon Size Of Image"
echo "Creating Image With ext2 FileSystem "
echo "==>Making Image********************"
busybox dd if=/dev/zero of=$fulpath bs=1M count=$siz
echo "==>Implementating FileSystem ********************"
mkfs.$fs -F $fulpath

echo "Removing Any Previous Image"
losetup -d /dev/bolck/loop278
echo "Setting New Image "
busybox losetup /dev/block/loop278 $fulpath
echo "Mounting "$fulpath At $mpath
busybox mount -o rw,sync -t $fs /dev/block/loop278 $mpath
echo busybox mount -o rw,sync -t $fs /dev/block/loop278 $mpath
read me

echo "It May Take Some Time Extracting System"
tar -xzvf $dpath -C $mpath
mv /sdcard/debian_tmp/Debian/* /sdcard/debian_tmp/
mv /sdcard/debian_tmp/ubuntu/* /sdcard/debian_tmp/
echo "Extraction Complete "
echo "Setting Up user And Permissions In Linux****************************************************************************************************"
echo "Creating User Permissions Script"
echo '#!/bin/sh'>>$mpath/users.sh
echo 'echo "=>> Creating user account "'>>$mpath/users.sh
echo 'adduser '$chuser>>$mpath/users.sh
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
echo 'echo "=>> Adding root user to permission groups"'>>$mpath/users.sh
echo 'gpasswd -a root aid_net_bt_admin'>>$mpath/users.sh
echo 'gpasswd -a root aid_net_bt'>>$mpath/users.sh
echo 'gpasswd -a root aid_inet'>>$mpath/users.sh
echo 'gpasswd -a root aid_inet_raw'>>$mpath/users.sh
echo 'gpasswd -a root aid_inet_admin'>>$mpath/users.sh
echo 'gpasswd -a root aid_net_bw_stats'>>$mpath/users.sh
echo 'gpasswd -a root aid_net_bw_acct'>>$mpath/users.sh
echo 'gpasswd -a root aid_net_bt_stack'>>$mpath/users.sh
echo 'gpasswd -a root adm'>>$mpath/users.sh
echo 'gpasswd -a root sudo'>>$mpath/users.sh
echo 'gpasswd -a root admin'>>$mpath/users.sh
echo 'gpasswd -a root aid_graphics'>>$mpath/users.sh
echo 'gpasswd -a root aid_input'>>$mpath/users.sh
echo 'gpasswd -a root aid_log'>>$mpath/users.sh
echo 'gpasswd -a root aid_mount'>>$mpath/users.sh
echo 'gpasswd -a root aid_wifi'>>$mpath/users.sh
echo 'gpasswd -a root aid_sdcard_rw'>>$mpath/users.sh
echo 'gpasswd -a root aid_usb'>>$mpath/users.sh
echo 'gpasswd -a root aid_mdnsr'>>$mpath/users.sh
echo 'gpasswd -a root aid_media_rw'>>$mpath/users.sh
echo 'gpasswd -a root aid_sdcard_r'>>$mpath/users.sh
echo 'gpasswd -a root aid_sdcard_all'>>$mpath/users.sh
echo 'gpasswd -a root aid_shell'>>$mpath/users.sh
echo ''>>$mpath/users.sh
echo''>>$mpath/users.sh
echo 'echo "=>> Adding your user to permission groups"'>>$mpath/users.sh
echo 'gpasswd -a '$chuser' aid_net_bt_admin'>>$mpath/users.sh
echo 'gpasswd -a '$chuser' aid_net_bt'>>$mpath/users.sh
echo 'gpasswd -a '$chuser' aid_inet'>>$mpath/users.sh
echo 'gpasswd -a '$chuser' aid_inet_raw'>>$mpath/users.sh
echo 'gpasswd -a '$chuser' aid_inet_admin'>>$mpath/users.sh
echo 'gpasswd -a '$chuser' aid_net_bw_stats'>>$mpath/users.sh
echo 'gpasswd -a '$chuser' aid_net_bw_acct'>>$mpath/users.sh
echo 'gpasswd -a '$chuser' aid_net_bt_stack'>>$mpath/users.sh
echo 'gpasswd -a '$chuser' adm'>>$mpath/users.sh
echo 'gpasswd -a '$chuser' sudo'>>$mpath/users.sh
echo 'gpasswd -a '$chuser' admin'>>$mpath/users.sh
echo 'gpasswd -a '$chuser' aid_graphics'>>$mpath/users.sh
echo 'gpasswd -a '$chuser' aid_input'>>$mpath/users.sh
echo 'gpasswd -a '$chuser' aid_log'>>$mpath/users.sh
echo 'gpasswd -a '$chuser' aid_mount'>>$mpath/users.sh
echo 'gpasswd -a '$chuser' aid_wifi'>>$mpath/users.sh
echo 'gpasswd -a '$chuser' aid_sdcard_rw'>>$mpath/users.sh
echo 'gpasswd -a '$chuser' aid_usb'>>$mpath/users.sh
echo 'gpasswd -a '$chuser' aid_mdnsr'>>$mpath/users.sh
echo 'gpasswd -a '$chuser' aid_media_rw'>>$mpath/users.sh
echo 'gpasswd -a '$chuser' aid_sdcard_r'>>$mpath/users.sh
echo 'gpasswd -a '$chuser' aid_sdcard_all'>>$mpath/users.sh
echo 'gpasswd -a '$chuser' aid_shell'>>$mpath/users.sh
#THE LINE BELOW REMOVES THE USER _apt BECAUSE  IT CAUSES SOME PROBLEMS DURING PACKAGES/SOFTWARE INSTALLING
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
echo "Boot Script Created***************************************************************************************************************************"
#This Is The Script To Be Used By User To Log In
echo "Creating Boot Script**************************************************************************************************************************"
echo '#!/bin/bash'>>$mpath/root/tap.sh
echo 'export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/sbin'>>$mpath/root/tap.sh
echo 'export TERM=linux'>>$mpath/root/tap.sh
echo 'export HOME=/root'>>$mpath/root/tap.sh
echo 'dpkg-divert --local --rename --add /sbin/initctl>>/dev/null 2>&1'>>$mpath/root/tap.sh
echo 'ln -s /bin/true /sbin/initctl > /dev/null 2>&1'>>$mpath/root/tap.sh
echo 'if [ $1 == "login" ]; '>>$mpath/root/tap.sh
echo 'then'>>$mpath/root/tap.sh
echo 'clear'>>$mpath/root/tap.sh
echo 'su $2'>>$mpath/root/tap.sh
echo 'elif [ $1 == "run" ];'>>$mpath/root/tap.sh
echo 'then'>>$mpath/root/tap.sh
echo 'clear'>>$mpath/root/tap.sh
echo '$2 $3 $4 $5 $6 $7 $8 $9'>>$mpath/root/tap.sh
echo 'elif [ $1 == "install" ]; '>>$mpath/root/tap.sh
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
echo "Now Go To Main Menu And Select 6 To Use your Linux filesystem is ext2"
echo " Press Enter To Get Back To The Main Menu"
read iput
echo $iput
umount  $mpath








#EXIT SCRIPT
elif [[ "$iput" -eq 0 ]] then
echo $iput
clear && exit

else
sh /sdcard/u.sh
clear && exit
fi
sh u.sh
clear && exit


