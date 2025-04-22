{
  description = "Nix OS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable"; # nixos-23.11
    nixGL.url = "github:nix-community/nixGL";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      nixvim,
      ...
    }:
    let
      user = "parallels";
      system = "aarch64-linux";
      userroot = "/home";
      pkgs = import nixpkgs {
        system = system;
        config.allowUnfree = true;
      };
    in
    {
      homeConfigurations.${user} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          nixvim.homeManagerModules.nixvim
          (import ../../modules/home-manager {
            inputs = inputs;
            user = user;
            userroot = userroot;
            pkgs = pkgs;
          })
          {
            home.username = user;
            home.homeDirectory = "${userroot}/${user}";
            home.stateVersion = "24.11";
          }
        ];
      };
    };
}
