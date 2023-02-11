sudo pacman -Sy --noconfirm --needed feh

sudo mkdir /usr/share/backgrounds
sudo chmod 777 /usr/share/backgrounds -R
cd /usr/share/backgrounds

wget http://archive.ubuntu.com/ubuntu/pool/main/u/ubuntu-wallpapers/ubuntu-wallpapers_18.04.1.orig.tar.gz
tar xvzf ubuntu-wallpapers_18.04.1.orig.tar.gz

echo '
#!/bin/bash
file=$(find /usr/share/backgrounds/ubuntu-wallpapers-18.04.1/*.jpg -type f -print0 | shuf -z -n 1)
feh --bg-scale  $file
' >> /usr/share/backgrounds/randomWallpaper.sh

echo 'exec_always bash /usr/share/backgrounds/randomWallpaper.sh' >> ~/.config/i3/config
bash /usr/share/backgrounds/randomWallpaper.sh
