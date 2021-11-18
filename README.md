# InstallArch i3wm

List of files and scripts to install in a fresh arch install, if this have some sense

All for the i3wm enviroment

## Usage
- Clone the repo: ``` git clone https://github.com/RaulCalvoLaorden/InstallArchI3 ```

- Change to directory: ``` cd InstallArchI3 ```

- Launch i3wmInstall, this will download all the necessary packages: ``` ./ArchPhase1.sh ```

- Then you have to put the disk on which you want to write.

- If we want to use the entire disk or free space

- Set the LUKS password

- Set the root and user passwords

- And decide if refind is used (recommended for dual boot)

- Reboot and login

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
