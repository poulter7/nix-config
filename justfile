
nix-install-mac:
	nix run nix-darwin -- switch --flake ./flakes/darwin/.#mac

nix-install-jonathan:
	nix run nixpkgs#home-manager -- switch --flake ./flakes/linux-jonathan

nix-install-jpoulter:
	nix run nixpkgs#home-manager -- switch --flake ./flakes/linux-jpoulter

nix-install-coder:
	nix run nixpkgs#home-manager -- switch --flake ./flakes/coder

nix-install-wsl:
	winget.exe import modules/home-manager/winget/packages.json
	scoop install kanata
	just windows-copy-configs
	if not test -d ~/programs/panoplywin-5.6.0/PanoplyWin/; curl https://www.giss.nasa.gov/tools/panoply/download/PanoplyWin-5.6.0.zip --output /tmp/panoplywin-5.6.0.zip;unzip /tmp/panoplywin-5.6.0.zip -d ~/programs/panoplywin-5.6.0/; end

nix-install-ubuntu:
	nix run nixpkgs#home-manager -- switch --flake ./flakes/linux-parallels
	nix-collect-garbage

nix-update-mac:
	cd flakes/darwin; nix flake update
	nix-collect-garbage

nix-update-wsl:
	cd flakes/linux-jonathan; nix flake update
	nix-collect-garbage

# Test commands
test-mac:
	cd flakes/darwin && nix flake check --show-trace

test-jonathan:
	cd flakes/linux-jonathan && nix flake check --show-trace

test-jpoulter:
	cd flakes/linux-jpoulter && nix flake check --show-trace

test-coder:
	cd flakes/coder && nix flake check --show-trace

test-ubuntu:
	cd flakes/linux-parallels && nix flake check --show-trace

test-all:
	@echo "Testing all configurations..."
	@just test-coder || echo "⚠️  Coder tests failed"
	@just test-jonathan || echo "⚠️  Jonathan tests failed"
	@just test-jpoulter || echo "⚠️  JPoulter tests failed"
	@just test-ubuntu || echo "⚠️  Ubuntu tests failed"
	@just test-mac || echo "⚠️  Mac tests failed"

# Build test - validates that configurations can be built
build-test-jonathan:
	nix build --no-link ./flakes/linux-jonathan#homeConfigurations.jonathan.activationPackage

build-test-jpoulter:
	nix build --no-link ./flakes/linux-jpoulter#homeConfigurations.jpoulter.activationPackage

build-test-coder:
	nix build --no-link ./flakes/coder#homeConfigurations.$(shell echo $$USER).activationPackage

build-test-ubuntu:
	nix build --no-link ./flakes/linux-parallels#homeConfigurations.parallels.activationPackage

build-test-mac:
	nix build --no-link ./flakes/darwin#darwinConfigurations.mac.system

# Format all Nix files
fmt:
	nix-shell -p treefmt --run 'treefmt'

# Check formatting without making changes
fmt-check:
	nix-shell -p nixfmt-rfc-style --run 'nixfmt --check .'

windows-copy-configs:
	cp ~/Code/projects/nix-config/modules/home-manager/wezterm/*.lua /mnt/c/Users/jonathan/.config/wezterm/
	cp ~/Code/projects/nix-config/modules/home-manager/komorebi/*.json /mnt/c/Users/jonathan/
	cp ~/Code/projects/nix-config/modules/home-manager/komorebi/whkdrc /mnt/c/Users/jonathan/.config/
	komorebic.exe fetch-app-specific-configuration

windows-bounce-komorebi:
	komorebic.exe stop
	komorebic.exe start --whkd --bar

