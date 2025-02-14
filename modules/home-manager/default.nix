{user, userroot}: { pkgs, config, osConfig, lib, ... }: 
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
  in {

  home = {
    username = "${user}";
    homeDirectory = "${userroot}/${user}";
    packages = userpkgs.nix.utils ++ userpkgs.nix.fishPlugins;
    sessionVariables = {
      PAGER = "less";
      CLICLOLOR = 1;
      EDITOR = "nvim";
      NVIM_APPNAME="nvim-kickstart";
    };
  };

  programs.bash.enable = true;
  programs.bash.initExtra = shellSwitch;
  programs.zsh.enable = true;
  programs.zsh.initExtra = shellSwitch;

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
      jump = "${pkgs.jump}/bin/jump";
      rename-tab = "${pkgs.wezterm}/bin/wezterm cli set-tab-title";
      jbm = "jj bookmark move main --to @-";
      jgp = "jj git push";
      jdm = "jj describe -m ";
    };
    shellInit= ''
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
      fish_vi_key_bindings
      set fish_greeting # Disable greeting
	if test (uname) = "Darwin"
	    eval "$(/opt/homebrew/bin/brew shellenv)"
	end
      ${pkgs.jujutsu}/bin/jj util completion fish | source
      ${pkgs.jump}/bin/jump shell fish | source
 #      ${pkgs.ollama}/bin/ollama serve  > /dev/null 2>&1 || true
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
    ".config/libexec/aerc/stylesets" = {
      source=config.lib.file.mkOutOfStoreSymlink "${root}/modules/home-manager/aerc/stylesets";
    };
  };
}
