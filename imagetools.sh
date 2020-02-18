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


