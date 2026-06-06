#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

step() { echo ""; echo ">>> $*"; }
ok()   { echo "    OK: $*"; }
warn() { echo "    WARN: $*"; }

echo "========================================"
echo "  Mac Studio Dev Environment Setup"
echo "========================================"

# ── 1. Homebrew ───────────────────────────────────────────────────────────────
step "Checking Homebrew ..."
if command -v brew &>/dev/null; then
    ok "Homebrew is installed ($(brew --version | head -1))"
else
    warn "Homebrew not found."
    echo ""
    echo "    Install it with:"
    echo '      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    echo "    Then re-run this script."
    exit 1
fi

# ── 2. Git ────────────────────────────────────────────────────────────────────
step "Checking git ..."
if command -v git &>/dev/null; then
    ok "git is installed ($(git --version))"
else
    warn "git not found — install Xcode Command Line Tools: xcode-select --install"
    exit 1
fi

# ── 3. mkcert ─────────────────────────────────────────────────────────────────
step "Checking mkcert ..."
if command -v mkcert &>/dev/null; then
    ok "mkcert is installed"
else
    warn "mkcert not found — installing via Homebrew ..."
    brew install mkcert
    ok "mkcert installed"
fi

# ── 4. Anthropic Claude VS Code extension ────────────────────────────────────
step "Checking for Anthropic Claude VS Code extension ..."
if command -v code &>/dev/null && code --list-extensions 2>/dev/null | grep -qi "anthropic"; then
    ok "Claude extension detected in VS Code"
else
    warn "Could not detect the Anthropic Claude extension automatically."
    echo "    Install it manually in VS Code:"
    echo "      1. Open VS Code → Extensions (Cmd+Shift+X)"
    echo "      2. Search for 'Claude' by Anthropic"
    echo "      3. Click Install"
fi

# ── 5. Install scripts ────────────────────────────────────────────────────────
step "Installing custom scripts to /usr/local/bin ..."
"${SCRIPT_DIR}/aaCopyScripts"

# ── 6. Install MOTD ───────────────────────────────────────────────────────────
step "Installing MOTD to /etc/motd ..."
"${SCRIPT_DIR}/aaCopyMotd"

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo "========================================"
echo "  Setup complete!"
echo "========================================"
echo ""
echo "Next manual steps:"
echo ""
echo "  1. Clone MitchellNET service repos into ~/Documents/visualStudioCode/"
echo "       e.g. git clone https://github.com/theAgingApprentice/<repo>.git"
echo ""
echo "  2. Add the MitchellNET host alias to /etc/hosts:"
echo "       sudo sh -c 'echo \"192.168.2.10 mitchellnet.local\" >> /etc/hosts'"
echo ""
echo "  3. Run mkcert to install the local CA and generate certs:"
echo "       mkcert -install"
echo "       mkcert mitchellnet.local '*.mitchellnet.local' localhost"
echo ""
