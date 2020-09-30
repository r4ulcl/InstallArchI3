#!/bin/bash

echo "Folders and files configuration"

echo "Creating Directories..."

if [ ! -d "~/.config" ] 
then
    mkdir -p ~/.config
fi

if [ ! -d "~/.vim" ]
then
    mkdir -p ~/.vim
    mkdir -p ~/.vim/undodir
    mkdir -p ~/.vim/swp
    mkdir -p ~/.vim/bundle
fi

if [ ! -d "/etc/pacman.d/hooks" ]
then
    sudo mkdir -p /etc/pacman.d/hooks
fi

echo "Copying Files to HOME ..."

cp .bashrc ~/.
cp .tmux.conf ~/.
cp vimrc ~/.vim
#cp .Xresources ~/.
#cp .xinitrc ~/.

echo "Copying config files to .config folder..."

cp -r config/i3 ~/.config/
cp -r config/Thunar ~/.config/
#cp -r config/fish ~/.config/
cp -r config/i3blocks ~/.config/
cp -r config/termite ~/.config/termite

echo "Copying wallpapers"

if [ ! -d "~/backgrounds" ]
then
    mkdir -p ~/backgrounds
fi

if [ ! -d "/usr/share/backgrounds" ]
then
    sudo mkdir -p /usr/share/backgrounds
fi

cp -r backgrounds/* ~/backgrounds/

#sudo cp -r backgrounds/icons/ backgrounds/background.png /usr/share/backgrounds/

echo "Setting permissions..."

chmod +x ~/.config/i3/bin/*
chmod +x ~/.config/i3blocks/blocks/*

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

sleep 1

echo "Setting some configuration..."
sudo updatedb # Update mlocate db
sudo localectl set-x11-keymap es # Set the keyboard map
# sudo localectl set-x11-keymap colemak

# Config pacman
#sudo cp mirrorupgrade.hook /etc/pacman.d/hooks/
#sudo cp pacman.conf /etc/

# Config ArchStrike
# https://archstrike.org/wiki/setup
    #sudo pacman -Syy --noconfirm --needed
#sudo pacman-key --init
#sudo dirmngr < /dev/null
#sudo wget https://archstrike.org/keyfile.asc
#sudo pacman-key --add keyfile.asc
#sudo pacman-key --lsign-key 9D5F1C051D146843CDA4858BDE64825E7CBC0D51
#sudo rm keyfile.asc

#sudo pacman -S --noconfirm archstrike-keyring
#sudo pacman -S --noconfirm archstrike-mirrorlist

#sudo sed -i 's/.*mirror.archstrike.*/Include = \/etc\/pacman.d\/archstrike-mirrorlist/' /etc/pacman.conf
    #sudo pacman -Syy --noconfirm --needed

#sleep 1

echo "Installing tools with archstrike"
#sudo pacman -S --noconfirm --needed wfuzz dirbuster
#sudo pacman -S --noconfirm --needed burpsuite
#sudo pacman -S --noconfirm --needed crunch cupp-git cewl
#sudo pacman -S --noconfirm --needed netdiscover
#sudo pacman -S --noconfirm --needed dirsearch
#sudo pacman -S --noconfirm --needed hash-identifier
#sudo pacman -S --noconfirm --needed dnsenum sublist3r-git dnsrecon
#sudo pacman -S --noconfirm --needed amass
#sudo pacman -S --noconfirm --needed enum4linux
#sudo pacman -S --noconfirm --needed crackmapexec
#sudo pacman -S --noconfirm --needed wafw00f
#sudo pacman -S --noconfirm --needed whatweb-git
#sudo pacman -S --noconfirm --needed recon-ng-git
#sudo pacman -S --noconfirm --needed shellter
#sudo pacman -S --noconfirm --needed theharvester-git
#sudo pacman -S --noconfirm --needed metagoofil
#sudo pacman -S --noconfirm --needed smtp-user-enum
#sudo pacman -S --noconfirm --needed fierce-git
# For windows
#sudo pacman -S --noconfirm --needed windows-binaries
#sudo pacman -S --noconfirm --needed mimikatz
#sudo pacman -S --noconfirm --needed onesixtyone
# For wifi
#sudo pacman -S --noconfirm --needed wifiphisher-git wifijammer-git

#sleep 1

echo "Installing go tools"
go get -u github.com/projectdiscovery/subfinder/v2/cmd/subfinder
go get -u github.com/projectdiscovery/nuclei/v2/cmd/nuclei
go get -u github.com/projectdiscovery/httpx/cmd/httpx
go get -u github.com/tomnomnom/assetfinder
go get -u github.com/tomnomnom/httprobe
go get -u github.com/tomnomnom/waybackurls
go get -u github.com/ffuf/ffuf
go get -u github.com/lc/gau
go get -u github.com/hakluke/hakrawler
go get -u github.com/OJ/gobuster
go get -u github.com/asciimoo/wuzz

echo "Disabling beep sound"
sudo -- sh -c 'echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf'

echo "Configuring Nice Burpsuite"
sudo -- sh -c 'echo "_JAVA_AWT_WM_NONREPARENTING=1" > /etc/environment'

#echo "Setting fish shell"
#chsh -s $(which fish)
#sudo chsh -s $(which fish)

echo "To configure root files execute:"
echo "sudo -- sh -c 'ln -sf /home/user/.vim /root/.vim'"
echo "sudo -- sh -c 'ln -sf /home/user/.tmux.conf /root/.tmux.conf'"
# Configuration for root
echo "sudo -- sh -c 'ln -sf /home/user/.bashrc /root/.bashrc'"
#echo "sudo -- sh -c 'ln -sf /home/user/.config/fish /root/.config/'"

echo "Remember set up firefox--> about:config --> ui.context_menus.after_mouseup --> true"
echo "Remove InstallArch Directory"
echo "Reboot, open vim and execute :PluginInstall"
