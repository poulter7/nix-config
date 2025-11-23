# Testing Guide for nix-config

This repository includes comprehensive testing infrastructure to validate that Nix packages and configurations work as expected.

## Overview

The testing infrastructure includes:

1. **Flake checks** - Automated tests run via `nix flake check`
2. **Build tests** - Verify configurations can be built successfully
3. **Smoke tests** - Quick validation that critical packages work
4. **Integration tests** - Verify system-level configuration correctness

## Running Tests

### Quick Start

Run tests for a specific configuration:

```bash
# Test macOS configuration
just test-mac

# Test Linux WSL configuration (jonathan)
just test-jonathan

# Test Linux configuration (jpoulter)
just test-jpoulter

# Test Coder/generic Linux configuration
just test-coder

# Test Ubuntu/Parallels configuration
just test-ubuntu

# Run all tests
just test-all
```

### Manual Testing

You can also run tests manually using `nix flake check`:

```bash
# Test a specific flake
cd flakes/coder
nix flake check --show-trace

# For more verbose output
nix flake check --show-trace -L
```

### Build Tests

Build tests verify that the entire configuration can be built without actually applying it:

```bash
# Test building configurations
just build-test-coder
just build-test-jonathan
just build-test-jpoulter
just build-test-ubuntu
just build-test-mac
```

These commands build the activation package but don't install it, allowing you to catch errors before deployment.

## Test Types

### 1. Smoke Tests

Smoke tests verify that critical packages are available and can execute basic commands:

- `git` - Version control
- `nvim` - Text editor
- `fish` - Shell
- `fzf` - Fuzzy finder
- `ripgrep` - Text search

These tests check that:
- The package is available in PATH
- Basic commands (--version or --help) work

### 2. Build Tests

Build tests ensure that packages can be built successfully:

- Validates package derivations are correct
- Catches build-time errors
- Verifies dependencies are available

### 3. Integration Tests

Integration tests validate system-level configuration:

- **shell-environment-test** - Verifies shell environment is properly configured
- **userpkgs-loads** - Tests that the userpkgs module loads correctly
- **home-manager-config** - Validates home-manager configuration builds

### 4. Configuration Tests

Platform-specific tests:

- **darwin-config** (macOS) - Validates nix-darwin configuration structure
- **home-manager-config** (Linux) - Validates home-manager configuration

## Adding New Tests

### Adding a Package Test

To test a new package, edit `tests/default.nix`:

```nix
smoke-tests = {
  # Existing tests...
  
  # Add your new test
  mynewpackage = mkPackageTest "mynewpackage" pkgs.mynewpackage;
};
```

### Adding a Custom Test

For custom validation logic, add a new test derivation:

```nix
my-custom-test = pkgs.runCommand "test-my-feature" {} ''
  echo "Testing my feature..."
  
  # Your test logic here
  if [ condition ]; then
    echo "✓ Test passed"
    mkdir -p $out
    echo "success" > $out/result
  else
    echo "✗ Test failed"
    exit 1
  fi
'';
```

Then reference it in your flake's checks section.

## CI/CD Integration

Tests are designed to be run in CI/CD pipelines. The GitHub Actions workflow (if configured) can run:

```yaml
- name: Run tests
  run: |
    nix flake check --all-systems
```

## Troubleshooting

### Test Failures

If tests fail:

1. Run with verbose output:
   ```bash
   nix flake check --show-trace -L
   ```

2. Check specific test:
   ```bash
   nix build .#checks.x86_64-linux.git
   ```

3. Review test output for error messages

### Common Issues

**Issue**: "error: attribute 'checks' missing"
- **Solution**: Ensure your flake.nix includes the checks output section

**Issue**: Tests pass but installation fails
- **Solution**: Run build-test commands to validate full configuration

**Issue**: Platform-specific test failures
- **Solution**: Some tests may be platform-specific (e.g., darwin-only). Check the system attribute.

## Best Practices

1. **Run tests before committing** - Catch issues early
   ```bash
   just test-all
   ```

2. **Test on target platform** - If possible, test on the actual platform where you'll deploy

3. **Add tests for new packages** - When adding packages to userpkgs.nix, consider adding tests

4. **Use build-test before install** - Validate configurations before applying them:
   ```bash
   just build-test-coder
   just nix-install-coder
   ```

5. **Keep tests fast** - Smoke tests should complete quickly. Reserve longer tests for CI/CD.

## Test Architecture

The testing infrastructure is organized as follows:

```
nix-config/
├── tests/
│   └── default.nix          # Test definitions
├── flakes/
│   ├── coder/flake.nix      # Includes checks output
│   ├── darwin/flake.nix     # Includes checks output
│   └── ...                  # Other flakes with checks
└── justfile                 # Test commands
```

Each flake imports tests from `tests/default.nix` and exposes them via the `checks` output, which is the standard Nix flake testing mechanism.

## Further Reading

- [Nix Flakes - Checks Output](https://nixos.wiki/wiki/Flakes#Output_schema)
- [NixOS Testing](https://nixos.org/manual/nixos/stable/index.html#sec-nixos-tests)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
