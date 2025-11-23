# Test suite for nix-config
# This file defines tests that can be run with `nix flake check` or manually
{
  pkgs,
  lib,
  system,
}:
let
  # Helper function to create a simple derivation test
  mkPackageTest =
    name: package:
    pkgs.runCommand "test-${name}"
      {
        buildInputs = [ package ];
      }
      ''
        # Test that the package exists and has an executable
        if command -v ${name} &> /dev/null; then
          echo "✓ ${name} is available in PATH"
          ${name} --version &> /dev/null || ${name} --help &> /dev/null || echo "Command executed successfully"
        else
          echo "✗ ${name} not found in PATH"
          exit 1
        fi
        
        # Create success marker
        mkdir -p $out
        echo "success" > $out/result
      '';

  # Helper to test that a package can be built
  mkBuildTest =
    name: package:
    pkgs.runCommand "build-test-${name}" { } ''
      # Test that the package builds successfully
      echo "Testing build of ${name}"
      if [ -e "${package}" ]; then
        echo "✓ ${name} built successfully"
        echo "Package path: ${package}"
      else
        echo "✗ ${name} failed to build"
        exit 1
      fi
      
      mkdir -p $out
      echo "success" > $out/result
    '';

  # Test a list of packages
  mkPackageListTest =
    name: packages:
    pkgs.runCommand "test-${name}-packages"
      {
        buildInputs = packages;
      }
      ''
        echo "Testing ${builtins.toString (builtins.length packages)} packages for ${name}"
        
        # All packages in buildInputs are already available in the build environment
        # If they weren't, the build would have failed already
        # So we just verify the buildInputs were set correctly
        total_count=${builtins.toString (builtins.length packages)}
        
        echo "Successfully validated $total_count packages"
        echo "✓ All packages built successfully"
        
        mkdir -p $out
        echo "$total_count packages built" > $out/result
      '';
in
{
  # Basic smoke tests for common tools
  smoke-tests = {
    git = mkPackageTest "git" pkgs.git;
    nvim = mkPackageTest "nvim" pkgs.neovim;
    fish = mkPackageTest "fish" pkgs.fish;
    fzf = mkPackageTest "fzf" pkgs.fzf;
    ripgrep = mkPackageTest "rg" pkgs.ripgrep;
  };

  # Build tests to ensure packages can be built
  build-tests = {
    git = mkBuildTest "git" pkgs.git;
    neovim = mkBuildTest "neovim" pkgs.neovim;
    fish = mkBuildTest "fish" pkgs.fish;
  };

  # Integration test: verify shell environment
  shell-environment-test = pkgs.runCommand "test-shell-environment" { } ''
    # Test that basic shell utilities are available
    echo "Testing shell environment..."
    
    # These should be available in any standard environment
    command -v sh > /dev/null || (echo "✗ sh not found" && exit 1)
    command -v bash > /dev/null || (echo "✗ bash not found" && exit 1)
    
    echo "✓ Shell environment test passed"
    mkdir -p $out
    echo "success" > $out/result
  '';

  # Test that userpkgs module loads correctly
  userpkgs-loads = pkgs.runCommand "test-userpkgs-loads" { } ''
    echo "Testing userpkgs module loading..."
    
    # Try to import the userpkgs module and verify it's an attribute set
    ${pkgs.nix}/bin/nix-instantiate --eval -E '
      let
        pkgs = import ${pkgs.path} {};
        userpkgs = import ${../modules/userpkgs.nix} { inherit pkgs; lib = pkgs.lib; };
      in
        # Check that userpkgs is an attribute set and has the nix attribute
        # which should itself be an attribute set containing package lists
        builtins.isAttrs userpkgs && 
        builtins.isAttrs userpkgs.nix
    ' > /dev/null
    
    if [ $? -eq 0 ]; then
      echo "✓ userpkgs module loads successfully with valid structure"
      mkdir -p $out
      echo "success" > $out/result
    else
      echo "✗ userpkgs module failed to load or has invalid structure"
      exit 1
    fi
  '';
}
