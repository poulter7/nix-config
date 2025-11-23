# Testing Examples

This file provides practical examples of using the testing infrastructure.

## Example 1: Testing After Adding a New Package

Let's say you want to add a new package `htop` to your configuration:

1. Add the package to `modules/userpkgs.nix`:
   ```nix
   utils = with pkgs; [
     # ... existing packages
     htop
   ];
   ```

2. Add a test for it in `tests/default.nix`:
   ```nix
   smoke-tests = {
     # ... existing tests
     htop = mkPackageTest "htop" pkgs.htop;
   };
   ```

3. Update the flake to include the test (already done in all flakes):
   ```nix
   checks.${system} = {
     inherit (tests.smoke-tests) git nvim fish fzf ripgrep htop;
   };
   ```

4. Run the test:
   ```bash
   just test-coder  # or whichever platform you're testing
   ```

## Example 2: Testing Configuration Changes

When making changes to home-manager configuration:

1. Make your changes to `modules/home-manager/default.nix`

2. Validate syntax and build:
   ```bash
   # Check if the configuration builds
   just build-test-coder
   
   # Run all tests
   just test-coder
   ```

3. If tests pass, apply the configuration:
   ```bash
   just nix-install-coder
   ```

## Example 3: Testing Before Committing

Before committing changes to the repository:

```bash
# Format all Nix files
just fmt

# Run all tests
just test-all

# If all tests pass, commit
git add .
git commit -m "Add htop package"
```

## Example 4: Running Individual Tests

To run a specific test:

```bash
# Run a single smoke test
cd flakes/coder
nix build .#checks.x86_64-linux.git

# Run with verbose output
nix build .#checks.x86_64-linux.git --show-trace -L

# See the test output
nix build .#checks.x86_64-linux.git --print-build-logs
```

## Example 5: Testing in CI/CD

The GitHub Actions workflow automatically runs tests on:
- Push to main/master
- Pull requests
- Manual workflow dispatch

To test locally what CI will run:

```bash
# For Linux x86_64
cd flakes/linux-jpoulter
nix flake check --show-trace

# For Coder
cd flakes/coder
nix flake check --show-trace

# For macOS (on macOS machine)
cd flakes/darwin
nix flake check --show-trace
```

## Example 6: Debugging Test Failures

If a test fails:

```bash
# Run with maximum verbosity
cd flakes/coder
nix flake check --show-trace -L --print-build-logs

# Check specific test
nix build .#checks.x86_64-linux.userpkgs-loads --show-trace

# Look at the test output
nix log .#checks.x86_64-linux.userpkgs-loads
```

## Example 7: Creating a Custom Integration Test

To add a custom test that validates your shell configuration:

1. Add to `tests/default.nix`:
   ```nix
   my-shell-test = pkgs.runCommand "test-my-shell" 
     { buildInputs = [ pkgs.fish pkgs.starship ]; }
     ''
       # Test that fish shell works with starship
       echo "Testing shell integration..."
       
       if command -v fish &> /dev/null && command -v starship &> /dev/null; then
         echo "✓ Shell components available"
         mkdir -p $out
         echo "success" > $out/result
       else
         echo "✗ Shell components missing"
         exit 1
       fi
     '';
   ```

2. Add to flake checks:
   ```nix
   checks.${system} = {
     # ... existing tests
     inherit (tests) my-shell-test;
   };
   ```

3. Run the test:
   ```bash
   cd flakes/coder
   nix build .#checks.x86_64-linux.my-shell-test
   ```

## Example 8: Testing Platform-Specific Packages

For packages that only work on certain platforms:

```nix
# In tests/default.nix
platform-tests = lib.optionalAttrs pkgs.stdenv.isDarwin {
  # macOS-only test
  test-darwin-tool = mkPackageTest "some-darwin-tool" pkgs.some-darwin-tool;
} // lib.optionalAttrs pkgs.stdenv.isLinux {
  # Linux-only test
  test-linux-tool = mkPackageTest "strace" pkgs.strace;
};
```

## Example 9: Batch Testing Multiple Configurations

Test all your configurations at once:

```bash
# Run tests for all platforms that can be built on your system
just test-all

# Or manually
for flake in flakes/*/; do
  echo "Testing $flake"
  cd "$flake"
  nix flake check --show-trace || echo "Failed: $flake"
  cd -
done
```

## Example 10: Pre-commit Hook

Create a git pre-commit hook to run tests automatically:

```bash
# Create .git/hooks/pre-commit
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
set -e

echo "Running Nix tests..."
just fmt-check || {
  echo "Format check failed. Run 'just fmt' to fix."
  exit 1
}

echo "Running quick tests..."
cd flakes/coder
nix flake check --show-trace

echo "Tests passed!"
EOF

chmod +x .git/hooks/pre-commit
```

This ensures all commits are tested before they're pushed to the repository.
