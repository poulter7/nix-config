# Copilot Instructions for nix-config

## Project Overview

This repository contains Nix configuration files for managing consistent development environments across multiple platforms:
- macOS (using nix-darwin)
- WSL2 (Windows Subsystem for Linux)
- Linux (including Parallels VMs)

The goal is to maintain similar look, feel, and tools across all machines to make switching between them seamless.

## Repository Structure

- `flakes/` - Nix flake configurations for different platforms
  - `darwin/` - macOS configuration
  - `linux-jonathan/` - WSL configuration
  - `linux-jpoulter/` - Linux configuration for jpoulter user
  - `linux-parallels/` - Ubuntu/Parallels VM configuration
- `modules/` - Reusable Nix modules
  - `darwin/` - macOS-specific system modules
  - `home-manager/` - Home Manager configurations (user-level packages and dotfiles)
  - `userpkgs.nix` - Common package definitions
- `justfile` - Just commands for common operations
- `treefmt.toml` - Tree formatter configuration for Nix files

## Key Technologies

- **Nix/NixOS** - Declarative package management and system configuration
- **Home Manager** - User environment management
- **nix-darwin** - macOS system configuration
- **nixvim** - Neovim configuration in Nix
- **Fish shell** - Default shell configuration
- **Just** - Command runner (similar to make)

## Coding Conventions

### Nix Files
- Use `nixfmt` for formatting (configured in `treefmt.toml`)
- Follow functional programming principles
- Keep configurations modular and composable
- Use `let...in` blocks for complex expressions
- Prefer explicit imports over implicit ones

### Module Organization
- Each module should have a `default.nix` entry point
- User-specific configurations should be parameterized with `user` and `userroot`
- Group related configurations together (e.g., all terminal-related configs in one place)

### File Structure
- System-level configurations go in `modules/darwin/`
- User-level configurations go in `modules/home-manager/`
- Package lists should be in `modules/userpkgs.nix`
- Flake configurations should reference modules from `../../modules/`

## Common Workflows

### Building and Installing

Use Just commands for common operations:

```bash
# macOS
just nix-install-mac
just nix-update-mac

# WSL
just nix-install-wsl
just nix-update-wsl

# Ubuntu/Parallels
just nix-install-ubuntu

# Other Linux environments
just nix-install-jonathan
just nix-install-jpoulter
```

### Formatting Code

Format Nix files using treefmt:
```bash
nix-shell -p treefmt --run 'treefmt'
```

Or format a specific file:
```bash
nixfmt <file.nix>
```

### Testing Changes

1. Make changes to configuration files
2. Rebuild the configuration for your platform using the appropriate Just command
3. Verify the changes take effect
4. If issues occur, previous generations can be rolled back

### Adding New Packages

1. For system-wide packages, add to `modules/userpkgs.nix`
2. For platform-specific packages, add to the appropriate flake or module
3. Rebuild using the appropriate Just command

### Working with Flakes

- Update flake inputs: `cd flakes/<platform> && nix flake update`
- Check flake: `nix flake check`
- Show flake info: `nix flake show`

## Special Considerations

### Windows/WSL Integration
- Windows-specific tools are managed via Scoop and Winget
- Configuration files are copied to Windows filesystem using `just windows-copy-configs`
- Komorebi (tiling window manager) configurations are in `modules/home-manager/komorebi/`

### macOS Considerations
- Uses nix-darwin for system-level configuration
- Homebrew integration via nix-homebrew
- Karabiner driver must be installed manually (see README)

### Path Conventions
- User home: `${userroot}/${user}` (e.g., `/Users/jonathan` or `/home/jonathan`)
- Projects: `~/Code/projects`
- Config root: `~/Code/projects/nix-config`

## Making Changes

When modifying this repository:

1. **Keep it modular** - Changes should be in appropriate modules
2. **Test on target platform** - Verify changes work on the intended system
3. **Update both system and user configs** - Consider both levels when making changes
4. **Maintain cross-platform compatibility** - Avoid breaking other platforms
5. **Use existing patterns** - Follow the established structure and conventions
6. **Document special cases** - Add comments for non-obvious configurations

## Important Files

- `README.md` - Installation and setup instructions
- `justfile` - Common commands and workflows
- `treefmt.toml` - Formatting configuration
- `flakes/*/flake.nix` - Platform-specific Nix flake definitions
- `modules/home-manager/default.nix` - Main home-manager configuration
- `modules/userpkgs.nix` - Package definitions

## Shell Configuration

The default shell is Fish, with automatic shell switching configured in `modules/home-manager/default.nix`. When opening a terminal, bash/zsh will automatically exec into Fish unless already in Fish or executing a script.

## Editor Configuration

- Default editor: Neovim (nvim)
- Neovim configuration: Kickstart-based setup in `modules/home-manager/kickstart.nvim/`
- VS Code extensions managed via `nix-vscode-extensions`
