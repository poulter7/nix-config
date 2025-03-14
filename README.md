# nix-config 
This repo is a place for me to hopefully solve a perpetual problem: make every macbook I work have a similar enough look, feel and tools that switching between machines isn't a hassle.

## Windows Pre-requisites
For twm - In an admin terminal
```
Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'LongPathsEnabled' -Value 1
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableLockWorkstation /t REG_DWORD /d 1 /f
```

Install wsl
```
# (1) Local Group Policy Editor -> User Configuration -> Administrative Templates -> Windows Components -> File Explorer -> Turn off Windows Key hotkeys
wsl --set-default-version 2
wsl --install
wsl
```


## Common install
```
Install nix

sh <(curl -L https://nixos.org/nix/install) --no-daemon
. /home/$USER/.nix-profile/etc/profile.d/nix.sh

mkdir -p ~/Code/projects
cd ~/Code/projects
nix-shell -p gh --run 'gh auth'
nix-shell -p gh --run 'gh repo clone poulter7/nix-config'
cd nix-config

mkdir -p ~/.config/nix
echo 'experimental-features = nix-command flakes' > ~/.config/nix/nix.conf
rm ~/.bashrc
rm ~/.profile

nix-shell -p just --run 'just nix-install-wsl'
```

## Windows Post Setup 
```
komorebic.exe enable-autostart --whkd --bar
komorebic.exe start --whkd --bar
```


## Other items
Install Karabiner manually

## Setup up conda
```
micromamba create -n <env>  -c conda-forge
micromamba activate <env>
micromamba install -e .[dev]
```

## Neorg?
https://github.com/nvim-neorg/neorg/issues/74#issuecomment-1484104199
