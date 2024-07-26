{ pkgs, ... }: {
  # here go the darwin preferences and config items
  programs.zsh.enable = true;
  users.users.jonathan.home = "/Users/jonathan";
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
}
