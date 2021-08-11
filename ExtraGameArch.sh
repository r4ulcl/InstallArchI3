#!/bin/bash

#https://www.chrisatmachine.com/Linux/08-steam-on-linux/

#Enable Multilib
sudo sed -z 's/\#\[multilib\]\n#/\[multilib\]\n/' -i /etc/pacman.conf

#Update
pacman -Syu

#Install Steam
sudo pacman -S steam

# https://github.com/flightlessmango/MangoHud
yay -Sy --noconfirm --needed mangohud-git 
yay -Sy --noconfirm --needed lib32-mangohud-git
cd /tmp
wget https://github.com/flightlessmango/MangoHud/releases/download/v0.6.5/MangoHud-0.6.5.r0.ge42002c.tar.gz
tar -xf MangoHud-0.6.5.r0.ge42002c.tar.gz
cd MangoHud
./mangohud-setup.sh install

echo 'mangohud /path/to/app'

# https://tutorialforlinux.com/2020/02/05/how-to-install-radeon-rx-5700-xt-driver-on-arch-gnu-linux/
read -p "Are you using a an AMD GPU?  y/N" -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo 'Install your drivers mannually'
else
    yay -Sy amdgpu-pro-libgl
    yay -Sy vulkan-amdgpu-pro
    yay -Sy opencl-amdgpu-pro-pal
    yay -Sy opencl-amdgpu-pro-orca
    yay -S rocm-opencl-runtime
    echo "sudo reboot"
fi

pacman -S --noconfirm --needed piper # Game peripherals 