{ pkgs, ... }: 
  let
      user = "jonathan";
  in {
  # specify my home-manager configs
  imports = [
    ./zsh.nix
  ];

  home = {
    username = "${user}";
    homeDirectory = "/Users/${user}";
    
    packages = with pkgs; [
      ripgrep
      tree
      lazygit
      jump
      fzf
      git
      duckdb
      shfmt
      jump
      neovim
      terraform
      oh-my-zsh
      texliveFull
      nodejs_20
      uv
      yarn
      typescript
      gh
    ];

    sessionVariables = {
      PAGER = "less";
      CLICLOLOR = 1;
      EDITOR = "va";
    };
  };

  # home.file.".inputrc".source = ./settings/inputrc;
  # Don't change this when you change package input. Leave it alone.
  home.stateVersion = "24.05"; # 23.11
  home.file = {
     karabiner = {
      source=./karabiner/karabiner.json;
      target=".config/karabiner/karabiner.json";
    };
    amethyst = {
      source=./amethyst/amethyst.yml;
      target=".config/amethyst/amethyst.yml";
      onChange="/usr/bin/pkill Amethyst; /usr/bin/open -a Amethyst";
    };
    p10k = {
      source=./zsh/p10k.zsh;
      target=".p10k.zsh";
    };
    kickstart = {
      source=./kickstart;
      target=".config/nvim-kickstart";
      recursive = true;
    };
    astronvim = {
      source=./astronvim;
      target=".config/nvim-nixos";
      recursive = true;
    };
    vimac = {
      source=../darwin/apps/Vimac.app;
      target="./Applications/Vimac.app";
      recursive = true;
    };
    opal = {
      source=../darwin/apps/Opal.app;
      target="./Applications/Opal.app";
      recursive = true;
    };
    bd = {
      source=../darwin/apps/BetterDisplay.app;
      target="./Applications/BetterDisplay.app";
      recursive = true;
    };
    wezterm = {
      source=./wezterm;
      target=".config/wezterm";
      recursive = true;
    };
    authorized-keys = {
      source=./ssh/authorized_keys;
      target=".ssh/authorized_keys";
    };
    ideavimrc = {
      source=./idea/.ideavimrc;
      target=".ideavimrc";
    };
    screenshots = {
       source=./screenshots/.keep;
       target="Screenshots/.keep";
       recursive=true;
    };
  };
}
