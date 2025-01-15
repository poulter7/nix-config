{ pkgs, ... }: 
  let 
    userpkgs = import ../userpkgs.nix pkgs;
  in
  {
  # here go the darwin preferences and config items
  programs.zsh.enable = true;
  users.users.jonathan.home = "/Users/jonathan";
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
  };
  environment = {
    shells = with pkgs; [ bash zsh ];
    systemPackages = [ 
      pkgs.coreutils
    ];
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
