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

  imports = [
    ./settings/system.nix
    ./settings/environment.nix
  ];
}
