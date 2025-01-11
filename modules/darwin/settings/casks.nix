{ lib, ... }: {
  homebrew = {
    enable = true;
    brews = [
      "swiftlint"
      "entr"
      "zoxide"
      "zig"
      "awscli"
    ];
    onActivation = {
autoUpdate = true;
cleanup = "uninstall";
upgrade = true;
};
    casks = [
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
      "wezterm"
      "ollama"
    ];
  };
}
