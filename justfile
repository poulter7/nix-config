nix-install-mac:
	nix run nix-darwin -- switch --flake ./flakes/darwin/.#mac

nix-install-wsl:
	nix run nixpkgs#home-manager -- switch --flake ./flakes/linux-jonathan
	winget.exe import modules/home-manager/winget/packages.json
	just windows-copy-configs

nix-install-ubuntu:
	nix run nixpkgs#home-manager -- switch --flake ./flakes/linux-parallels
	nix-collect-garbage

nix-update-mac:
	cd flakes/darwin; nix flake update
	nix-collect-garbage

nix-update-wsl:
	cd flakes/linux-jonathan; nix flake update
	nix-collect-garbage

windows-copy-configs:
	cp ~/Code/projects/nix-config/modules/home-manager/wezterm/*.lua /mnt/c/Users/jonathan/.config/wezterm/
	cp ~/Code/projects/nix-config/modules/home-manager/komorebi/*.json /mnt/c/Users/jonathan/
	cp ~/Code/projects/nix-config/modules/home-manager/komorebi/whkdrc /mnt/c/Users/jonathan/.config/
	komorebic.exe fetch-app-specific-configuration

windows-bounce-komorebi:
	komorebic.exe stop
	komorebic.exe start --whkd --bar

zmk-build:
	cd modules/keyboards/Adv360-Pro-ZMK/; make

zmk-clean:
	cd modules/keyboards/Adv360-Pro-ZMK/; make clean

zmk-copy-left:
	cd modules/keyboards/Adv360-Pro-ZMK/firmware; cat $(fd -I 'left' | tail -1) > /Volumes/ADV360PRO/LEFT.UF2    

zmk-copy-right:
	cd modules/keyboards/Adv360-Pro-ZMK/firmware; cat $(fd -I 'right' | tail -1) > /Volumes/ADV360PRO/RIGHT.UF2    
