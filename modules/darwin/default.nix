{ pkgs, ... }: 
  let 
    userpkgs = import ../userpkgs.nix pkgs;
  in
  {
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
    taps = [
      "homebrew/cask"
    ];
  };
  environment = {
    shells = userpkgs.nix.shells; # permissible login shells
    systemPackages = [ pkgs.coreutils ];
    systemPath = [ "/usr/local/bin" ];
    pathsToLink = [ "/Applications" ];
    interactiveShellInit = ''
    if [[ $(${pkgs.procps}/bin/ps -p "$PPID" -o comm=) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
            # Handle login shell detection for both bash and zsh
            LOGIN_OPTION=""
            if [[ -n "$BASH" ]]; then
                shopt -q login_shell && LOGIN_OPTION="--login"
            elif [[ -n "$ZSH_VERSION" ]]; then
                [[ -o login ]] && LOGIN_OPTION="--login"
            fi
            
            # Execute fish with proper login option
            exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
    fi
  '';
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
