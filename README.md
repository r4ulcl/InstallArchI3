# InstallArch i3

List of files and scripts to install in a fresh arch install, if this have some sense

All for the i3 enviroment

## Features
- AutoInstall
- I3
- EFI
- Luks
- BTRFS
- Refind or boot loader

## Usage

### Install basic Arch

- Load the arch ISO from USB or in the VM. 

- Set root password to access using SSH ``` passwd ```

- Start sshd ``` systemctl start sshd```

- Access using SSH from other computer to copy paste easy. ``` ssh root@$IP ```

- Install git ``` pacman -Sy git ```

- Clone the repo: ``` git clone https://github.com/r4ulcl/InstallArchI3 ```

- Change to directory: ``` cd InstallArchI3 ```

- Launch i3wmInstall, this will download all the necessary packages: ``` ./ArchPhase1.sh ```

- Then you have to put the disk on which you want to write.

- If we want to use the entire disk or free space

- Set the LUKS password

- Set the root and user passwords

- And decide if refind is used (recommended for dual boot)

- Reboot and login ``` reboot ```


### Options to continue

#### Install GUI I3 only

- After restart login using your user
- Access to github/InstallARchI3 ``` cd github/InstallARchI3 ```
- Execute install InstallI3 ``` bash InstallBasicTools/InstallI3.sh ```


#### Install GUI I3 and other basic tools

- Access to github/InstallARchI3 ``` cd github/InstallARchI3 ```
- Execute install basic tools ``` bash InstallBasicTools.sh ```

#### Install other extra tools

```
cd ExtraTools

# Wallpapers
bash ExtraWallpapers.sh
# Hacking tools
bash ExtraHackingTools.sh


```