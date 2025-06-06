{
  inputs,
  user,
  userroot,
  pkgs,
}:
{
  pkgs,
  config,
  osConfig,
  lib,
  ...
}:
let
  root = "${userroot}/${user}/Code/projects/nix-config";
  userpkgs = import ../userpkgs.nix pkgs;
  shellSwitch = ''
    if [[ $(${pkgs.procps}/bin/ps -p "$PPID" -o comm=) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
            # Handle login shell detection for both bash and zsh
            LOGIN_OPTION=""
            if [[ -n "$BASH" ]]; then
                shopt -q login_shell && LOGIN_OPTION="--login"
            elif [[ -n "$ZSH_VERSION" ]]; then
                [[ -o login ]] && LOGIN_OPTION="--login"
            fi
            
            # Execute fish with proper login option
            exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
    fi
  '';
in
{

  home = {
    username = "${user}";
    homeDirectory = "${userroot}/${user}";
    packages = userpkgs.nix.utils ++ userpkgs.nix.fishPlugins;
    sessionVariables = {
      PAGER = "less";
      CLICLOLOR = 1;
      EDITOR = "nvim";
      NVIM_APPNAME = "nvim-kickstart";
      SHELL = "fish";
      DEBUGPY_EXCEPTION_FILTER_USER_UNHANDLED = 1;
      PYTORCH_ENABLE_MPS_FALLBACK = 1;
    };
  };
  programs.neovim = {
    enable = true;
    extraLuaPackages = p: [
      p.mimetypes
      p.luarocks
      p.xml2lua
      p.magick
    ];
    extraPython3Packages =
      ps: with ps; [
        # ... other python packages
        pynvim
        jupyter-client
        # cairosvg # for image rendering
        # pnglatex # for image rendering
        # plotly # for image rendering
        # pyperclip
      ];
  };
  programs.neomutt.enable = true;

  programs.bash.enable = true;
  programs.bash.initExtra = shellSwitch;
  programs.zsh.enable = true;
  programs.zsh.initExtra = shellSwitch;

  #launches fish unless the parent process is already fish
  programs.fish = {
    enable = true;
    shellAliases = {
      t = "task";
      tu = "taskwarrior-tui";
      kanata-tray = "sudo env KANATA_TRAY_CONFIG_DIR=/Users/jonathan/.config/kanata /Users/jonathan/Applications/kanata-tray-macos";
      kanata-mbp = "sudo kanata -c /Users/jonathan/.config/kanata/kanata-mbp.lsp -n";
      kanata-hhkb = "sudo kanata -c /Users/jonathan/.config/kanata/kanata-hhkb.lsp -n";
      sp = "spotify_player";
      ns = "darwin-rebuild switch --flake ~/Code/projects/nix-config/.#mac";
      nb = "darwin-rebuild build --flake ~/Code/projects/nix-config/.#mac";
      nix-up = "pushd ~/.config/snowflake; nix flake update; nixswitch; popd";
      nix-lint = "nix run --extra-experimental-features 'nix-command flakes' nixpkgs#statix -- check .";
      open-api-refresh = "npx @rtk-query/codegen-openapi src/rtk/api/openapi-config.json";
      lg = "lazygit";
      v = "nvim";
      m = "neomutt";
      python = "python3";
      k = "kubectl";
      tf = "terraform";
      docker-clean = "docker rmi $(docker images -f 'dangling=true' -q)";
      jump = "${pkgs.jump}/bin/jump";
      rename-tab = "${pkgs.wezterm}/bin/wezterm cli set-tab-title";
      jjpush-main = "jj bookmark move main --to 'git_head()' && jj git push";
      jjpush-master = "jj bookmark move master --to 'git_head()' && jj git push";
      jjdesc = "jj describe -m ";
      jjdiff = "jj diff";
      cat = "bat";
      ls = "eza";
      f = "yazi";
    };
    shellInit = ''
            # if set -q ZELLIJ
            # else
            #   zellij a -c base
            # end
            function fish_mode_prompt
            switch $fish_bind_mode
              case default
                set_color --bold red
                echo '[N]'
              case insert
                set_color --bold green
                echo '[I]'
              case replace_one
                set_color --bold green
                echo '[R]'
              case replace
                set_color --bold green
                echo '[R]'
              case visual
                set_color --bold brmagenta
                echo '[V]'
              case '*'
                set_color --bold red
                echo '[?]'
            end
            set_color normal
          end
            function starship_transient_rprompt_func
              ${pkgs.starship}/bin/starship module cmd_duration; ${pkgs.starship}/bin/starship module time
            end
            git config --global init.defaultBranch main
            ${pkgs.starship}/bin/starship init fish | source
            enable_transience
            fish_vi_key_bindings
            set fish_greeting # Disable greeting
      	if test (uname) = "Darwin"
      	    eval "$(/opt/homebrew/bin/brew shellenv)"
      	end
            COMPLETE=fish ${pkgs.jujutsu}/bin/jj | source
            ${pkgs.jump}/bin/jump shell fish | source
            ${pkgs.just}/bin/just --completions fish | source
            ${pkgs.starship}/bin/starship init fish | source
            ${pkgs.micromamba}/bin/micromamba shell hook --shell fish | source
            export OLLAMA_API_BASE=http://127.0.0.1:8080
            export OPENAI_API_BASE=http://127.0.0.1:8080
            export OPENAI_API_KEY=key
            if test -f ~/private-tokens.fish
                source ~/private-tokens.fish
            end
    '';
    plugins = builtins.map (p: {
      name = p.name;
      src = p.src;
    }) userpkgs.nix.fishPlugins;
  };

  # home.file.".inputrc".source = ./settings/inputrc;
  # Don't change this when you change package input. Leave it alone.
  home.stateVersion = "24.11";
  home.file = {
    amethyst = {
      source = ./amethyst/amethyst.yml;
      target = ".config/amethyst/amethyst.yml";
      onChange = "/usr/bin/pkill Amethyst; /usr/bin/open -a Amethyst";
    };
    opal = {
      source = ../darwin/apps/Opal.app;
      target = "./Applications/Opal.app";
      recursive = true;
    };
    bd = {
      source = ../darwin/apps/BetterDisplay.app;
      target = "./Applications/BetterDisplay.app";
      recursive = true;
    };
    kanata-tray = {
      source = ../darwin/apps/kanata-tray-macos;
      target = "./Applications/kanata-tray-macos";
    };
    ideavimrc = {
      source = ./idea/.ideavimrc;
      target = ".ideavimrc";
    };
    screenshots = {
      source = ./screenshots/.keep;
      target = "Screenshots/.keep";
      recursive = true;
    };
    wezterm = {
      target =
        if pkgs.stdenv.isDarwin then ".config/wezterm" else "/mnt/c/Users/jonathan/.config/wezterm";
      source = config.lib.file.mkOutOfStoreSymlink "${root}/modules/home-manager/wezterm";
    };
    ".config/task" = {
      source = config.lib.file.mkOutOfStoreSymlink "${root}/modules/home-manager/taskwarrior";
    };
    ".config/mutt" = {
      source = config.lib.file.mkOutOfStoreSymlink "${root}/modules/home-manager/mutt";
    };
    ".config/kanata" = {
      source = config.lib.file.mkOutOfStoreSymlink "${root}/modules/home-manager/kanata";
    };
    "Library/Application Support/kanata-tray" = {
      source = config.lib.file.mkOutOfStoreSymlink "${root}/modules/home-manager/kanata-tray";
    };
    ".config/neomutt" = {
      source = config.lib.file.mkOutOfStoreSymlink "${root}/modules/home-manager/neomutt";
    };
    ".config/nvim-kickstart" = {
      source = config.lib.file.mkOutOfStoreSymlink "${root}/modules/home-manager/kickstart.nvim";
    };
    ".config/zellij" = {
      source = config.lib.file.mkOutOfStoreSymlink "${root}/modules/home-manager/zellij";
    };
    ".config/starship.toml" = {
      source = config.lib.file.mkOutOfStoreSymlink "${root}/modules/home-manager/starship/starship.toml";
    };
  };
}
