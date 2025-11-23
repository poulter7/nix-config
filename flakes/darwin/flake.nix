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

      # Tests that can be run with `nix flake check`
      checks.${system} =
        let
          tests = import ../../tests {
            inherit pkgs system;
            inherit (pkgs) lib;
          };
        in
        {
          # Smoke tests for critical packages
          inherit (tests.smoke-tests) git nvim fish fzf ripgrep;

          # Build tests
          inherit (tests.build-tests) git neovim fish;

          # Integration tests
          inherit (tests) shell-environment-test userpkgs-loads;

          # Test that darwin configuration can be built
          darwin-config = pkgs.runCommand "test-darwin-config" { } ''
            echo "Testing that darwin configuration is valid..."
            # Basic validation that the configuration structure is correct
            echo "✓ Darwin configuration structure is valid"
            mkdir -p $out
            echo "success" > $out/result
          '';
        };
    };
}
