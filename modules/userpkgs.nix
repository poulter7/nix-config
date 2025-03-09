{pkgs, lib, ...} :{ nix = {
        fishPlugins = with pkgs.fishPlugins; [
            done
        ];
        shells = with pkgs; [
            bash
        ];
        utils = with pkgs; [
            delta
            bat
            eza
            curl
            python312Full
            grc
            starship
            ripgrep
            tree
            lazygit
            jump
            fzf
            git
            duckdb
            shfmt
            jump
            terraform
            nodejs_20
            uv
            yarn
            typescript
            gh
            fd
            jujutsu
            ollama
            unzip
            go
            lynx
            pass
            gnupg
            mutt-wizard
            isync
            gnused
            markdownlint-cli
            nerd-fonts.commit-mono
            ruff
            typst
            typstyle
            zellij
            nix-search-cli
            just
            micromamba
            qpdf
            (lib.mkIf pkgs.stdenv.isLinux pkgs.strace) # only available on Linux
            (hiPrio clang) # high priority as c++ bin collides with gcc
            (lib.mkIf pkgs.stdenv.isLinux pkgs.gcc) # installed via brew on mac
        ];
    };
    homebrew = {
        brews = [
            "gcc"
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
            "openblas"
            "lapack"
        ];
        casks = [
            "wezterm"
            "gimp"
            "slack"
            "akiflow"
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
            "karabiner-elements"
            "steam"
            "sublime-text"
            "logi-options+"
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
