#!/bin/bash

#https://www.chrisatmachine.com/Linux/08-steam-on-linux/

#Enable Multilib
sudo sed -i '/[multilib]/^#//g' /etc/pacman.conf
sudo sed -i '/Include = \/etc\/pacman.d\/mirrorlist/s/^#//g' /etc/pacman.conf

#Update
pacman -Syu

#Install Steam
sudo pacman -S steam

echo 'You can enable Proton in the Steam Client in Steam > Settings > Steam Play'
echo
echo 'To force enable Proton, right click on the game, Properties > General > Force the use of a specific Steam Play compatibility tool'


# UNTESTED
# https://github.com/flightlessmango/MangoHud
yay -Sy --noconfirm --needed mangohud-git 
yay -Sy --noconfirm --needed lib32-mangohud-git
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
    echo "sudo reboot"
fi