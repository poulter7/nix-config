install-nix:
	sh <(curl -L https://nixos.org/nix/install)

nix-intial-setup:
	mkdir -p ~/.config/nix
	echo 'experimental-features = nix-command flakes' > ~/.config/nix/nix.conf
	rm ~/.bashrc
	rm ~/.profile

nix-install-wsl-jonathan:
	nix run nixpkgs#home-manager -- switch --flake ./flakes/linux-jonathan
	just windows-copy-wezterm-config

nix-install-linux-parallels:
	nix run nixpkgs#home-manager -- switch --flake ./flakes/linux-parallels

nix-install-mac:
	nix run nix-darwin -- switch --flake ./flakes/darwin/.#mac


nix-update-mac:
	cd flakes/darwin
	nix flake update

nix-update-windows:
	cd flakes/linux-jonathan
	nix flake update

windows-copy-wezterm-config:
	cp ~/Code/projects/nix-config/modules/home-manager/wezterm/*.lua /mnt/c/Users/jonathan/.config/wezterm/
