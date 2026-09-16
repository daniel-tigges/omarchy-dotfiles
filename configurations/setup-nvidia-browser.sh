#!/usr/bin/env bash
# ==============================================================================
# Setup NVIDIA GPU Offload Browser (Brave) with dedicated profile
# ==============================================================================
set -euo pipefail

echo "==> Configuring NVIDIA GPU Offload Browser..."

# 1. Install nvidia-prime if missing
if ! pacman -Qi nvidia-prime &>/dev/null; then
    echo " -> nvidia-prime package not installed."
    if [ -t 0 ] || sudo -n true 2>/dev/null; then
        echo " -> Installing nvidia-prime package..."
        if command -v omarchy &>/dev/null; then
            omarchy pkg add nvidia-prime || true
        else
            yay -S --noconfirm --needed nvidia-prime || true
        fi
    fi
fi

# Ensure prime-run script is available in ~/.local/bin/prime-run as fallback/convenience
mkdir -p "$HOME/.local/bin"
if ! command -v prime-run &>/dev/null; then
    cat > "$HOME/.local/bin/prime-run" << 'EOF'
#!/usr/bin/env bash
__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia __VK_LAYER_NV_optimus=NVIDIA_only exec "$@"
EOF
    chmod +x "$HOME/.local/bin/prime-run"
    echo " -> Created fallback ~/.local/bin/prime-run"
fi

# 2. Create launcher binary in ~/.local/bin/brave-nvidia
mkdir -p "$HOME/.local/bin"
cat > "$HOME/.local/bin/brave-nvidia" << 'EOF'
#!/usr/bin/env bash
# Launch Brave with NVIDIA PRIME render offload
export __NV_PRIME_RENDER_OFFLOAD=1
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export __VK_LAYER_NV_optimus=NVIDIA_only

# Native Wayland Ozone forces rendering on the compositor's Intel DRM render node.
# Chromium requires X11/XWayland mode and disabled GPU sandbox for NVIDIA PRIME offload.
exec /opt/brave-origin-bin/brave-origin \
    --ozone-platform=x11 \
    --disable-gpu-sandbox \
    --password-store=gnome-libsecret \
    --enable-features=TouchpadOverscrollHistoryNavigation \
    --load-extension=/usr/share/omarchy/default/chromium/extensions/copy-url,/usr/share/omarchy/default/chromium/extensions/yt-dlp,/usr/share/omarchy/default/chromium/extensions/whatsapp-slim \
    --user-data-dir="${XDG_CONFIG_HOME:-$HOME/.config}/BraveSoftware/Brave-Origin-Nvidia" \
    --class="brave-nvidia" \
    "$@"
EOF
chmod +x "$HOME/.local/bin/brave-nvidia"
echo " -> Created ~/.local/bin/brave-nvidia"

# 3. Create .desktop file in ~/.local/share/applications/brave-nvidia.desktop
mkdir -p "$HOME/.local/share/applications"
cat > "$HOME/.local/share/applications/brave-nvidia.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Name=Brave (NVIDIA High Performance)
GenericName=Web Browser (NVIDIA GPU)
Comment=Access the Internet using dedicated NVIDIA GPU
Exec=brave-nvidia %U
Terminal=false
Icon=brave-origin
Type=Application
Categories=Network;WebBrowser;
StartupWMClass=brave-nvidia
MimeType=x-scheme-handler/http;x-scheme-handler/https;text/html;
Actions=new-window;new-private-window;

[Desktop Action new-window]
Name=New Window
Exec=brave-nvidia

[Desktop Action new-private-window]
Name=New Incognito Window
Exec=brave-nvidia --incognito
EOF
echo " -> Created ~/.local/share/applications/brave-nvidia.desktop"

# 4. Ensure keybinding in ~/.config/hypr/bindings.lua
BINDINGS_FILE="$HOME/.config/hypr/bindings.lua"
if [[ -f "$BINDINGS_FILE" ]] && ! grep -q "brave-nvidia" "$BINDINGS_FILE"; then
    cat >> "$BINDINGS_FILE" << 'EOF'

-- launch browser on dedicated NVIDIA GPU
o.bind("SUPER + ALT + B", "Browser (NVIDIA)", { launch = "brave-nvidia" })
EOF
    echo " -> Added SUPER + ALT + B binding to $BINDINGS_FILE"
fi

# Update desktop database if available
if command -v update-desktop-database &>/dev/null; then
    update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true
fi

echo "✅ NVIDIA Browser setup completed."
