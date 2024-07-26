# Mac Setup
This repo is a place for me to hopefully solve a perpetual problem: make every macbook I work have a similar enough look, feel and tools that switching between machines isn't a hassle.

## Getting started
git clone git@github.com:poulter7/mac-setup.git
./init.sh

## Build the nix configuration
nix build .#darwinConfigurations.personal.system

## Activate the nix configuration
./result/sw/bin/darwin-rebuild switch --flake .#mac

## Build and Reactivate
darwin-rebuild switch --flake ~/Code/projects/mac-setup/.#mac