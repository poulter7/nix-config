{ pkgs, ... }: {
  # here go the darwin preferences and config items
  programs.zsh.enable = true;
  users.users.jonathan.home = "/Users/jonathan";
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  imports = [
    ./settings/system.nix
    ./settings/environment.nix
    ./settings/casks.nix
  #   ./settings/yabai.nix
  #   ./settings/skhd.nix
  #   ./settings/spacebar.nix
  ];
}
