#!/usr/bin/env bash
set -e

# ──────────────────────────────────────────────
# Config
# ──────────────────────────────────────────────
REPO="KalaimaranB/openvpn_mg"
BRANCH="main"
SCRIPT_NAME="openvpnmg"
INSTALL_PATH="/usr/local/bin/$SCRIPT_NAME"
RAW_URL="https://raw.githubusercontent.com/$REPO/$BRANCH"
AUTOCOMP_BASE="$HOME/.config/openvpnmg/completions"

echo "🔧 Installing OpenVPN Manager..."

# ──────────────────────────────────────────────
# 1. Download the main script
# ──────────────────────────────────────────────
echo "⬇️  Downloading $SCRIPT_NAME from GitHub..."
sudo mkdir -p /usr/local/bin
curl -fsSL "$RAW_URL/$SCRIPT_NAME" -o "$SCRIPT_NAME"

# Verify download
if [[ ! -s "$SCRIPT_NAME" ]]; then
    echo "❌ Failed to download $SCRIPT_NAME from $RAW_URL"
    exit 1
fi

# Move to install location
sudo mv "$SCRIPT_NAME" "$INSTALL_PATH"
sudo chmod +x "$INSTALL_PATH"
echo "✅ Installed $SCRIPT_NAME to $INSTALL_PATH"

# ──────────────────────────────────────────────
# 2. Autocompletion setup (optional)
# ──────────────────────────────────────────────
read -rp "Do you want to enable autocompletion for bash/zsh/fish? (y/n): " choice

if [[ "$choice" =~ ^[Yy]$ ]]; then
    mkdir -p "$AUTOCOMP_BASE"

    # --- Bash ---
    if command -v bash >/dev/null 2>&1; then
        cat >"$AUTOCOMP_BASE/openvpnmg.bash" <<'EOF'
_openvpnmg_complete() {
    COMPREPLY=($(compgen -W "--add --remove --switch --list --terminate --status --help" -- "${COMP_WORDS[1]}"))
}
complete -F _openvpnmg_complete openvpnmg
EOF
        if [[ -f ~/.bashrc ]] && ! grep -q "source $AUTOCOMP_BASE/openvpnmg.bash" ~/.bashrc; then
            echo "source $AUTOCOMP_BASE/openvpnmg.bash" >> ~/.bashrc
        fi
        echo "✅ Bash completion added."
    fi

    # --- Zsh ---
    if command -v zsh >/dev/null 2>&1; then
        cat >"$AUTOCOMP_BASE/_openvpnmg" <<'EOF'
#compdef openvpnmg
_arguments '--add[Add a VPN file]' '--remove[Remove a VPN alias]' '--switch[Switch VPN]' '--terminate[Terminate all VPNs]' '--list[List aliases]' '--status[Show status]' '--help[Show help]'
EOF
        mkdir -p ~/.zsh/completions
        cp "$AUTOCOMP_BASE/_openvpnmg" ~/.zsh/completions/
        if ! grep -q "fpath+=(~/.zsh/completions)" ~/.zshrc 2>/dev/null; then
            echo "fpath+=(~/.zsh/completions)" >> ~/.zshrc
        fi
        if ! grep -q "compinit" ~/.zshrc 2>/dev/null; then
            echo "autoload -Uz compinit && compinit" >> ~/.zshrc
        fi
        echo "✅ Zsh completion added."
    fi

    # --- Fish ---
    if command -v fish >/dev/null 2>&1; then
        mkdir -p ~/.config/fish/completions
        cat >~/.config/fish/completions/openvpnmg.fish <<'EOF'
complete -c openvpnmg -f -a "--add --remove --switch --terminate --list --status --help"
EOF
        echo "✅ Fish completion added."
    fi

else
    echo "❎ Skipping autocompletion setup."
fi

# ──────────────────────────────────────────────
# 3. Finish
# ──────────────────────────────────────────────
echo "🎉 Installation complete!"
echo "👉 Try 'openvpnmg --help' to get started."
