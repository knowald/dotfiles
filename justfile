# Task runner for the dotfiles repo. Run `just` to list recipes.

# Show available recipes
default:
    @just --list

# Full machine setup (idempotent): brew, oh-my-zsh, symlinks, local configs
setup:
    ./macos_setup.sh

# Install everything in the Brewfile (no cleanup - leaves extra local installs alone)
brew-install:
    brew bundle install --file=Brewfile

# Report Brewfile entries that are not installed
brew-check:
    brew bundle check --file=Brewfile --verbose

# Show drift between installed packages and the curated Brewfile
brew-diff:
    #!/usr/bin/env bash
    set -euo pipefail
    brews=$(grep -E '^brew ' Brewfile | sed -E 's/^brew "([^"]+)".*/\1/' | awk -F/ '{print $NF}' | sort -u)
    casks=$(grep -E '^cask ' Brewfile | sed -E 's/^cask "([^"]+)".*/\1/' | sort -u)
    echo "## Installed leaves NOT in Brewfile (consider adding):"
    comm -23 <(brew leaves | awk -F/ '{print $NF}' | sort -u) <(echo "$brews") || true
    echo
    echo "## Brewfile formulae NOT installed:"
    comm -13 <(brew list --formula | awk -F/ '{print $NF}' | sort -u) <(echo "$brews") || true
    echo
    echo "## Installed casks NOT in Brewfile (consider adding):"
    comm -23 <(brew list --cask | sort -u) <(echo "$casks") || true
    echo
    echo "## Brewfile casks NOT installed:"
    comm -13 <(brew list --cask | sort -u) <(echo "$casks") || true

# Update brew packages, plugins, and tldr cache
update:
    brew update && brew upgrade
    brew bundle install --file=Brewfile
    -tldr --update

# Apply macOS system defaults (review the script first; changes are system-wide)
defaults:
    ./macos_defaults.sh

# Lint shell scripts and run all pre-commit hooks
lint:
    pre-commit run --all-files
