# nix-config 
This repo is a place for me to hopefully solve a perpetual problem: make every macbook I work have a similar enough look, feel and tools that switching between machines isn't a hassle.

## Testing

This repository includes comprehensive testing infrastructure to validate that packages and configurations work as expected. See [TESTING.md](TESTING.md) for detailed information.

Quick test commands:
```bash
# Test all configurations
just test-all

# Test specific platform
just test-mac       # macOS
just test-coder     # Coder/Linux
just test-jonathan  # WSL/Linux
```

## Using as Coder Dotfiles

This repository can be used as a dotfiles repository for [Coder](https://coder.com/) workspaces. Coder will automatically execute the `install.sh` script to bootstrap your development environment with your preferred tools and configurations.

### Setup in Coder

1. Go to your Coder deployment and navigate to your user settings
2. Set the Dotfiles Repository URL to: `https://github.com/poulter7/nix-config`
3. Create a new workspace - the dotfiles will be automatically applied

### Manual Installation

You can also run the installation script manually in any Linux environment:

```bash
git clone https://github.com/poulter7/nix-config.git
cd nix-config
./install.sh
```

The script will:
- Install Nix if not already present
- Configure Nix with flakes support
- Apply the home-manager configuration using the Coder-specific flake
- Backup any existing shell configuration files

## Windows Pre-requisites
For twm - In an admin terminal
```
Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'LongPathsEnabled' -Value 1
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableLockWorkstation /t REG_DWORD /d 1 /f
```

Install scoop
```
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
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
scoop install git
scoop bucket add extras
```


## Other items
Install Karabiner driver manually
https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice/tree/main

## Setup up conda
```
micromamba create -n <env>  -c conda-forge
micromamba activate <env>
micromamba install -e .[dev]
```

## Neorg?
https://github.com/nvim-neorg/neorg/issues/74#issuecomment-1484104199
