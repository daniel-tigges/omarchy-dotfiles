# Directory containing all your stow packages (default: current directory)
STOW_DIR="$DOTFILES_PATH/dotfiles"
TARGET_DIR="$HOME"

echo "Using stow packages from: $STOW_DIR"
echo "Symlinking into: $TARGET_DIR"
echo

# Iterate through all subdirectories in STOW_DIR
for pkg in "$STOW_DIR"/*; do
    if [ -d "$pkg" ]; then
        pkg_name=$(basename "$pkg")
        echo "==> Stowing '$pkg_name'..."
        stow -d "$STOW_DIR" -t "$TARGET_DIR" --adopt --restow "$pkg_name"
    else
        echo "Skipping $(basename "$pkg") (not a directory)"
    fi
done

echo
echo "✅ All packages processed."
