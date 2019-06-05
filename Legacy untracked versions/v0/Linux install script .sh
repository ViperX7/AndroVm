
clear 
echo "       Enter your choice"
echo "       "
echo "       "

echo " 1. PRINT SYSTEM REQUIREMENTS"
echo " 2. DOWNLOAD DEBIAN BASE"
echo " 3. CREATE AN IMAGE FILE AND FORMAT IT"
echo " 4. INSTALL DEBIAN INSIDE IMAGE FILE"
echo " 5. MOUNT THE IMAGE ONLY"
echo " 6. INSTALL ESSENTIALS"
echo " 7. ADD AN USER ACCOUNT"
echo " 8. CREATE ACCESS SCRIPT AGAIN"
echo " 9. ABOUT AND HELP"
echo " 0. EXIT"
read iput
echo $iput
if [[ "$iput" -eq 1 ]] then
clear
echo "SYSTEM REQUIREMENTS "
echo "   "
echo "=> Root Access  "
echo "=> Run This Script As Root"
echo "=> Kernel Should Support Loop Device (most devices have this by default)"
echo "=> Terminal Emulator "
echo "=>BusyBox Installed"
echo "=> Minimum Free Space 256 MB [Recommended 1
5Gb for non desktop users 2.5Gb for desktop users using lxde xfce and mate] "
echo ""
echo " Press Enter To Get Back To The Main Menu"
read iput
echo $iput
elif [[ "$iput" -eq 2 ]] then
clear
echo "copied">>/sdcard/debian.txt
clear
echo "Link Of Debian Base Has been"
echo "Coppied in /sdcard/desbian.txt"
echo " Press Enter To Get Back To The Main Menu"
read iput
echo $iput
elif [[ "$iput" -eq 3 ]] then
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
echo "Mounting $fulpath At $mpath"
mount -o loop,rw,sync -t $fs $fulpath $mpath
echo "Enter Path Of Debian Package ie downloaded from step two"
read dpath 
echo "It May Take Some Time Extracting System"
tar -xzvf $dpath -C $mpath
echo "Extraction Complete "

echo "Setting Up user And Permissions In Linux****************************************************************************************************"
echo "Creating User Permissions Script"
echo '#!/bin/sh' >$mpath/users.sh
echo 'export chusr=$chuser' >$mpath/users.sh
echo 'echo "=> Creating user account "' >$mpath/users.sh
echo 'adduser $chusr' >$mpath/users.sh
echo 'echo "=> Adding android groups for various permissions "' >$mpath/users.sh
echo 'groupadd -g 1003 aid_graphics' >$mpath/users.sh
echo 'groupadd -g 1004 aid_input' >$mpath/users.sh
echo 'groupadd -g 1007 aid_log' >$mpath/users.sh
echo 'groupadd -g 1009 aid_mount' >$mpath/users.sh
echo 'groupadd -g 1010 aid_wifi' >$mpath/users.sh
echo 'groupadd -g 1011 aid_adb' >$mpath/users.sh
echo 'groupadd -g 1015 aid_sdcard_rw' >$mpath/users.sh
echo 'groupadd -g 1018 aid_usb' >$mpath/users.sh
echo 'groupadd -g 1020 aid_mdnsr' >$mpath/users.sh
echo 'groupadd -g 1023 aid_media_rw' >$mpath/users.sh
echo 'groupadd -g 1028 aid_sdcard_r' >$mpath/users.sh
echo 'groupadd -g 1035 aid_sdcard_all' >$mpath/users.sh
echo 'groupadd -g 2000 aid_shell' >$mpath/users.sh
echo 'groupadd -g 3001 aid_net_bt_admin' >$mpath/users.sh
echo 'groupadd -g 3002 aid_net_bt' >$mpath/users.sh
echo 'groupadd -g 3003 aid_inet' >$mpath/users.sh
echo 'groupadd -g 3004 aid_inet_raw' >$mpath/users.sh
echo 'groupadd -g 3005 aid_inet_admin' >$mpath/users.sh
echo 'groupadd -g 3006 aid_net_bw_stats' >$mpath/users.sh
echo 'groupadd -g 3007 aid_net_bw_acct' >$mpath/users.sh
echo 'groupadd -g 3008 aid_net_bt_stack' >$mpath/users.sh   
echo '' >$mpath/users.sh
echo '' >$mpath/users.sh
echo 'echo "=> Adding root user to permission groups"' >$mpath/users.sh
echo 'gpasswd -a root aid_net_bt_admin' >$mpath/users.sh
echo 'gpasswd -a root aid_net_bt' >$mpath/users.sh
echo 'gpasswd -a root aid_inet' >$mpath/users.sh
echo 'gpasswd -a root aid_inet_raw' >$mpath/users.sh
echo 'gpasswd -a root aid_inet_admin' >$mpath/users.sh
echo 'gpasswd -a root aid_net_bw_stats' >$mpath/users.sh
echo 'gpasswd -a root aid_net_bw_acct' >$mpath/users.sh
echo 'gpasswd -a root aid_net_bt_stack' >$mpath/users.sh
echo 'gpasswd -a root adm' >$mpath/users.sh
echo 'gpasswd -a root sudo' >$mpath/users.sh
echo 'gpasswd -a root admin' >$mpath/users.sh
echo 'gpasswd -a root aid_graphics' >$mpath/users.sh
echo 'gpasswd -a root aid_input' >$mpath/users.sh
echo 'gpasswd -a root aid_log' >$mpath/users.sh
echo 'gpasswd -a root aid_mount' >$mpath/users.sh
echo 'gpasswd -a root aid_wifi' >$mpath/users.sh
echo 'gpasswd -a root aid_sdcard_rw' >$mpath/users.sh
echo 'gpasswd -a root aid_usb' >$mpath/users.sh
echo 'gpasswd -a root aid_mdnsr' >$mpath/users.sh
echo 'gpasswd -a root aid_media_rw' >$mpath/users.sh
echo 'gpasswd -a root aid_sdcard_r' >$mpath/users.sh
echo 'gpasswd -a root aid_sdcard_all' >$mpath/users.sh
echo 'gpasswd -a root aid_shell' >$mpath/users.sh
echo '' >$mpath/users.sh
echo'' >$mpath/users.sh
echo 'echo "=> Adding your user to permission groups"' >$mpath/users.sh
echo 'gpasswd -a $chusr aid_net_bt_admin' >$mpath/users.sh
echo 'gpasswd -a $chusr aid_net_bt' >$mpath/users.sh
echo 'gpasswd -a $chusr aid_inet' >$mpath/users.sh
echo 'gpasswd -a $chusr aid_inet_raw' >$mpath/users.sh
echo 'gpasswd -a $chusr aid_inet_admin' >$mpath/users.sh
echo 'gpasswd -a $chusr aid_net_bw_stats' >$mpath/users.sh
echo 'gpasswd -a $chusr aid_net_bw_acct' >$mpath/users.sh
echo 'gpasswd -a $chusr aid_net_bt_stack' >$mpath/users.sh
echo 'gpasswd -a $chusr adm' >$mpath/users.sh
echo 'gpasswd -a $chusr sudo' >$mpath/users.sh
echo 'gpasswd -a $chusr admin' >$mpath/users.sh
echo 'gpasswd -a $chusr aid_graphics' >$mpath/users.sh
echo 'gpasswd -a $chusr aid_input' >$mpath/users.sh
echo 'gpasswd -a $chusr aid_log' >$mpath/users.sh
echo 'gpasswd -a $chusr aid_mount' >$mpath/users.sh
echo 'gpasswd -a $chusr aid_wifi' >$mpath/users.sh
echo 'gpasswd -a $chusr aid_sdcard_rw' >$mpath/users.sh
echo 'gpasswd -a $chusr aid_usb' >$mpath/users.sh
echo 'gpasswd -a $chusr aid_mdnsr' >$mpath/users.sh
echo 'gpasswd -a $chusr aid_media_rw' >$mpath/users.sh
echo 'gpasswd -a $chusr aid_sdcard_r' >$mpath/users.sh
echo 'gpasswd -a $chusr aid_sdcard_all' >$mpath/users.sh
echo 'gpasswd -a $chusr aid_shell' >$mpath/users.sh
echo 'mkdir /etc/initiallisedux7/' >$mpath/users.sh
echo 'echo "user setup " >>/etc/initiallisedux7/usersetup' >$mpath/users.sh
echo 'echo "=> Done"' >$mpath/users.sh
echo 'Press Enter And Type Exit'
echo 'read s' >$mpath/users.sh
echo 'echo' >$mpath/users.sh
echo "Permission Script Completed*******************************************************************************************************************"
echo ""
echo ""
echo ""
echo "Creating Boot Script**************************************************************************************************************************"
echo '#!/bin/bash' >>$mpath/tap.sh
echo 'export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/sbin'>>$mpath/tap.sh
echo 'export TERM=linux'>>$mpath/tap.sh
echo 'export HOME=/root'>>$mpath/tap.sh
echo 'dpkg-divert --local --rename --add /sbin/initctl > /dev/null 2>&1'>>$mpath/tap.sh
echo 'ln -s /bin/true /sbin/initctl > /dev/null 2>&1'>>$mpath/tap.sh
echo '/bin/bash /users.sh'>>$mpath/tap.sh
echo 'echo "Exiting Linux"'>>$mpath/tap.sh
echo 'exit'>>$mpath/tap.sh
echo "Boot Script Created***************************************************************************************************************************"
echo "Creating Boot Script**************************************************************************************************************************"
echo '#!/bin/bash' >>$mpath/root/tap.sh
echo 'export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/sbin'>>$mpath/root/tap.sh
echo 'export TERM=linux'>>$mpath/root/tap.sh
echo 'export HOME=/root'>>$mpath/root/tap.sh
echo 'dpkg-divert --local --rename --add /sbin/initctl > /dev/null 2>&1'>>$mpath/root/tap.sh
echo 'ln -s /bin/true /sbin/initctl > /dev/null 2>&1'>>$mpath/root/tap.sh
echo 'Enter Your User Name'>>$mpath/root/tap.sh
echo 'read u'>>$mpath/root/tap.sh
echo '/bin/bash su $u'>>$mpath/root/tap.sh
echo 'echo "Exiting Linux"'>>$mpath/root/tap.sh
echo 'exit'>>$mpath/root/tap.sh
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
chroot  $mpath/ /tpa.sh
echo "=>unmounting /dev/pts"
umount $mpath/dev/pts
echo "=>unmounting /proc "
umount $mpath/proc
echo "=>unmounting /sys"
umount $mpath/sys
echo "=>unmounting /dev"
umount $mpath/dev
echo "=>unmounting chroot image "
echo "Now Go To Main Menu And Select 6 To Use your Linux"
echo " Press Enter To Get Back To The Main Menu"
read iput
echo $iput
umount  $mpath
elif [[ "$iput" -eq 5 ]] then
echo "Enter Full Path Of The Image"
read fulpath
echo "Enter place to mount image eg (/sdcard/something )"
read mpath
echo "Enter FileSystem Of Image "
read fs
echo "Creating Image Mount Path Under $mpath"
mkdir $mpath
echo "Mounting $fulpath At $mpath"
mount -o loop,rw,sync -t $fs $fulpath $mpath
echo "Press Enter To Unmount Image And Go To Main Menu"
read dpath
umount $mpath
echo "It May Take Some Time"
echo $iput
elif [[ "$iput" -eq 6 ]] then
echo "Enter Full Path Of The Image"
read fulpath
echo "Enter place to mount image eg (/sdcard/something )"
read mpath
echo "Enter FileSystem Of Image "
read fs
echo "Creating ACCESS SCRIPT************************************************************************************************************************"
echo 'echo "=>mounting chroot image"'>>/sdcard/boot.sh
echo 'mount -o loop,rw,sync -t $fs $fulpath $mpath'>>/sdcard/boot.sh
echo 'echo "mounting /dev"'>>/sdcard/boot.sh
echo 'mount -o bind /dev /cache/local/mnt/dev'>>/sdcard/boot.sh
echo '"=>mounting /dev/pts"'>>/sdcard/boot.sh
echo 'mount -t devpts devpts /cache/local/mnt/dev/pts'>>/sdcard/boot.sh
echo 'echo "=>mounting /proc "'>>/sdcard/boot.sh
echo 'mount -t proc proc /cache/local/mnt/proc'>>/sdcard/boot.sh
echo 'echo "=>mounting sys"'>>/sdcard/boot.sh
echo 'mount -t sysfs sysfs /cache/local/mnt/sys'>>/sdcard/boot.sh
echo 'echo "=>fireing up chroot environment "'>>/sdcard/boot.sh
echo 'chroot  /cache/local/mnt/ /root/boot.sh'>>/sdcard/boot.sh
echo 'echo "=>unmounting /dev/pts"'>>/sdcard/boot.sh
echo 'umount /cache/local/mnt/dev/pts'>>/sdcard/boot.sh
echo 'echo "=>unmounting /proc "'>>/sdcard/boot.sh
echo 'umount /cache/local/mnt/proc'>>/sdcard/boot.sh
echo 'echo "=>unmounting /sys"'>>/sdcard/boot.sh
echo 'umount /cache/local/mnt/sys'>>/sdcard/boot.sh
echo 'echo "=>unmounting /dev"'>>/sdcard/boot.sh
echo 'umount cache/local/mnt/dev'>>/sdcard/boot.sh
echo 'echo "=>unmounting chroot image "'>>/sdcard/boot.sh
echo 'umount /cache/local/mnt'>>/sdcard/boot.sh
echo "Access Script Created*****************"
echo "Anytime To Use Your Linux Type This In terminal 'sh /sdcard/boot.sh'"
elif [[ "$iput" -eq 0 ]] then
echo $iput
exit
else
sh /sdcard/u.sh
fi
sh /sdcard/u.sh


