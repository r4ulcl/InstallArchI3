# Fish shell

set fish_greeting

egrep "^export " ~/.bashrc | while read e
	set var (echo $e | sed -E "s/^export ([A-Z_]+)=(.*)\$/\1/")
	set value (echo $e | sed -E "s/^export ([A-Z_]+)=(.*)\$/\2/")
	
	# remove surrounding quotes if existing
	set value (echo $value | sed -E "s/^\"(.*)\"\$/\1/")

	if test $var = "PATH"
		# replace ":" by spaces. this is how PATH looks for Fish
		set value (echo $value | sed -E "s/:/ /g")
	
		# use eval because we need to expand the value
		eval set -xg $var $value

		continue
	end

	# evaluate variables. we can use eval because we most likely just used "$var"
	set value (eval echo $value)

	#echo "set -xg '$var' '$value' (via '$e')"
	set -xg $var $value
end

# Environmental Variables
set -xg READER zathura
set -xg SUDO_ASKPASS "$HOME/.config/i3/bin/dmenupass"

# Personal Aliases

# list
#alias ls='ls --color=auto'
#alias la='ls -a --color=auto'
#alias l='ls -lah --group-directories-first --color=auto'
#alias ll='ls --color=auto'
#alias l.="ls -A | egrep '^\.'"

# list with lsd
alias ll='lsd -lht --group-dirs=first'
alias la='lsd -a --group-dirs=first'
alias ls='lsd --group-dirs=first'
#alias lla='lsd -laht --group-dirs=first'
alias l='lsd -laht --group-dirs=first'

# Colorize the grep command output for ease of use (good for log files)##
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Use bat for cat
alias cat='/usr/bin/bat'
alias catn='/bin/cat'
alias catnl='/usr/bin/bat --paging=never'

# IPv4 e IPv6
alias ip46='ip -br -c a'

# xclip al clipboard
alias xxclip='xclip -sel clip'

# mv cp rm verbose
alias mv='mv -iv'
alias cp='cp -iv'
alias rm='rm -v'

#readable output
alias df='df -h'

#free
alias free="free -mt"

#continue download
alias wget="wget -c"

#merge new settings
#alias merge="xrdb -merge ~/.Xresources"

# Aliases for software managment
# pacman or pm
alias pacman='sudo pacman --color=auto'
#alias update='sudo pacman -Syu'
alias actualizar='sudo pacman -Syu --noconfirm;sudo pacman -Rsu (pacman -Qdtq) --noconfirm;yay -Syu --noconfirm'

#pacman unlock
alias unlock="sudo rm /var/lib/pacman/db.lck"

#updateplugins
alias update='sudo updatedb;sudo searchsploit -u;sudo nmap --script-updatedb;sudo cve_searchsploit -u'

#HTB vpn
alias htbvpn='sudo /usr/bin/openvpn ~/HTB/ElderOrion.ovpn'

#ps
alias psa="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"

#grub update
alias update-grub="sudo grub-mkconfig -o /boot/grub/grub.cfg"

#add new fonts
alias update-fc='sudo fc-cache -fv'

#hardware info --short
alias hw="hwinfo --short"

#check vulnerabilities microcode
alias microcode='grep . /sys/devices/system/cpu/vulnerabilities/*'

#get fastest mirrors in your neighborhood
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"

#mounting the folder Public for exchange between host and guest on virtualbox
#alias vbm="sudo mount -t vboxsf -o rw,uid=1000,gid=1000 Public /home/$USER/Public"

#Montar carpeta compartida en vmware
alias montar='sudo mount -t fuse.vmhgfs-fuse .host:/(vmware-hgfsclient) ~/Shared -o allow_other'

#youtube-dl
alias yta-aac="youtube-dl --extract-audio --audio-format aac "
alias yta-best="youtube-dl --extract-audio --audio-format best "
alias yta-flac="youtube-dl --extract-audio --audio-format flac "
alias yta-m4a="youtube-dl --extract-audio --audio-format m4a "
alias yta-mp3="youtube-dl --extract-audio --audio-format mp3 "
alias yta-opus="youtube-dl --extract-audio --audio-format opus "
alias yta-vorbis="youtube-dl --extract-audio --audio-format vorbis "
alias yta-wav="youtube-dl --extract-audio --audio-format wav "

alias ytv-best="youtube-dl -f bestvideo+bestaudio "

#Recent Installed Packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"
alias riplong="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -3000 | nl"

#Cleanup orphaned packages
alias cleanup='sudo pacman -Rs (pacman -Qtdq)'

#get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"

#gpg
#verify signature for isos
alias gpg-check="gpg2 --keyserver-options auto-key-retrieve --verify"
#receive the key of a developer
alias gpg-retrieve="gpg2 --keyserver-options auto-key-retrieve --receive-keys"

#shutdown or reboot
alias ssn="sudo shutdown now"
alias sr="sudo reboot"

# Personal Configuration
#alias rg='RIPGREP_CONFIG_PATH=~/.ripgreprc rg'
alias nmap='grc nmap'
alias nc='ncat'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Connection speed test
alias speedtest='wget --output-document=/dev/null http://speedtest.wdc01.softlayer.com/downloads/test500.zip'

# Public IP
alias iip='dig +short myip.opendns.com @resolver1.opendns.com'
