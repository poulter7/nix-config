{ lib, ... }: {
  homebrew = {
    enable = true;
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
    ];
  };
}
