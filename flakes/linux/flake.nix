{
  description = "Nix OS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable"; # nixos-23.11

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

outputs = inputs@{ nixpkgs, home-manager, nixvim, ... }: 
    let
      user = "parallels";
      system = "aarch64-linux";
	userroot = "/home";
    in {
homeConfigurations.${user} = home-manager.lib.homeManagerConfiguration {
	pkgs = import nixpkgs { system = system;config.allowUnfree = true; };
	modules = [
nixvim.homeManagerModules.nixvim
(import ../../modules/home-manager {user=user; userroot=userroot; })
{
home.username = user;
home.homeDirectory = "${userroot}/${user}";
home.stateVersion = "24.11";
}
	];
  };
};
}

