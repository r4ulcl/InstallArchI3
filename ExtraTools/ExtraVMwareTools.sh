#!/bin/bash

echo "Introducir disco de las vmware tools"
echo "Seleccionar en vmware VM --> Install VMware Tools Installation"
echo "Pulsar cualquier tecla para continuar una vez realizado esto"
read 
sudo pacman -Syu
sudo pacman -S --noconfirm --needed net-tools linux-headers xf86-input-vmmouse xf86-video-vmware
sudo mkdir -p /etc/init.d/{rc0.d,rc1.d,rc2.d,rc3.d,rc4.d,rc5.d,rc6.d}
sudo mkdir -p /mnt/cdrom
sudo mount /dev/cdrom /mnt/cdrom
sleep 5
tar xf /mnt/cdrom/VMwareTools*.tar.gz -C ~/
sleep 3
sudo perl ~/vmware-tools-distrib/vmware-install.pl
sleep 5
sudo umount /dev/cdrom

##Creamos el servicio y lo activamos para que se ejecute al inicio

sudo cp ./vmwaretools.service /etc/systemd/system/
sleep 5
sudo systemctl enable vmwaretools.service
sudo systemctl start vmwaretools.service

sleep 5

## Sincronizamos la hora con el sistema anfitrion
vmware-toolbox-cmd timesync enable

## Habilitamos la carpeta compartida
## Recordar que hemos creado un alias montar para hacerlo automaticamente luego

if [ ! -d "~/Shared" ] 
then
    mkdir -p ~/Shared
fi

sudo mount -t fuse.vmhgfs-fuse .host:/$(vmware-hgfsclient) ~/Shared/ -o allow_other

## Activamos copiar y pegar entre sistemas
echo "# Para ejecutar vmware-user siempre al iniciar i3" >> ~/.config/i3/config
echo "exec --no-startup-id vmware-user &" >> ~/.config/i3/config ### Para que se ejecute siempre al iniciar
vmware-user

## Eliminamos la carpeta copiada del disco de las vmware.
sudo rm -rf ~/vmware-tools*

echo "Realiza un reboot"
