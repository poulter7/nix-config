{ pkgs, lib, ... }: {
  # .zshenv
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      save = 1000000;
      size = 1000000;
    };

    shellAliases = {
      ns = "darwin-rebuild switch --flake ~/Code/projects/nix-config/.#mac";
      nb = "darwin-rebuild build --flake ~/Code/projects/nix-config/.#mac";
      nix-up = "pushd ~/.config/snowflake; nix flake update; nixswitch; popd";
      nix-lint = "nix run --extra-experimental-features 'nix-command flakes' nixpkgs#statix -- check .";
      open-api-refresh = "npx @rtk-query/codegen-openapi src/rtk/api/openapi-config.json";
      ls = "ls --color=auto";
      ll = "ls -lahrts";
      l = "ls -l";
      lg = "lazygit";
      gg = "lazygit";
      vi = "nvim";
      python = "python3";
      k = "kubectl";
      tf = "terraform";
      docker-clean = "docker rmi $(docker images -f 'dangling=true' -q)";
      resource = ". ~/.zshrc";
      va = "NVIM_APPNAME=nvim-nixos nvim $@";
      vk = "NVIM_APPNAME=nvim-kickstart nvim $@";
    };

    initExtra = ''
      # shell integration for fzf
      source <(fzf --zsh)
      # shell integration for jump
      eval "$(jump shell zsh)"
      # shell integration for zoxide
      eval "$(zoxide init zsh)"

      # don't write __pycache__ files
      export PYTHONDONTWRITEBYTECODE=1
      
      # from: https://github.com/NixOS/nixpkgs/issues/154696
      source ~/.p10k.zsh
      export EDITOR=vi
      export TERM=xterm-256color
      export LANG=en_US.UTF-8
      export POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
      export NVIM_APPNAME=nvim-nixos
      
      # gitgone
      git config --global alias.gone "! git fetch -p && git for-each-ref --format '%(refname:short) %(upstream:track)' | awk '\$2 == \"[gone]\" {print \$1}' | xargs -r git branch -D"

      vv() {
        # Assumes all configs exist in directories named ~/.config/nvim-*
        local config=$(fd --max-depth 1 --glob 'nvim-*' ~/.config | fzf --prompt="Neovim Configs > " --height=~50% --layout=reverse --border --exit-0)
      
        # If I exit fzf without selecting a config, don't open Neovim
        [[ -z $config ]] && echo "No config selected" && return
      
        # Open Neovim with the selected config
        NVIM_APPNAME=$(basename $config) nvim $@
      }
      export PATH="$PATH:/opt/homebrew/bin"
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
      plugins = [ 
        "aws"
        "git"  
        "terraform" 
        "history" 
        "history-substring-search" 
    ];
    };
  };
}
