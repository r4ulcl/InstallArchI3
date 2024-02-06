#!/bin/bash

fdisk -l | grep dev
echo "Choose disk to write - WARNING, ALL DISK COULD BE DELETE (/dev/sda)"
read -i "/dev/sda"  DISK 
DISK="${DISK:-/dev/sda}"

# Check the partitions in the answer, dont count using PARTITION_EFI_NUM
read -p "Delete all data and use all disk? y/N " -n 1 -r
echo 
if [[ ! $REPLY =~ ^[Yy]$ ]] # If not
then
    echo
    echo 'Use only free space - WARNING, ALL DISK MAY BE DELETED IF ERROR'

    PARTITION_EFI_NUM=`ls -l ${DISK}* | wc -l` #partition number in disk

    if [[ PARTITION_EFI_NUM -eq 1 ]] ; then # No partition
        echo "Error, not partitions found in disk. Try another disk or use full disk install"
        exit 1
    fi

    parted ${DISK} print free | grep 'Free Space' > /tmp/freeRead # Get partitions list with Free space
    parted ${DISK} unit B print free | grep 'Free Space' > /tmp/free # Get partitions list with Free space
    echo "Choose partition to write, Free Space min 15-35 GB: (2) TESTING"
    cat -n /tmp/freeRead # Readable, with GB, etc
    read PARTITION_NUM   

    PARTITION=`sed -n "${PARTITION_NUM}p" < /tmp/free`
    
    START=`echo $PARTITION | awk '{print $1}'`
    END=`echo $PARTITION | awk '{print $2}'`

    NUM_START=`echo $START |  grep '[0-9\.]*' -o`
    BYTE_EFI=`echo $START | grep -o '.$'`
    NUM_END_EFI=`echo "$NUM_START + 1048576000" | bc ` #1GB for EFI, TODO 550 MB

    NUM_START_LUKS=`echo "$NUM_END_EFI + 512" | bc ` # +1 sector 512B
    BYTE_LUKS=`echo $END | grep -o '.$'`

    echo 'IT WILL BE EXECUTE:'
    echo parted -a optimal --script $DISK mkpart EFI fat32 $START $NUM_END_EFI$BYTE_EFI set $PARTITION_EFI_NUM esp on mkpart crypt ext4 $NUM_START_LUKS$BYTE_LUKS $END print
    read -p "Are you sure? y/N" -n 1 -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        exit
    fi

    PARTED=`parted -a optimal --script $DISK \
    mkpart EFI fat32 $START $NUM_END_EFI$BYTE_EFI \
    set $PARTITION_EFI_NUM esp on \
    mkpart crypt ext4 $NUM_START_LUKS$BYTE_LUKS $END \
    print`

    echo "$PARTED"
    ID_EFI=`echo "$PARTED" | grep EFI | tail -1 | awk '{print $1}'`
    ID_CRYPT=`echo "$PARTED" | grep crypt | tail -1 | awk '{print $1}'`

    if echo $DISK | grep -q 'nvme' ; then
        DISK=${DISK}p
    fi

    echo $DISK

    DISKEFI=${DISK}$ID_EFI
    DISKLUKS=${DISK}$ID_CRYPT
else
    echo all
    echo "Choose de % of the disk to use (default 100)"
    read PERCENT
    PERCENT="${PERCENT:-100}"

    echo 'IT WILL BE EXECUTE:'
    echo parted -a optimal --script $DISK mklabel gpt mkpart EFI fat32 1MiB 550MiB set 1 esp on mkpart crypt ext4 550MiB $PERCENT% print
    read -p "Are you sure? y/N" -n 1 -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        exit
    fi
    # Partitioning
    parted -a optimal --script $DISK \
    mklabel gpt \
    mkpart EFI fat32 1MiB 550MiB \
    set 1 esp on \
    mkpart crypt ext4 550MiB $PERCENT% \
    print

    DISKEFI=${DISK}1
    DISKLUKS=${DISK}2
fi

# Encryption
cryptsetup luksFormat ${DISKLUKS} || exit

# Open luks
cryptsetup open ${DISKLUKS} luks || exit

echo "AFTER THIS, ALL QUESTIONS WILL BE SET TO THE DEFAULT OPTION AFTER 30 SECONDS"

#Get username 
read -p "Write the username (default: user)  " -r -t 30 
USERNAME="${REPLY:-user}"
echo $USERNAME

#Get hostname 
read -p "Write the hostname (default: pc)  " -r -t 30 
HOSTNAME="${REPLY:-pc}"
echo $HOSTNAME

#ASK PASSWORDS
read -s -p "Write the user $USERNAME password (default: toor)  " -r -t 30 
USERPASS="${REPLY:-toor}"
echo 

read -s -p "Write the root password (default: toor)  " -r -t 30 
ROOTPASS="${REPLY:-toor}"
echo



# File System Creation
mkfs.vfat -F32 -n EFI ${DISKEFI}

mkfs.btrfs -L ROOT /dev/mapper/luks

# Create and Mount Subvolumes
mount /dev/mapper/luks /mnt
btrfs sub create /mnt/@
btrfs sub create /mnt/@home
btrfs sub create /mnt/@pkg
btrfs sub create /mnt/@snapshots
# SWAPFILE https://blog.passcod.name/2020/jun/16/full-disk-encryption-with-btrfs-swap-and-hibernation.html
btrfs sub create /mnt/@swap
btrfs sub create /mnt/@btrfs
umount /mnt

# Mount all disks in /mnt
mount -o noatime,nodiratime,compress=zstd,ssd,space_cache=v2,subvol=@ /dev/mapper/luks /mnt
mkdir -p /mnt/{boot,home,var/cache/pacman/pkg,.snapshots,.swapvol,btrfs}
mount -o noatime,nodiratime,compress=zstd,ssd,space_cache=v2,subvol=@home /dev/mapper/luks /mnt/home
mount -o noatime,nodiratime,compress=zstd,ssd,space_cache=v2,subvol=@pkg /dev/mapper/luks /mnt/var/cache/pacman/pkg
mount -o noatime,nodiratime,compress=zstd,ssd,space_cache=v2,subvol=@snapshots /dev/mapper/luks /mnt/.snapshots
# Swap FILE 
mount -o noatime,nodiratime,compress=zstd,ssd,space_cache=v2,subvol=@swap /dev/mapper/luks /mnt/.swapvol
mount -o noatime,nodiratime,compress=zstd,space_cache,ssd,subvolid=5 /dev/mapper/luks /mnt/btrfs

# Mount the Boot partition
mkdir /mnt/boot
mount ${DISKEFI} /mnt/boot/

# Base System and /etc/fstab
sudo rm -f /var/lib/pacman/sync/*
pacman -Syyu --noconfirm --needed
pacstrap /mnt base base-devel linux linux-firmware nano btrfs-progs efibootmgr grub networkmanager openssh git --noconfirm
genfstab -U /mnt >> /mnt/etc/fstab


# System Configuration
cp ./ArchPhase2.sh /mnt/ArchPhase2.sh
arch-chroot /mnt/ bash ./ArchPhase2.sh $DISKLUKS $USERNAME $HOSTNAME $USERPASS $ROOTPASS|| exit 9

rm /mnt/ArchPhase2.sh


mkdir -p /mnt/home/$USERNAME/github/
cp ../InstallArchI3 /mnt/home/$USERNAME/github/ -r
chmod 777 /mnt/home/$USERNAME/github/InstallArchI3 -R

# Copy script and execute
# chroot /chroot_dir /bin/bash -c "su - -c ./startup.sh"

## Ins script -> download and exec installi3, download and exesute install config

 echo -e "\n\nYou can reboot now"