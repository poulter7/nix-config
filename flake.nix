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
  };

outputs = inputs@{ nixpkgs, home-manager, nixvim, darwin, ... }: {
    darwinConfigurations.personal = darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      pkgs = import nixpkgs { 
        system = "x86_64-darwin";
        config.allowUnfree = true; 
      };
      modules = [
        ./modules/darwin
        home-manager.darwinModules.home-manager
        {
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
      ];
    };
  };
}
