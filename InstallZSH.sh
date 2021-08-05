#!/bin/bash

### Instalamos paquetes necesarios ######

sudo pacman -S --noconfirm --needed zsh        
sudo pacman -S --noconfirm --needed zsh-doc
sudo pacman -S --noconfirm --needed zsh-autosuggestions
sudo pacman -S --noconfirm --needed zsh-completions
sudo pacman -S --noconfirm --needed zsh-history-substring-search
sudo pacman -S --noconfirm --needed zsh-lovers
sudo pacman -S --noconfirm --needed zsh-syntax-highlighting
sudo pacman -S --noconfirm --needed zshdb
#sudo pacman -S --noconfirm --needed zsh-theme-powerlevel10k

sudo pacman -S --noconfirm --needed lsd
sudo pacman -S --noconfirm --needed bat
sudo pacman -S --noconfirm --needed fd-find
#sudo pacman -S --noconfirm --needed fzf

#https://medium.com/tech-notes-and-geek-stuff/install-zsh-on-arch-linux-manjaro-and-make-it-your-default-shell-b0098b756a7a
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
#plugins
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/agkozak/zsh-z $ZSH_CUSTOM/plugins/zsh-z
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf

sudo dnf install fd-find

echo 'export FZF_DEFAULT_COMMAND='fdfind --type f'
export FZF_DEFAULT_OPTS="--layout=reverse --inline-info --height=80%"' > ~/.zshrc

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

#chsh -s /bin/zsh

~/.fzf/install
