
set shell := ["fish", "-c"]

nix-install-mac:
	nix run nix-darwin -- switch --flake ./flakes/darwin/.#mac

nix-install-wsl-jonathan:
	nix run nixpkgs#home-manager -- switch --flake ./flakes/linux-jonathan
	winget.exe import modules/home-manager/winget/packages.json
	scoop install kanata
	just windows-copy-configs
	if not test -d ~/programs/panoplywin-5.6.0/PanoplyWin/; curl https://www.giss.nasa.gov/tools/panoply/download/PanoplyWin-5.6.0.zip --output /tmp/panoplywin-5.6.0.zip;unzip /tmp/panoplywin-5.6.0.zip -d ~/programs/panoplywin-5.6.0/; end

nix-install-wsl-jpoulter:
	nix run nixpkgs#home-manager -- switch --flake ./flakes/linux-jpoulter
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

