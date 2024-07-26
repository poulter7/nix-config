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
  };

outputs = inputs@{ nixpkgs, home-manager, nixvim, darwin, nix-homebrew, homebrew-core, homebrew-cask, ... }: {
    darwinConfigurations.mac = darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      pkgs = import nixpkgs { 
        system = "x86_64-darwin";
        config.allowUnfree = true; 
      };
      modules = [
        ./modules/darwin
        home-manager.darwinModules.home-manager {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.jonathan.imports = [ 
	            # NixVim module
              nixvim.homeManagerModules.nixvim 
              ./modules/home-manager 
            ];
          };
        }
        nix-homebrew.darwinModules.nix-homebrew {
          nix-homebrew = {
            user = "jonathan";
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
