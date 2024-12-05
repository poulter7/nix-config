{ pkgs, ... }: 
  let
      user = "jonathan";
  in {
  # specify my home-manager configs
  imports = [
    ./zsh.nix
    ./vscode.nix
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
      tmux
      jump
      neovim
      terraform
      oh-my-zsh
      texliveFull
      nodejs_20
      uv
      yarn
      typescript
      awscli
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
    tmux = {
      source=./tmux;
      target=".config/tmux/";
      recursive=true;
      onChange="echo 'Refreshing tmux configuration' && ${pkgs.tmux}/bin/tmux source ~/.config/tmux/tmux.conf.local";
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
    vscode-settings = {
      source=./vscode/settings.json;
      target="./Library/Application Support/Code/User/settings.json";
      force=true;
    };
    vscode-keybindings = {
      source=./vscode/keybindings.json;
      target="./Library/Application Support/Code/User/keybindings.json";
      force=true;
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
