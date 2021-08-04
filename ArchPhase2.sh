#!/bin/bash

DISKLUKS=$1

# PHASE 3

# Swap File untested
cd /.swapvol
truncate -s 0 main
chattr +C main
btrfs property set main compression none
fallocate -l 16G main
chmod 600 main
mkswap main
swapon main

echo -e '\n#Swap\n /.swapvol/main swap swap defaults 0 0' >> /etc/fstab

echo pc > /etc/hostname

hwclock --systohc --utc

echo LANG=en_US.UTF-8 > /etc/locale.conf

sed -i 's/#es_ES.UTF-8 UTF-8/es_ES.UTF-8 UTF-8/g' /etc/locale.gen
sed -i 's/#es_ES ISO-8859-1/es_ES ISO-8859-1/g' /etc/locale.gen
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
sed -i 's/#en_US ISO-8859-1/en_US ISO-8859-1/g' /etc/locale.gen


locale-gen

loadkeys us


ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime

echo '127.0.0.1 localhost
::1             localhost
127.0.1.1       pc.localdomain  pc' > /etc/hosts

echo 'Password root'
passwd



echo "%wheel ALL=(ALL) ALL" | (EDITOR="tee -a" visudo)

useradd -m -G wheel user
echo 'Password USER'
passwd user

# PHASE 4


pacman -S --noconfirm --needed intel-ucode


# Initramfs

##Configure the creation of initramfs by editing /etc/mkinitcpio.conf. Change the line HOOKS=... to:
##HOOKS=(base udev autodetect modconf block filesystems keyboard fsck)
##HOOKS="base keyboard udev autodetect modconf block keymap encrypt btrfs filesystems"

sed -i 's/HOOKS=(base udev autodetect modconf block filesystems keyboard fsck)/HOOKS="base keyboard udev autodetect modconf block keymap encrypt btrfs filesystems"/g' /etc/mkinitcpio.conf


# Recreate initramfs:

mkinitcpio -p linux



# Boot Manager

bootctl --path=/boot install

UUID=`blkid -s UUID -o value $DISKLUKS` 

echo "title Arch Linux
linux /vmlinuz-linux
initrd /intel-ucode.img
initrd /initramfs-linux.img
options cryptdevice=UUID=$UUID:luks:allow-discards root=/dev/mapper/luks rootflags=subvol=@ rd.luks.options=discard rw" > /boot/loader/entries/arch.conf

echo 'default  arch.conf
timeout  4
console-mode max
editor   no' >> /boot/loader/loader.conf

read -p "Do you want refind? recommended only usign dual boot y/N" -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo 'No refind, just boot loader'
else
    # Use refind to Dual Boot with Windows
    #https://wiki.archlinux.org/title/REFInd#Installation_with_refind-install_script
    sudo pacman -S --noconfirm --needed refind
    sudo refind-install
UUID=`blkid -s UUID -o value /dev/sda2` 

    echo '
    "Boot Arch"          "root=/dev/mapper/luks cryptdevice=UUID='$UUID':luks:allow-discards rw rootflags=subvol=@ rd.luks.options=discard"
    "2Boot to X"          "root=/dev/mapper/luks cryptdevice='$DISKLUKS':cryptroot:allow-discards ro rootfstype=ext4 systemd.unit=graphical.target"
    "2Boot to console"    "root=/dev/mapper/luks cryptdevice='$DISKLUKS':cryptroot:allow-discards  ro rootfstype=ext4 systemd.unit=multi-user.target"
    "Boot with standard options"  "root=UUID='$UUID' initrd=/intel-code.img rw"
' > /boot/refind_linux.conf
fi

systemctl enable NetworkManager.service
systemctl enable sshd.service

exit

