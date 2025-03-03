# Mac Setup
This repo is a place for me to hopefully solve a perpetual problem: make every macbook I work have a similar enough look, feel and tools that switching between machines isn't a hassle.

## Getting started
git clone git@github.com:poulter7/nix-config.git

./init.sh

## Activate the nix configuration
nix run nix-darwin -- switch --flake .#mac

## Build and Reactivate
darwin-rebuild switch --flake ~/Code/projects/nix-config/.#mac

## Todo
[ ] Add Darwin Keyboard Shortcuts
[ ] Fix vscode vim


## Other items
Install Karabiner manually

## Installing on Windows

For twm - In an admin terminal
Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'LongPathsEnabled' -Value 1
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableLockWorkstation /t REG_DWORD /d 1 /f



Install wsl
wsl --set-default-version 2
wsl --install
wsl
sh <(curl -L https://nixos.org/nix/install) --no-daemon
. /home/$USER/.nix-profile/etc/profile.d/nix.sh

install gh and just
(type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
        && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        && cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo apt update \
	&& sudo apt install gh -y
sudo apt install just

cd
gh auth login
mkdir -p ./Code/projects
cd ~/Code/projects
gh repo clone poulter7/nix-config
cd nix-config

just enable-experimental-features
just nix-install-wsl-jonathan
just windows-enable-komorebi-autostart

