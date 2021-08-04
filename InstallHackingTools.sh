#!/bin/bash

# Set the cores
echo "Setting the cores"

set -e

numberofcores=$(grep -c ^processor /proc/cpuinfo)

if [ $numberofcores -gt 1 ]
then
        echo "You have " $numberofcores" cores."
        echo "Changing the makeflags for "$numberofcores" cores."
        sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j'$(($numberofcores+1))'"/g' /etc/makepkg.conf;
        echo "Changing the compression settings for "$numberofcores" cores."
        sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T '"$numberofcores"' -z -)/g' /etc/makepkg.conf
else
        echo "No change."
fi

echo ""

sudo pip3 install cve_searchsploit                             # Instalamos searchsploit_cve

sudo pacman -S --noconfirm --needed tor 
sudo pacman -S --noconfirm --needed torsocks
sudo pacman -S --noconfirm --needed torbrowser-launcher
sudo pacman -S --noconfirm --needed nyx                    # Nyx is a command-line monitor for Tor. With this you can get detailed real-time information about your relay such as bandwidth usage, connections, logs, and much more.


# ----------------
# Pentesting
# ----------------

echo "Installing Tools for Pentesting"

# Pacman repo
sudo pacman -S --noconfirm --needed nmap
sudo pacman -S --noconfirm --needed aircrack-ng
sudo pacman -S --noconfirm --needed usbutils
sudo pacman -S --noconfirm --needed bettercap
sudo pacman -S --noconfirm --needed inetutils
sudo pacman -S --noconfirm --needed openssh
sudo pacman -S --noconfirm --needed iputils 
sudo pacman -S --noconfirm --needed traceroute 
sudo pacman -S --noconfirm --needed whois 
sudo pacman -S --noconfirm --needed dnsutils
sudo pacman -S --noconfirm --needed impacket
sudo pacman -S --noconfirm --needed hydra 
sudo pacman -S --noconfirm --needed medusa
sudo pacman -S --noconfirm --needed john 
sudo pacman -S --noconfirm --needed hashcat
sudo pacman -S --noconfirm --needed nikto
sudo pacman -S --noconfirm --needed sqlmap
sudo pacman -S --noconfirm --needed wireshark-qt 
sudo pacman -S --noconfirm --needed tcpdump
sudo pacman -S --noconfirm --needed proxychains-ng
sudo pacman -S --noconfirm --needed dsniff
sudo pacman -S --noconfirm --needed ettercap-gtk
sudo pacman -S --noconfirm --needed hping
sudo pacman -S --noconfirm --needed ngrep
sudo pacman -S --noconfirm --needed metasploit
sudo pacman -S --noconfirm --needed masscan
#sudo pacman -S --noconfirm --needed zaproxy
sudo pacman -S --noconfirm --needed smbclient
sudo pacman -S --noconfirm --needed kxmlrpcclient               # XML-RPC client library for KDE
sudo pacman -S --noconfirm --needed radare2
sudo pacman -S --noconfirm --needed parallel
sudo pacman -S --noconfirm --needed mysql
sudo pacman -S --noconfirm --needed perl-image-exiftool
sudo pacman -S --noconfirm --needed wpscan


#For windows
sudo pacman -S --noconfirm --needed nbtscan

# For Wifi
sudo pacman -S --noconfirm --needed reaver              # Reaver-WPS desempeña un ataque de fuerza bruta contra el número de pin de WiFi de un punto de acceso
sudo pacman -S --noconfirm --needed bully               # Romper claves WPA por la vulnerabilidad del WPS mediante Bully.
sudo pacman -S --noconfirm --needed macchanger          # Herramienta para cambiar la mac de la tarjeta de red
sudo pacman -S --noconfirm --needed hcxdumptool         # Pequeña herramienta para capturar paquetes de dispositivos WLAN
sudo pacman -S --noconfirm --needed hcxtools            # Un pequeño conjunto de herramientas convierte paquetes de capturas (h = hash, c = captura, convierte y calcula candidatos, x = diferentes tipos de hash) para su uso con el último hashcat o John the Ripper.

# Instsall  airgeddon eapeak eaphammer


# AUR Repo
yay -S --noconfirm --needed exploit-db-git              # The Exploit Database Git Repository
yay -S --noconfirm --needed cutycapt-qt5-git            # Una utilidad de línea de comandos basada en Qt y WebKit que captura la representación de WebKit de una página web.
yay -S --noconfirm --needed routersploit-git            # The RouterSploit Framework is an open-source exploitation framework dedicated to embedded devices.

echo ""


yay -S --noconfirm --needed rockyou                                     # Diccionario rockyou de owasp
yay -S --noconfirm --needed samdump2                                    # Para dumpear password en claro de los ficheros sam y system
#yay -S --noconfirm --needed neo4j-git                                  # A fully transactional graph database implemented in Java. Need for bloodhound (No funciona)


## Actualizo plugins, scripts y exploits

sudo updatedb
sudo searchsploit -u
sudo nmap --script-updatedb
sudo cve_searchsploit -u


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

## Personal ADD  UNTESTED hacking


yay -Sy --noconfirm --needed airgeddon-git 
yay -Sy --noconfirm --needed arp-scan
yay -Sy --noconfirm --needed asleap
yay -Sy --noconfirm --needed autopsy
yay -Sy --noconfirm --needed batify
yay -Sy --noconfirm --needed berate_ap-git
yay -Sy --noconfirm --needed bloodhound
yay -Sy --noconfirm --needed cewl
yay -Sy --noconfirm --needed crackmapexec 
yay -Sy --noconfirm --needed create_ap
yay -Sy --noconfirm --needed dwdiff
yay -Sy --noconfirm --needed engrampa
yay -Sy --noconfirm --needed enum4linux
yay -Sy --noconfirm --needed gobuster
yay -Sy --noconfirm --needed hash-identifier
yay -Sy --noconfirm --needed hg
yay -Sy --noconfirm --needed hostapd
yay -Sy --noconfirm --needed hostapd-mana
yay -Sy --noconfirm --needed hostapd-wpe
yay -Sy --noconfirm --needed impacket
yay -Sy --noconfirm --needed m2crypto
yay -Sy --noconfirm --needed mana-toolkit
yay -Sy --noconfirm --needed neo4j-community
yay -Sy --noconfirm --needed nessus
yay -Sy --noconfirm --needed r1133.d160214
yay -Sy --noconfirm --needed responder
yay -Sy --noconfirm --needed rpcclient smbclient
yay -Sy --noconfirm --needed rtl8812au
yay -Sy --noconfirm --needed rtl8812au-dkms-git
yay -Sy --noconfirm --needed rtl8814au
yay -Sy --noconfirm --needed rtl8814au-dkms-git 
yay -Sy --noconfirm --needed rtl88xxau-aircrack-dkms-git
yay -Sy --noconfirm --needed sslstrip mdk4 crunch pixiewps python2-crypto --overwrite
yay -Sy --noconfirm --needed wafw00f
