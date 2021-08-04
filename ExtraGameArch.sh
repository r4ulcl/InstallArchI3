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