{ lib, ... }: {
  homebrew = {
    brews = import ../../userpkgs.nix homebrew-brews;
    casks = import ../../userpkgs.nix homebrew-casks;
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
      upgrade = true;
    };
  };
}
