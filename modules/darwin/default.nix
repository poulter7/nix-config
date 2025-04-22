{ user, userroot }:
{ pkgs, ... }:
let
  userpkgs = import ../userpkgs.nix pkgs;
  karabinerDaemon = "/Library/Application\\ Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-VirtualHIDDevice-Daemon.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Daemon";
  kanataTray = "/Users/jonathan/Applications/kanata-tray-macos";
in
{
  users.users.${user}.home = "${userroot}/${user}";
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  homebrew = {
    brews = userpkgs.homebrew.brews;
    casks = userpkgs.homebrew.casks;
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
      upgrade = true;
    };
    taps = [
      "homebrew/cask"
    ];
  };
  networking.knownNetworkServices = [
    "Wi-Fi"
  ];
  networking.dns = [
    "1.1.1.3"
  ];
  environment = {
    shells = userpkgs.nix.shells; # permissible login shells
    systemPackages = [ pkgs.coreutils ];
    systemPath = [ "/usr/local/bin" ];
    pathsToLink = [ "/Applications" ];
  };
  environment.etc."sudoers.d/kanata-tray".source = pkgs.runCommand "sudoers-kanata-tray" { } ''
    cat <<EOF >"$out"
    ALL ALL=(ALL) NOPASSWD: ${kanataTray}
    ALL ALL=(ALL) NOPASSWD: ${karabinerDaemon}
    EOF
  '';
  launchd = {
    user.agents = {
      kanata-tray = {
        script = "sudo " + kanataTray;
        serviceConfig = {
          KeepAlive = true;
          RunAtLoad = true;
          StandardOutPath = "/tmp/kanata-tray.out.log";
          StandardErrorPath = "/tmp/kanata-tray.err.log";
          Nice = -19;
        };
      };
      karabiner-daemon = {
        script = "sudo " + karabinerDaemon;
        serviceConfig = {
          KeepAlive = true;
          RunAtLoad = true;
          StandardOutPath = "/tmp/karabiner.out.log";
          StandardErrorPath = "/tmp/karabiner.err.log";
          ProcessType = "Interactive";
          Nice = -19;
        };
      };
    };
  };
  system = {
    defaults = {
      screencapture.location = "~/Screenshots";
      NSGlobalDomain = {
        # Dark mode
        AppleInterfaceStyle = "Dark";

        # Show all file extensions
        AppleShowAllExtensions = true;

        # Automatically hide and show the menu bar
        _HIHideMenuBar = true;
      };

      dock = {
        # Automatically hide and show the Dock
        autohide = true;

        # Style options
        orientation = "bottom";
        show-recents = false;
        mru-spaces = false;
      };

      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        _FXShowPosixPathInTitle = true;
      };
    };
  };

  nix.enable = true;
  ids.gids.nixbld = 350;
  # backwards compat; don't change
  system.stateVersion = 4;
}
