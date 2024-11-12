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
