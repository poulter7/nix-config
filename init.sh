#!/bin/bash
sh <(curl -L https://nixos.org/nix/install)

mkdir -p ~/.config/nix

echo "experimental-features = nix-command flakes" >~/.config/nix/nix.conf
echo ". /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" > ~/.zshrc

nix-channel --update darwin

nix run nix-darwin -- switch --flake .
