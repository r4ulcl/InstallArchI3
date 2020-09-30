# InstallArch i3wm

List of files and scripts to install in a fresh arch install, if this have some sense

All for the i3wm enviroment

## Usage
Clone the repo: ``` git clone https://github.com/Loop-Man/InstallArchI3 ```

Change to directory: ``` cd InstallArchI3 ```

Change file permissions: ``` chmod +x i3wmInstall.sh i3wmConfig.sh VMwareTools.sh InstallZSH.sh```

Launch bspwmInstall, this will download all the necessary packages: ``` ./i3wmInstall.sh ```

Launch configBspwm, this will finish with the configuration files: ``` ./i3wmConfig.sh ```

Reboot and login

Change to directory: ``` cd InstallArchI3 ```

Launch vmwaretools, this will install vmwaretools: ``` ./VMwareTools.sh ```

Launch InstallZSH.sh, this will install InstallZSH.sh: ``` ./InstallZSH.sh ```

Or you can launch all at one time with (first the installer all the neccesary packages): ``` ./i3wmInstall.sh && ./i3wmConfig.sh && ./VMwareTools.sh ./InstallZSH.sh ``` 
