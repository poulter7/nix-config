{ pkgs, ... }: {
  # .zshenv
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;

    history = {
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      save = 1000000;
      size = 1000000;
    };

    shellAliases = {
      nix-switch = "darwin-rebuild switch --flake ~/Code/projects/mac-setup/.#mac";
      nix-up = "pushd ~/.config/snowflake; nix flake update; nixswitch; popd";
      ls = "ls --color=auto";
      ll = "ls -lahrts";
      l = "ls -l";
      lg = "lazygit";
      vi = "nvim";
      python = "python3";
      k = "kubectl";
      tmux = "TERM=screen-256color-bce tmux";
      felix = "ssh felix@209.133.204.26 -p 13031";
      docker-clean = "docker rmi $(docker images -f 'dangling=true' -q)";
      resource = ". ~/.zshrc";
    };

    initExtra = ''
      # SPACESHIP_SCALA_SHOW=false
      export ZSH="/Users/jpoulter/.oh-my-zsh"
      export EDITOR=vi
      export TERM=xterm-256color
      export LANG=en_US.UTF-8

      # And enable this
      # if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
      #   . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      # fi
      '';

    oh-my-zsh = {
      enable = true;
      # theme = "spaceship";
      plugins = [ 
        "aws"
        "git" 
        # "docker" 
        "terraform" 
        "history" 
        "history-substring-search" 
      ];
    };
  };
}