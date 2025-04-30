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
      (hiPrio clang) # high priority as c++ bin collides with gcc
      (lib.mkIf pkgs.stdenv.isLinux pkgs.gcc) # installed via brew on mac
      (lib.mkIf pkgs.stdenv.isLinux pkgs.panoply) # only available on Linux
      (lib.mkIf pkgs.stdenv.isLinux pkgs.strace) # only available on Linux
      bat
      btop
      cargo
      curl
      delta
      duckdb
      eza
      fd
      ffmpeg
      fzf
      gh
      git
      gnupg
      gnused
      go
      grc
      isync
      jujutsu
      jump
      jump
      just
      kanata-with-cmd
      lazygit
      lua-language-server
      lua51Packages.lua
      lua51Packages.luarocks
      lua51Packages.mimetypes
      lua51Packages.xml2lua
      lynx
      markdownlint-cli
      micromamba
      mutt-wizard
      nerd-fonts.commit-mono
      nix-search-cli
      nixfmt-rfc-style
      nodejs_20
      ollama
      openai-whisper
      pass
      python312Full
      python312Packages.west
      qpdf
      ripgrep
      ruff
      shfmt
      smassh
      starship
      taskwarrior-tui
      taskwarrior3
      terraform
      texliveFull
      thokr
      tree
      tree-sitter
      treefmt
      typescript
      typst
      typstyle
      unzip
      uv
      yarn
      zellij
      zotero
    ];
  };
  homebrew = {
    brews = [
      "asitop"
      "awscli"
      "entr"
      "gcc@11"
      "graphviz"
      "huggingface-cli"
      "lapack"
      "llama.cpp"
      "openblas"
      "spotify_player"
      "swiftlint"
      "yazi"
      "zig"
      "zoxide"
    ];
    casks = [
      "active-trader-pro"
      "akiflow"
      "amethyst"
      "bruno"
      "caffeine"
      "chatgpt"
      "cursor"
      "dash"
      "docker"
      "focus"
      "font-hack-nerd-font"
      "gimp"
      "google-chrome"
      "ibkr"
      "jetbrains-toolbox"
      "logi-options+"
      "panoply"
      "postman"
      "qgis"
      "raycast"
      "shortcat"
      "skim"
      "slack"
      "spotify"
      "steam"
      "sublime-text"
      "temurin"
      "texshop"
      "trader-workstation"
      "virtual-desktop-streamer"
      "visual-studio-code"
      "vlc"
      "wezterm"
      "whatsapp"
      "zoom"
    ];
  };
}
