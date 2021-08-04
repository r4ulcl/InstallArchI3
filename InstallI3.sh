#!/bin/bash

if [ "$EUID" -eq 0 ]
  then echo "Please run as user"
  exit
fi

# https://mudrii.medium.com/arch-linux-installation-on-hw-with-i3-windows-manager-part-2-x-window-system-and-i3-installation-86735e55a0a0

#disable Intel Integrated Graphics Controller
echo "install i915 /bin/false" | sudo tee --append /etc/modprobe.d/blacklist.conf
cat /etc/modprobe.d/blacklist.conf

# Update
sudo pacman -Syyuu --noconfirm --needed && \
yay -Syyuu

# install terminal
sudo pacman -S cmake freetype2 fontconfig pkg-config make libxcb libxkbcommon
sudo pacman -S  --noconfirm --needed alacritty
sudo pacman -S  --noconfirm --needed mate-terminal #backup

# Installing Xorg packages, i3 and video drivers
#if nvidia
# sudo pacman -S nvidia nvidia-utils nvidia-settings xorg-server xorg-apps xorg-xinit i3 numlockx --noconfirm --needed

sudo pacman -S  --noconfirm --needed xf86-video-intel mesa    # Intel
sudo pacman -S xorg-server xorg-apps xorg-xinit i3 numlockx --noconfirm --needed

# Display manager
sudo pacman -S lightdm lightdm-gtk-greeter --noconfirm --needed


#Additional fonts
sudo pacman -S noto-fonts ttf-ubuntu-font-family ttf-dejavu ttf-freefont ttf-liberation ttf-droid ttf-inconsolata ttf-roboto terminus-font ttf-font-awesome --noconfirm --needed

# Sound 
sudo pacman -S alsa-utils alsa-plugins alsa-lib pavucontrol --noconfirm --needed

#i3 blocks
sudo pacman -S i3blocks --noconfirm --needed
git clone https://github.com/vivien/i3blocks-contrib ~/.config/i3blocks
cd !$
cp config.example config

chmod +x -R ~/.config/i3blocks

#dependencies 
sudo pacman -S xdotool yad --noconfirm --needed #calendar
sudo pacman -S xdotool acpi --noconfirm --needed #batterybar
sudo pacman -S arandr tk --noconfirm --needed #monitor_manager
# dmenu
pacman -S dmenu --noconfirm --needed

yay -S --noconfirm --needed i3exit


# Configure lightdm
grep 'autologin-user=\|autologin-session=\|greeter-session=' /etc/lightdm/lightdm.conf && \
sudo sed -i 's/#autologin-user=/autologin-user=$USER/g' /etc/lightdm/lightdm.conf && \
sudo sed -i 's/#autologin-session=/autologin-session=i3/g' /etc/lightdm/lightdm.conf && \
sudo sed -i 's/#greeter-session=example-gtk-gnome/greeter-session=lightdm-gtk-greeter/g' /etc/lightdm/lightdm.conf && \
grep 'autologin-user=\|autologin-session=\|greeter-session=' /etc/lightdm/lightdm.conf

# X Window System check
lspci -k | grep -A 2 -E "(VGA|3D)" && \
nvidia-smi && \
nvidia-smi -q -d TEMPERATURE && \
xrandr && \
xrandr --listproviders && \
xdpyinfo | grep dots

# ~/.Xresources

echo '!--------------------------
! ROFI Color theme
! -------------------------
rofi.color-enabled: true
!rofi.color-window: argb:ee273238, #273238, argb:3a1e2529
rofi.color-window:      #000, #000, #000
rofi.color-normal: argb:00273238, #c1c1c1, argb:3a273238, #394249, #ffffff
rofi.color-active: argb:00273238, #80cbc4, argb:3a273238, #394249, #80cbc4
rofi.color-urgent: argb:00273238, #ff1844, argb:3a273238, #394249, #ff1844
rofi.hide-scrollbar:    true
!---------------------------------
! Xft settings
! --------------------------------
!Xft.dpi:        110
Xft.dpi:        109
Xft.antialias:  true
Xft.rgba:       rgb
Xft.hinting:    true
Xft.hintstyle:  hintslight
Xft.autohint:   false
Xft.lcdfilter:  lcddefault
!---------------------------------
! URXVT Terminal config
! --------------------------------
URxvt.depth:                            32
URxvt*termName:                         screen-256color
URxvt*geometry:                         240x84
URxvt.loginShell:                       true
URxvt*scrollColor:                      #777777
URxvt.scrollStyle:                      rxvt
URxvt*scrollTtyKeypress:        true
URxvt*scrollTtyOutput:          false
URxvt*scrollWithBuffer:         true
URxvt*skipScroll:                       true
URxvt*scrollBar:                        false
URxvt*fading:                           30
URxvt*urgentOnBell:                     false
URxvt*visualBell:                       true
URxvt*mapAlert:                         true
URxvt*mouseWheelScrollPage:     true
URxvt.foreground:                       #eeeeee
URxvt.background:                       #000000
URxvt*colorUL:                          yellow
URxvt*underlineColor:           yellow
URxvt.saveLines:                        65535
URxvt.cursorBlink:                      false
URxvt.utf8:                             true
URxvt.locale:                           true
URxvt.letterSpace:              -1
URxvt.font:             xft:monospace:pixelsize=16:style=regular
URxvt.boldFont:         xft:monospace:pixelsize=14:style=bold
! Perl extensions
URxvt.perl-ext-common:     default,matcher
URxvt.matcher.button:      1
URxvt.urlLauncher:         chromium
URxvt.perl-ext-common:          ...,font-size
URxvt.keysym.C-Up:              perl:font-size:increase
URxvt.keysym.C-Down:            perl:font-size:decrease
URxvt.keysym.C-S-Up:            perl:font-size:incglobal
URxvt.keysym.C-S-Down:          perl:font-size:decglobal
URxvt.keysym.Home: \033[1~
URxvt.keysym.End: \033[4~
URxvt.keysym.KP_Home: \033[1~
URxvt.keysym.KP_End:  \033[4~
! Colors
URxvt*background: #000000
URxvt*foreground: #B2B2B2
! black
URxvt*color0:  #000000
URxvt*color8:  #686868
! red
URxvt*color1:  #B21818
URxvt*color9:  #FF5454
! green
URxvt*color2:  #18B218
URxvt*color10: #54FF54
! yellow
URxvt*color3:  #B26818
URxvt*color11: #FFFF54
! blue
URxvt*color4:  #1818B2
URxvt*color12: #5454FF
! purple
URxvt*color5:  #B218B2
URxvt*color13: #FF54FF
! cyan
URxvt*color6:  #18B2B2
URxvt*color14: #54FFFF
! white
URxvt*color7:  #B2B2B2
URxvt*color15: #FFFFFF' > ~/.Xresources

xrdb ~/.Xresources

sudo systemctl enable lightdm && \
sudo systemctl start lightdm

#startx