{ pkgs, lib, ... }: {
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
    extensions = [
      pkgs.vscode-extensions.catppuccin.catppuccin-vsc
      pkgs.vscode-extensions.ms-python.python
      pkgs.vscode-extensions.zainchen.json
      pkgs.vscode-extensions.bbenoist.nix
      pkgs.vscode-extensions.jnoortheen.nix-ide
      pkgs.vscode-extensions.asvetliakov.vscode-neovim
    ];
  };
}