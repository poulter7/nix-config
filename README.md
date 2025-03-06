# nix-config 
This repo is a place for me to hopefully solve a perpetual problem: make every macbook I work have a similar enough look, feel and tools that switching between machines isn't a hassle.

## Windows Pre-requisite

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

Install gh and just
```
(type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
        && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        && cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo apt update \
	&& sudo apt install gh -y
sudo apt install just
```

## Mac Pre-requiste
Install brew
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install gh
brew install just
```
## Common install
Install nix
```
sh <(curl -L https://nixos.org/nix/install) --no-daemon
. /home/$USER/.nix-profile/etc/profile.d/nix.sh

cd
gh auth login
mkdir -p ./Code/projects
cd ~/Code/projects
gh repo clone poulter7/nix-config
cd nix-config

mkdir -p ~/.config/nix
echo 'experimental-features = nix-command flakes' > ~/.config/nix/nix.conf
rm ~/.bashrc
rm ~/.profile

just nix-install-wsl
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
micromamba config append channels conda-forge
micromamba install pip
micromamba run pip install -e
```

