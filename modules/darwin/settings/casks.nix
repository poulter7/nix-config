{ lib, ... }: {
  homebrew = {
    enable = true;
    brews = [
      "swiftlint"
    ];
    casks = [
      "iterm2"
      "spotify"
      "docker"
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
    ];
  };
}
