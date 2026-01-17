#!/bin/bash
# Export local configs for transfer to another machine
# Encrypted with age - you'll be prompted for a passphrase

set -e

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
ARCHIVE="dotfiles_local_$TIMESTAMP.tar.gz.age"
TEMP_DIR=$(mktemp -d)

echo "=== Exporting Local Configs ==="
echo ""

# Files to export
FILES=(
    "$HOME/.secrets"
    "$HOME/.zshrc.local"
    "$HOME/.ssh/config.local"
    "$HOME/.gitconfig.local"
)

# Copy files that exist
for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        name=$(basename "$file")
        cp "$file" "$TEMP_DIR/$name"
        echo "  ✓ $name"
    else
        echo "  - $(basename $file) (not found, skipping)"
    fi
done

# Create tarball and encrypt with age (passphrase)
echo ""
echo "Creating encrypted archive..."
tar -czf - -C "$TEMP_DIR" . | age -p -o "$HOME/$ARCHIVE"

# Clean up temp files
rm -rf "$TEMP_DIR"

echo ""
echo "=== Export Complete ==="
echo ""
echo "Archive: ~/$ARCHIVE"
echo "Size: $(du -h "$HOME/$ARCHIVE" | cut -f1)"
echo ""
echo "Transfer securely to new machine, then run:"
echo "  ./import_local.sh ~/$ARCHIVE"
