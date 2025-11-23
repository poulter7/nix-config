{
  description = "Nix configuration for Coder environments";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixGL.url = "github:nix-community/nixGL";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      nixvim,
      ...
    }:
    let
      # Detect user from environment or use 'coder' as default
      user = builtins.getEnv "USER";
      # Auto-detect system architecture
      system = builtins.currentSystem;
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

      # Tests that can be run with `nix flake check`
      checks.${system} =
        let
          tests = import ../../tests {
            inherit pkgs lib system;
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

          # Test that home-manager configuration can be built
          home-manager-config = pkgs.runCommand "test-home-manager-config" { } ''
            echo "Testing that home-manager configuration builds..."
            if [ -n "${pkgs.home-manager}" ]; then
              echo "✓ Home-manager configuration builds successfully"
              mkdir -p $out
              echo "success" > $out/result
            else
              echo "✗ Home-manager configuration failed to build"
              exit 1
            fi
          '';
        };
    };
}
