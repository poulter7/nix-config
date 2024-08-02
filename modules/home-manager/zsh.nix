{ pkgs, lib, ... }: {
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
      ns = "darwin-rebuild switch --flake ~/Code/projects/mac-setup/.#mac";
      nb = "darwin-rebuild build --flake ~/Code/projects/mac-setup/.#mac";
      nix-up = "pushd ~/.config/snowflake; nix flake update; nixswitch; popd";
      nix-lint = "nix run --extra-experimental-features 'nix-command flakes' nixpkgs#statix -- check ."
      ls = "ls --color=auto";
      ll = "ls -lahrts";
      l = "ls -l";
      lg = "lazygit";
      vi = "nvim";
      python = "python3";
      k = "kubectl";
      tmux = "TERM=screen-256color-bce tmux";
      docker-clean = "docker rmi $(docker images -f 'dangling=true' -q)";
      resource = ". ~/.zshrc";
    };

    initExtra = ''
      export ZSH="/Users/jpoulter/.oh-my-zsh"
      # from: https://github.com/NixOS/nixpkgs/issues/154696
      source ~/.p10k.zsh
      export EDITOR=vi
      export TERM=xterm-256color
      export LANG=en_US.UTF-8
      export POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

      # set up shell integrations
      source <(fzf --zsh)
      
      # gitgone
      git config --global alias.gone "! git fetch -p && git for-each-ref --format '%(refname:short) %(upstream:track)' | awk '\$2 == \"[gone]\" {print \$1}' | xargs -r git branch -D"


      # And enable this
      # if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
      #   . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      # fi
      #
      
      
      '';
    plugins = [
      {
        # A prompt will appear the first time to configure it properly
        # make sure to select MesloLGS NF as the font in Konsole
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
    oh-my-zsh = {
      enable = true;
      # theme = "spaceship";
      plugins = [ 
        "aws"
        "git"  
        "terraform" 
        "history" 
        "history-substring-search" 
        "tmux"
      ];
    };
  };
}