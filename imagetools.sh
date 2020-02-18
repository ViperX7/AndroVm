#IMAGE TOOLS ------BEGIN


lodevctrl()
# Gives an unused loop Device. If none are present creates a new one
# used to link a file to the block device
{
    nxtLoopDev=$(busybox losetup -f)
    if [ -b $nxtLoopDev ]
    then
        echo " A Free Loop device exists"
        if [[ $1 == "new" ]]
        then
            echo "Ignoring the existing device on users request"
        else
            echo "Using Existing Loop device :"$nxtLoopDev
            newLoopDev=nxtLoopDev
            return 0;
        fi
    else
        echo "No Free Loop Device Exist Creating a new one"
        busybox mknod $nxtLoopDev b 7 $(busybox losetup -f|tail -n 1 |tail -c 2)
        if [[ $? -eq 0 ]]
        then
            echo "Device Creation Compleated"
            return 0
        else
            echo "Unable to setup loop device"
            return 1
        fi
    fi
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
