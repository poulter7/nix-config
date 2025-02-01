{user, userroot} :{ pkgs, ... }: 
  let 
    userpkgs = import ../userpkgs.nix pkgs;
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
  environment = {
    shells = userpkgs.nix.shells; # permissible login shells
    systemPackages = [ pkgs.coreutils ];
    systemPath = [ "/usr/local/bin" ];
    pathsToLink = [ "/Applications" ];
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

  services.nix-daemon.enable = true;
  
  # backwards compat; don't change
  system.stateVersion = 4;
}
