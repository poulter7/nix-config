nix-install-mac:
	nix run nix-darwin -- switch --flake ./flakes/darwin/.#mac

nix-install-wsl:
	nix run nixpkgs#home-manager -- switch --flake ./flakes/linux-jonathan
	winget.exe import modules/home-manager/winget/packages.json
	just windows-copy-configs

nix-install-ubuntu:
	nix run nixpkgs#home-manager -- switch --flake ./flakes/linux-parallels

nix-update-mac:
	cd flakes/darwin
	nix flake update

nix-update-wsl:
	cd flakes/linux-jonathan
	nix flake update

windows-copy-configs:
	cp ~/Code/projects/nix-config/modules/home-manager/wezterm/*.lua /mnt/c/Users/jonathan/.config/wezterm/
	cp ~/Code/projects/nix-config/modules/home-manager/komorebi/*.json /mnt/c/Users/jonathan/
	komorebic.exe fetch-app-specific-configuration

