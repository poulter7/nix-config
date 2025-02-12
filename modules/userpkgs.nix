{pkgs, ...} :{
    nix = {
        fishPlugins = with pkgs.fishPlugins; [
            tide
            grc
            done
        ];
        shells = with pkgs; [
            bash
        ];
        utils = with pkgs; [
            grc
            ripgrep
            tree
            lazygit
            jump
            fzf
            git
            duckdb
            shfmt
            jump
            neovim
            terraform
            nodejs_20
            uv
            yarn
            typescript
            gh
            fd
            jujutsu
            ollama
            wezterm
            clang
            unzip
        ];
    };
    homebrew = {
        brews = [
            "graphviz"
            "swiftlint"
            "entr"
            "zoxide"
            "zig"
            "awscli"
            "spotify_player"
            "yazi"
            "llama.cpp"
            "huggingface-cli"
            "asitop"
        ];
        casks = [
            "sunsama"
            "docker"
            "spotify"
            "postman"
            "zoom"
            "whatsapp"
            "amethyst"
            "dash"
            "texshop"
            "trader-workstation"
            "ibkr"
            "raycast"
            "visual-studio-code"
            "skim"
            "bruno"
            "google-chrome"
            "todoist"
            "karabiner-elements"
            "steam"
            "sublime-text"
            "logi-options+"
            "readdle-spark"
            "cursor"
            "jetbrains-toolbox"
            "chatgpt"
            "qgis"
            "active-trader-pro"
            "caffeine"
            "font-hack-nerd-font"
            "virtual-desktop-streamer"
        ];
    };
}
