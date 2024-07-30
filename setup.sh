#!/bin/bash
mkdir -p ~/.config/nix

echo "experimental-features = nix-command flakes" >~/.config/nix/nix.conf
echo ". /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" > ~/.zshrc

nix-channel --update darwin

darwin-rebuild switch --flake ~/Code/projects/mac-setup/.#mac
