#!/usr/bin/bash

# Config ArchStrike
# https://archstrike.org/wiki/setup

# Modify /etc/pacman.conf
sudo -- sh -c 'echo "" >> /etc/pacman.conf; echo "[archstrike]" >> /etc/pacman.conf; echo "Server = https://mirror.archstrike.org/\$arch/\$repo" >> /etc/pacman.conf'

sudo pacman -Syy

sudo pacman-key --init
sudo dirmngr < /dev/null
sudo wget https://archstrike.org/keyfile.asc
sudo pacman-key --add keyfile.asc
sudo pacman-key --lsign-key 9D5F1C051D146843CDA4858BDE64825E7CBC0D51

sudo pacman -S --noconfirm --needed archstrike-keyring
sudo pacman -S --noconfirm --needed archstrike-mirrorlist

sudo sed -i 's/.*mirror.archstrike.*/Include = \/etc\/pacman.d\/archstrike-mirrorlist/' /etc/pacman.conf
sudo pacman -Syy

sleep 1

echo "Installing tools with archstrike"
sudo pacman -S --noconfirm --needed wfuzz dirbuster
sudo pacman -S --noconfirm --needed burpsuite
sudo pacman -S --noconfirm --needed crunch cupp-git cewl
sudo pacman -S --noconfirm --needed netdiscover
sudo pacman -S --noconfirm --needed dirsearch
sudo pacman -S --noconfirm --needed hash-identifier
sudo pacman -S --noconfirm --needed dnsenum sublist3r-git dnsrecon
sudo pacman -S --noconfirm --needed amass
sudo pacman -S --noconfirm --needed enum4linux
sudo pacman -S --noconfirm --needed crackmapexec
sudo pacman -S --noconfirm --needed wafw00f
sudo pacman -S --noconfirm --needed whatweb-git
sudo pacman -S --noconfirm --needed recon-ng-git
sudo pacman -S --noconfirm --needed shellter
sudo pacman -S --noconfirm --needed theharvester-git
sudo pacman -S --noconfirm --needed metagoofil
sudo pacman -S --noconfirm --needed smtp-user-enum
sudo pacman -S --noconfirm --needed fierce-git
# For windows
sudo pacman -S --noconfirm --needed windows-binaries
sudo pacman -S --noconfirm --needed mimikatz
sudo pacman -S --noconfirm --needed onesixtyone
# For wifi
sudo pacman -S --noconfirm --needed wifiphisher-git wifijammer-git
