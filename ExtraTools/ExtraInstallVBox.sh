#!/bin/bash

sudo pacman -S  --noconfirm --needed virtualbox-guest-utils
modprobe -a vboxguest vboxsf vboxvideo

VBoxClient --clipboard
VBoxClient --draganddrop
VBoxClient --seamless
VBoxClient --checkhostversion
VBoxClient --vmsvga

VBoxClient-all

modprobe vboxdrv