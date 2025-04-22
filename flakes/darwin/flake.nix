{
  description = "Nix OS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable"; # nixos-23.11

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    mac-app-util.url = "github:hraban/mac-app-util";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    dooit.url = "github:dooit-org/dooit";
    dooit-extras.url = "github:dooit-org/dooit-extras";
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      nixvim,
      darwin,
      nix-homebrew,
      homebrew-core,
      homebrew-cask,
      mac-app-util,
      ...
    }:
    let
      user = "jonathan";
      system = "aarch64-darwin";
      userroot = "/Users";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        config.allowUnsupportedSystem = true;
      };
    in
    {
      darwinConfigurations.mac = darwin.lib.darwinSystem {
        inherit system;
        inherit pkgs;
        modules = [
          (import ../../modules/darwin {
            user = user;
            userroot = userroot;
          })
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users."${user}".imports = [
                # NixVim module
                nixvim.homeManagerModules.nixvim
                (import ../../modules/home-manager {
                  inputs = inputs;
                  user = user;
                  userroot = userroot;
                  pkgs = pkgs;
                })
                mac-app-util.homeManagerModules.default
              ];
            };
          }
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              inherit user;
              enable = true;
              taps = {
                "homebrew/homebrew-core" = homebrew-core;
                "homebrew/homebrew-cask" = homebrew-cask;
              };
            };
          }
        ];
      };
    };
}
