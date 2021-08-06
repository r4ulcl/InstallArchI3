# InstallArch i3wm

**Work in progress**

List of files and scripts to install in a fresh arch install

All for the i3 enviroment

## features

### ArchInstaller

- Arch with LUKS and SWAP file using btrfs
- EFI
- Option for full disk or free space
- Boot loader or refind
- Dual boot with Windows ready


### Tools

Basic tools to work correctly with Arch

### I3

I3 graphical interface and requirements

### ZSH

ZSH Basic Installation

### Hacking tools

Hacking tools list

### Extra

#### GameArch

Tools installation to play Arch correctly with AMD GPU

#### ConfigFiles

Download and set ConfigFiles repository with my basic config file updated. 

## Usage

Clone the repo: ``` git clone https://github.com/RaulCalvoLaorden/InstallArchI3 ```

Change to directory: ``` cd InstallArchI3 ```

Launch i3wmInstall, this will download all the necessary packages: ``` ./ArchPhase1.sh ```

Then you have to put the disk on which you want to write.

If we want to use the entire disk or free space

Set the LUKS password

Set the root and user passwords

And decide if refind is used (recommended for dual boot)

Reboot and login

``` bash
cd InstallArchi3

# To install i3
bash installi3.sh

# install Tools
bash installTools.sh

# install ZSH
bash installZSH.sh

```

or 

``` bash
bash InstallAll.sh
```
