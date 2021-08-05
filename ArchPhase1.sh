#!/bin/bash

fdisk -l | grep dev
echo "Choose disk to write - WARNING, ALL DISK COULD BE DELETE (/dev/sda)"
read DISK   

read -p "Delete all data and use all disk? " -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo
    echo 'Use only free space - WARNING, ALL DISK MAY BE DELETED IF ERROR'

    PARTITION_EFI_NUM=`ls -l ${DISK}* | wc -l`
    PARTITION_LUKS_NUM=`echo "$PARTITION_EFI_NUM + 1" | bc `

    parted ${DISK} print free | grep 'Free Space' > /tmp/free # Get partitions list with Free space
    echo "Choose partition to write, Free Space min 25 GB: (2) TESTING"
    cat -n /tmp/free
    read PARTITION_NUM   

    PARTITION=`sed -n "${PARTITION_NUM}p" < /tmp/free`
    
    START=`echo $PARTITION | awk '{print $1}'`
    END=`echo $PARTITION | awk '{print $2}'`

    NUM_START=`echo $START |  grep '[0-9\.]*' -o`
    BYTE_START=`echo $START | grep -o '..$'`
    NUM_END_EFI=`echo "$NUM_START + 0.550" | bc ` #550MB for EFI
    
    NUM_END=`echo $END |  grep '[0-9\.]*' -o`
    BYTE_END=`echo $END | grep -o '..$'`

    echo 'IT WILL BE EXECUTE:'
    echo parted --script $DISK mkpart EFI fat32 $START $NUM_END_EFI$BYTE_START set $PARTITION_EFI_NUM esp on mkpart crypt ext4 $NUM_END_EFI$BYTE_START $NUM_END$BYTE_END print
    read -p "Are you sure? y/N" -n 1 -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        exit
    fi

    parted --script $DISK \
    mkpart EFI fat32 $START $NUM_END_EFI$BYTE_START \
    set $PARTITION_EFI_NUM esp on \
    mkpart crypt ext4 $NUM_END_EFI$BYTE_START $NUM_END$BYTE_END \
    print

    DISKEFI=${DISK}$PARTITION_EFI_NUM
    DISKLUKS=${DISK}$PARTITION_LUKS_NUM
else
    echo all
    echo 'IT WILL BE EXECUTE:'
    echo parted --script $DISK mklabel gpt mkpart EFI fat32 1MiB 550MiB set 1 esp on mkpart crypt ext4 550MiB 100% print
    read -p "Are you sure? y/N" -n 1 -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        exit
    fi
    # Partitioning
    parted --script $DISK \
    mklabel gpt \
    mkpart EFI fat32 1MiB 550MiB \
    set 1 esp on \
    mkpart crypt ext4 550MiB 100% \
    print

    DISKEFI=${DISK}1
    DISKLUKS=${DISK}2
fi


# Encryption
cryptsetup luksFormat ${DISKLUKS} || exit

# Open luks
cryptsetup open ${DISKLUKS} luks || exit

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
mount -o noatime,nodiratime,compress=zstd,space_cache,ssd,subvol=@ /dev/mapper/luks /mnt
mkdir -p /mnt/{boot,home,var/cache/pacman/pkg,.snapshots,.swapvol,btrfs}
mount -o noatime,nodiratime,compress=zstd,space_cache,ssd,subvol=@home /dev/mapper/luks /mnt/home
mount -o noatime,nodiratime,compress=zstd,space_cache,ssd,subvol=@pkg /dev/mapper/luks /mnt/var/cache/pacman/pkg
mount -o noatime,nodiratime,compress=zstd,space_cache,ssd,subvol=@snapshots /dev/mapper/luks /mnt/.snapshots
# Swap FILE 
mount -o noatime,nodiratime,compress=zstd,space_cache,ssd,subvol=@swap /dev/mapper/luks /.swapvol
mount -o noatime,nodiratime,compress=zstd,space_cache,ssd,subvolid=5 /dev/mapper/luks /mnt/btrfs

# Mount the Boot partition
mkdir /mnt/boot
mount ${DISKEFI} /mnt/boot/

# Base System and /etc/fstab
#sudo rm -f /var/lib/pacman/sync/*
pacman -Syyu --noconfirm --needed
pacstrap /mnt base base-devel linux linux-firmware nano btrfs-progs efibootmgr grub networkmanager openssh git --noconfirm
genfstab -U /mnt >> /mnt/etc/fstab

# System Configuration
cp ./ArchPhase2.sh /mnt/ArchPhase2.sh
arch-chroot /mnt/ bash ./ArchPhase2.sh $DISKLUKS || exit 9

rm /mnt/ArchPhase2.sh

mkdir /mnt/home/user/
cp ../InstallArchI3 /mnt/home/user/ -r
chmod 777 /mnt/home/user/InstallArchI3 -R

# Copy script and execute
# chroot /chroot_dir /bin/bash -c "su - -c ./startup.sh"

## Ins script -> download and exec installi3, download and exesute install config

echo reboot
