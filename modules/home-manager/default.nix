{ pkgs, ... }: {
  # specify my home-manager configs
  imports = [
    ./zsh.nix
    # ./settings/kitty.nix
    # ./settings/tmux.nix
#    ./settings/neovim.nix
  ];

  home = {
    username = "jonathan";
    homeDirectory = "/Users/jonathan";
    
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

  programs = {
    # tmux = {
    #   enable = true;
    #       plugins = with pkgs.tmuxPlugins; [
    #   vim-tmux-navigator
    #   sensible
    #   yank
    #   prefix-highlight
    #   {
    #     plugin = power-theme;
    #   }
    #   {
    #     plugin = resurrect; # Used by tmux-continuum

    #     # Use XDG data directory
    #     # https://github.com/tmux-plugins/tmux-resurrect/issues/348
    #     extraConfig = ''
    #       set -g @resurrect-dir '/Users/dustin/.cache/tmux/resurrect'
    #       set -g @resurrect-capture-pane-contents 'on'
    #       set -g @resurrect-pane-contents-area 'visible'
    #     '';
    #   }
    #   {
    #     plugin = continuum;
    #     extraConfig = ''
    #       set -g @continuum-restore 'on'
    #       set -g @continuum-save-interval '5' # minutes
    #     '';
    #   }
    # ];
    # terminal = "screen-256color";
    # escapeTime = 10;
    # historyLimit = 50000;
    # extraConfig = ''
    #   # Remove Vim mode delays
    #   set -g focus-events on

    #   # Enable full mouse support
    #   set -g mouse on

    #   # -----------------------------------------------------------------------------
    #   # Key bindings
    #   # -----------------------------------------------------------------------------

    #   # Unbind default keys
    #   unbind C-b
    #   unbind '"'
    #   unbind %

    #   # Split panes, vertical or horizontal
    #   bind-key x split-window -v
    #   bind-key v split-window -h

    #   # Move around panes with vim-like bindings (h,j,k,l)
    #   bind-key -n M-k select-pane -U
    #   bind-key -n M-h select-pane -L
    #   bind-key -n M-j select-pane -D
    #   bind-key -n M-l select-pane -R

    #   # Smart pane switching with awareness of Vim splits.
    #   # This is copy paste from https://github.com/christoomey/vim-tmux-navigator
    #   is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    #     | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
    #   bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
    #   bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
    #   bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
    #   bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
    #   tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
    #   if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
    #     "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
    #   if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
    #     "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

    #   bind-key -T copy-mode-vi 'C-h' select-pane -L
    #   bind-key -T copy-mode-vi 'C-j' select-pane -D
    #   bind-key -T copy-mode-vi 'C-k' select-pane -U
    #   bind-key -T copy-mode-vi 'C-l' select-pane -R
    #   bind-key -T copy-mode-vi 'C-\' select-pane -l
    #   '';
    # };
    # starship = {
    #   enable = true;
    #   enableZshIntegration = true;
    # };
    #
    # bat = {
    #   enable = true;
    #   config.theme = "TwoDark";
    # };
    #
    # fzf = {
    #   enable = true;
    #   enableZshIntegration = true;
    # };
    #
    # eza.enable = true;
    # git.enable = true;
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
      onChange="${pkgs.tmux} source ~/.config/tmux/tmux.conf.local";
    };
  };
}
