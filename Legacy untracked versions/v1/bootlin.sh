mount -o loop,rw,sync -t ext4 /storage/extSdCard/file.img /cache/local/mnt

sysctl -w net.ipv4.ip_forward=1
if [ $? -ne 0 ];then error_exit "Unable to forward network!"; fi

# If NOT /cache/local/mnt/root/DONOTDELETE.txt exists we setup hosts and resolv.conf now
if [ ! -f /cache/local/mnt/root/DONOTDELETE.txt ]; then
	echo "nameserver 8.8.8.8" > /cache/local/mnt/etc/resolv.conf
	if [ $? -ne 0 ];then error_exit "Unable to write resolv.conf file!"; fi
	echo "nameserver 8.8.4.4" >> /cache/local/mnt/etc/resolv.conf
	echo "127.0.0.1 localhost" > /cache/local/mnt/etc/hosts
	if [ $? -ne 0 ];then error_exit "Unable to write hosts file!"; fi
fi


mount -t devpts /dev/pts /cache/local/mnt/dev/pts
mount -t proc proc /cache/local/mnt/proc
mount -t sysfs sysfs /cache/local/mnt/sys
mount -o bind /sdcard /cache/local/mnt/sdcard
mount -o bind /sys/fs/selinux /cache/local/mnt/selinux

chroot /cache/local/mnt /root/init.sh


