{ pkgs, ... }: 
  let
      user = "jonathan";
  in {
  # specify my home-manager configs
  imports = [
    ./zsh.nix
    # ./settings/kitty.nix
    # ./settings/tmux.nix
#    ./settings/neovim.nix
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
    ];

    sessionVariables = {
      PAGER = "less";
      CLICLOLOR = 1;
      EDITOR = "nvim";
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
      target="./.config/tmux/";
      recursive = true;
      onChange="echo 'Refreshing tmux configuration' && ${pkgs.tmux}/bin/tmux source ~/.config/tmux/tmux.conf.local";
    };
  };
}
