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
      NVIM_APPNAME="nvim-nixos";
    };
  };

  #launches fish unless the parent process is already fish
  programs.fish = {
    enable = true;
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
      va = "NVIM_APPNAME=nvim-nixos nvim $argv";
      vk = "NVIM_APPNAME=nvim-kickstart nvim $argv";
      jump = "${pkgs.jump}/bin/jump";
    };
    shellInit= ''
      set fish_greeting # Disable greeting
      ${pkgs.jump}/bin/jump shell fish | source
    '';
    plugins = with pkgs.fishPlugins; [
      { name = "tide"; src = tide.src; }
      { name = "grc"; src = grc.src; }
      { name = "done"; src = done.src; }
    ];
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
    p10k = {
      source=./zsh/p10k.zsh;
      target=".p10k.zsh";
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
      source=config.lib.file.mkOutOfStoreSymlink "${root}/modules/home-manager/kickstart";
    };
    ".config/nvim-nixos" = {
      source=config.lib.file.mkOutOfStoreSymlink "${root}/modules/home-manager/astronvim";
    };
  };
}
