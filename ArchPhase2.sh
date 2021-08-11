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

read -p "Do you want refind? recommended usign dual boot y/N" -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo 'No refind, just boot loader'
    echo "title Arch Linux
    linux /vmlinuz-linux
    initrd /intel-ucode.img
    initrd /initramfs-linux.img
    options cryptdevice=UUID=$UUID:luks:allow-discards root=/dev/mapper/luks rootflags=subvol=@ rd.luks.options=discard rw" > /boot/loader/entries/arch.conf

    echo 'default  arch.conf
    timeout  4
    console-mode max
    editor   no' >> /boot/loader/loader.conf
else
    # Use refind to Dual Boot with Windows
    #https://wiki.archlinux.org/title/REFInd#Installation_with_refind-install_script
    sudo pacman -S --noconfirm --needed refind
    sudo refind-install

    echo '
    "Boot Arch"          "root=/dev/mapper/luks cryptdevice=UUID='$UUID':luks:allow-discards rw rootflags=subvol=@ rd.luks.options=discard"
    ' > /boot/refind_linux.conf

    sed -i 's/timeout 20/timeout 5/g' /boot/EFI/refind/refind.conf
    #sed -i 's/#hideui all/hideui all/g' /boot/EFI/refind/refind.conf #security
    sed -i 's/#enable_mouse/enable_mouse/g' /boot/EFI/refind/refind.conf
    #sed -i 's/#default_selection Microsoft/default_selection "LUKS Arch Linux"/g' /boot/EFI/refind/refind.conf


    echo '
    menuentry "LUKS Arch Linux" {
    icon /EFI/refind/icons/os_arch.png
    volume '$UUID'
    # Use the Linux kernel as the EFI loader
    loader vmlinuz-linux
    initrd initramfs-linux.img
    options "root=/dev/mapper/luks cryptdevice=UUID='$UUID':luks:allow-discards rw rootflags=subvol=@ rd.luks.options=discard"
    submenuentry "Boot using fallback initramfs" {
            initrd /boot/initramfs-linux-fallback.img
        }
        submenuentry "Boot to terminal" {
            add_options "systemd.unit=multi-user.target"
        }
    }
    ' >> /boot/EFI/refind/refind.conf

fi

#https://wiki.archlinux.org/title/Dm-crypt/Device_encryption#With_a_keyfile_stored_on_an_external_media
echo  "Keyfile embedded in the initramfs (Don't ask for LUKS password on boot) WARNING: USE FULL DISK (/boot) ENCRYPTION"
echo "For form information: https://wiki.archlinux.org/title/Dm-crypt/Device_encryption#With_a_keyfile_stored_on_an_external_media"
read -p "Do you want key file?  y/N" -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo 'No key file'
else
    echo 'key file'
    dd bs=512 count=4 if=/dev/random of=/crypto_keyfile.bin iflag=fullblock
    chmod 600 /crypto_keyfile.bin
    chmod 600 /boot/initramfs-linux*
    cryptsetup luksAddKey $DISKLUKS /crypto_keyfile.bin
    echo 'FILES=(/crypto_keyfile.bin)' >> /etc/mkinitcpio.conf

    # Recreate initramfs:
    mkinitcpio -p linux

fi

# TODO https://wiki.archlinux.org/title/YubiKey
# https://github.com/agherzan/yubikey-full-disk-encryption#usage


systemctl enable NetworkManager.service

read -p "Do you want ssh server enabled?  y/N" -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo 'No ssh server'
else
    systemctl enable sshd.service
fi

exit

