{ pkgs, config, osConfig, lib, ... }: 
  let
      user = "jonathan";
      root = "/Users/jonathan/Code/projects/nix-config";
      userpkgs = import ../userpkgs.nix pkgs;
  in {

  home = {
    username = "${user}";
    homeDirectory = "/Users/${user}";
    packages = userpkgs.nix.utils;
    sessionVariables = {
      PAGER = "less";
      CLICLOLOR = 1;
      EDITOR = "nvim";
      NVIM_APPNAME="nvim-kickstart";
    };
  };

  #launches fish unless the parent process is already fish
  programs.fish = {
    enable = true;
    shellAliases = {
      sp = "spotify_player";
      ns = "darwin-rebuild switch --flake ~/Code/projects/nix-config/.#mac";
      nb = "darwin-rebuild build --flake ~/Code/projects/nix-config/.#mac";
      nix-up = "pushd ~/.config/snowflake; nix flake update; nixswitch; popd";
      nix-lint = "nix run --extra-experimental-features 'nix-command flakes' nixpkgs#statix -- check .";
      open-api-refresh = "npx @rtk-query/codegen-openapi src/rtk/api/openapi-config.json";
      ls = "ls --color=auto";
      ll = "ls -lahrts";
      l = "ls -l";
      lg = "lazygit";
      v = "nvim";
      python = "python3";
      k = "kubectl";
      tf = "terraform";
      docker-clean = "docker rmi $(docker images -f 'dangling=true' -q)";
      resource = ". ~/.zshrc";
      nvim-astronvim = "NVIM_APPNAME=nvim-nixos nvim $argv";
      jump = "${pkgs.jump}/bin/jump";
      rename-tab = "wezterm cli set-tab-title";
    };
    shellInit= ''
      set fish_greeting # Disable greeting
      eval "$(/opt/homebrew/bin/brew shellenv)"
      ${pkgs.jujutsu}/bin/jj util completion fish | source
      ${pkgs.jump}/bin/jump shell fish | source
      ollama serve  > /dev/null 2>&1 || true
      # aider setup
      export ANTHROPIC_API_KEY=$(cat ~/secrets/anthropic.key)
      export OLLAMA_API_BASE=http://127.0.0.1:8080
      export OPENAI_API_BASE=http://127.0.0.1:8080
      export OPENAI_API_KEY=key
    '';
    plugins = builtins.map (p: { name = p.name; src = p.src; }) userpkgs.nix.fishPlugins;
  };

  # home.file.".inputrc".source = ./settings/inputrc;
  # Don't change this when you change package input. Leave it alone.
  home.stateVersion = "24.11";
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
    ".config/wezterm" = {
      source=config.lib.file.mkOutOfStoreSymlink "${root}/modules/home-manager/wezterm";
    };
    ".config/nvim-kickstart" = {
      source=config.lib.file.mkOutOfStoreSymlink "${root}/modules/home-manager/kickstart.nvim";
    };
    ".config/nvim-nixos" = {
      source=config.lib.file.mkOutOfStoreSymlink "${root}/modules/home-manager/astronvim";
    };
  };
}
