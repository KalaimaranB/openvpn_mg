# VPN-Switch Installer 🛠️

This script installs the **VPN-Switch** tool and optionally enables shell autocompletion for supported shells (bash, zsh, fish).

---

## 🧩 Installation

Run this in your terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/KalaimaranB/openvpn_mg/main/install-vpnswitch.sh | bash
```

---

## ⚙️ What It Does

1. Installs the `vpn-switch` executable to `/usr/local/bin/`.
2. Removes any outdated autocompletion snippets from `.bashrc`, `.zshrc`, etc.
3. Optionally sets up new autocompletion for your detected shell.

---

## 🖥️ Supported Shells

- **bash**
- **zsh**
- **fish**

---

## 🚀 Manual Setup

If you prefer to manually add autocompletion:

### Bash

Add this to your `~/.bashrc`:
```bash
eval "$(vpn-switch --completion-script-bash)"
```

### Zsh

Add this to your `~/.zshrc`:
```bash
eval "$(vpn-switch --completion-script-zsh)"
```

### Fish

Add this to your `~/.config/fish/completions/vpn-switch.fish`:
```bash
vpn-switch --completion-script-fish > ~/.config/fish/completions/vpn-switch.fish
```

---

## 🔧 Uninstallation

To remove `vpn-switch` and its completions:
```bash
sudo rm -f /usr/local/bin/vpn-switch
sed -i '/vpn-switch --completion/d' ~/.bashrc ~/.zshrc 2>/dev/null
rm -f ~/.config/fish/completions/vpn-switch.fish 2>/dev/null
```

---

## 📄 License

MIT License © 2025 Kalaimaran
