{ pkgs, ... }: {

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
