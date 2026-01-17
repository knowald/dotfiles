#!/bin/bash
# Import local configs from another machine
# Decrypts age-encrypted archive

set -e

ARCHIVE="$1"

if [ -z "$ARCHIVE" ] || [ ! -f "$ARCHIVE" ]; then
    echo "Usage: ./import_local.sh <archive.tar.gz.age>"
    echo ""
    echo "Example: ./import_local.sh ~/dotfiles_local_20240115_143022.tar.gz.age"
    exit 1
fi

echo "=== Importing Local Configs ==="
echo ""

# Create temp directory
IMPORT_DIR=$(mktemp -d)

# Decrypt and extract
echo "Decrypting archive..."
age -d "$ARCHIVE" | tar -xzf - -C "$IMPORT_DIR"

# Files to import and their destinations
declare -A FILES=(
    [".secrets"]="$HOME/.secrets"
    [".zshrc.local"]="$HOME/.zshrc.local"
    ["config.local"]="$HOME/.ssh/config.local"
    [".gitconfig.local"]="$HOME/.gitconfig.local"
)

# Ensure directories exist
mkdir -p "$HOME/.ssh"

# Import files
for name in "${!FILES[@]}"; do
    src="$IMPORT_DIR/$name"
    dest="${FILES[$name]}"

    if [ -f "$src" ]; then
        if [ -f "$dest" ]; then
            echo "  ! $(basename $dest) exists, backing up..."
            mv "$dest" "$dest.bak.$(date +%s)"
        fi
        cp "$src" "$dest"
        chmod 600 "$dest"
        echo "  ✓ $(basename $dest)"
    fi
done

# Clean up
rm -rf "$IMPORT_DIR"

echo ""
echo "=== Import Complete ==="
echo ""
echo "Restart your terminal or run: source ~/.zshrc"
echo ""
echo "You can now delete the archive: rm $ARCHIVE"
