{ pkgs, lib, ... }:
{
  nix = {
    fishPlugins = with pkgs.fishPlugins; [
      done
    ];
    shells = with pkgs; [
      bash
    ];
    utils = with pkgs; [
      (lowfi.override (old: {
        rustPlatform = old.rustPlatform // {
          buildRustPackage =
            args:
            old.rustPlatform.buildRustPackage (
              args
              // {
                buildFeatures = [ ];
              }
            );
        };
      }))
      ffmpeg
      cargo
      smassh
      nixfmt-rfc-style
      btop
      python312Packages.west
      delta
      bat
      eza
      curl
      python312Full
      grc
      starship
      ripgrep
      tree
      lazygit
      jump
      fzf
      git
      duckdb
      shfmt
      jump
      terraform
      nodejs_20
      uv
      yarn
      typescript
      gh
      fd
      jujutsu
      ollama
      unzip
      go
      lynx
      pass
      gnupg
      mutt-wizard
      isync
      gnused
      markdownlint-cli
      nerd-fonts.commit-mono
      ruff
      typst
      typstyle
      zellij
      nix-search-cli
      just
      micromamba
      qpdf
      texliveFull
      lua51Packages.lua
      lua51Packages.luarocks
      lua51Packages.mimetypes
      lua51Packages.xml2lua
      lua-language-server
      tree-sitter
      zotero
      kanata-with-cmd
      taskwarrior3
      taskwarrior-tui
      (lib.mkIf pkgs.stdenv.isLinux pkgs.panoply) # only available on Linux
      (lib.mkIf pkgs.stdenv.isLinux pkgs.strace) # only available on Linux
      (hiPrio clang) # high priority as c++ bin collides with gcc
      (lib.mkIf pkgs.stdenv.isLinux pkgs.gcc) # installed via brew on mac
    ];
  };
  homebrew = {
    brews = [
      "gcc@11"
      "graphviz"
      "swiftlint"
      "entr"
      "zoxide"
      "zig"
      "awscli"
      "spotify_player"
      "yazi"
      "llama.cpp"
      "huggingface-cli"
      "asitop"
      "openblas"
      "lapack"
    ];
    casks = [
      "shortcat"
      "temurin"
      "panoply"
      "focus"
      "wezterm"
      "gimp"
      "slack"
      "akiflow"
      "docker"
      "spotify"
      "postman"
      "zoom"
      "whatsapp"
      "amethyst"
      "dash"
      "texshop"
      "trader-workstation"
      "ibkr"
      "raycast"
      "visual-studio-code"
      "skim"
      "bruno"
      "google-chrome"
      "steam"
      "sublime-text"
      "logi-options+"
      "cursor"
      "jetbrains-toolbox"
      "chatgpt"
      "qgis"
      "active-trader-pro"
      "caffeine"
      "font-hack-nerd-font"
      "virtual-desktop-streamer"
    ];
  };
}
