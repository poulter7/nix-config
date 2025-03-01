install-nix:
	sh <(curl -L https://nixos.org/nix/install)

enable-experimental-features:
	mkdir -p ~/.config/nix
	echo 'experimental-features = nix-command flakes' > ~/.config/nix/nix.conf

nix-install-linux-jonathan:
	nix run nixpkgs#home-manager -- switch --flake ./flakes/linux-jonathan

nix-install-linux-parallels:
	nix run nixpkgs#home-manager -- switch --flake ./flakes/linux-parallels

nix-install-mac:
	nix run nix-darwin -- switch --flake ./flakes/darwin/.#mac


[working-directory: 'flakes/darwin']
nix-update-mac:
	nix flake update

[working-directory: 'flakes/linux-jonathan']
nix-update-windows:
	nix flake update

windows-copy-wezterm-config:
	cp ~/Code/projects/nix-config/modules/home-manager/wezterm/*.lua /mnt/c/Users/jonathan/.config/wezterm/
