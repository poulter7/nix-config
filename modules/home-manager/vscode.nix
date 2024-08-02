{ pkgs, lib, ... }: {
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
    extensions = [
      pkgs.vscode-extensions.catppuccin.catppuccin-vsc
    ];
  };
}