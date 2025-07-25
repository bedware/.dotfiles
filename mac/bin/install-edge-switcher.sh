#!/bin/zsh

# Installation script for Edge Workspace Switcher

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SWITCHER_SCRIPT="$SCRIPT_DIR/switch-edge-workspace.sh"
WORKSPACE_SCRIPT="$SCRIPT_DIR/get-edge-workspaces.sh"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}Installing Edge Workspace Switcher for macOS...${NC}"
echo

# Check if scripts exist
if [[ ! -f "$SWITCHER_SCRIPT" ]]; then
    echo -e "${YELLOW}Error: switch-edge-workspace.sh not found${NC}"
    exit 1
fi

if [[ ! -f "$WORKSPACE_SCRIPT" ]]; then
    echo -e "${YELLOW}Error: get-edge-workspaces.sh not found${NC}"
    exit 1
fi

# Make scripts executable
chmod +x "$SWITCHER_SCRIPT"
chmod +x "$WORKSPACE_SCRIPT"

echo -e "${GREEN}✅ Scripts made executable${NC}"

# Create symlinks in a common bin directory if it exists
if [[ -d "$HOME/.local/bin" ]]; then
    ln -sf "$SWITCHER_SCRIPT" "$HOME/.local/bin/edge-workspace"
    ln -sf "$WORKSPACE_SCRIPT" "$HOME/.local/bin/edge-workspaces"
    echo -e "${GREEN}✅ Symlinks created in ~/.local/bin${NC}"
    echo "  edge-workspace    -> Main switcher"
    echo "  edge-workspaces   -> Workspace reader"
elif [[ -d "/usr/local/bin" ]] && [[ -w "/usr/local/bin" ]]; then
    ln -sf "$SWITCHER_SCRIPT" "/usr/local/bin/edge-workspace"
    ln -sf "$WORKSPACE_SCRIPT" "/usr/local/bin/edge-workspaces"
    echo -e "${GREEN}✅ Symlinks created in /usr/local/bin${NC}"
    echo "  edge-workspace    -> Main switcher"
    echo "  edge-workspaces   -> Workspace reader"
fi

# Suggest aliases for shell configuration
echo
echo -e "${BLUE}Suggested aliases for your shell configuration:${NC}"
echo
echo "# Add these to your ~/.zshrc or ~/.bashrc:"
echo "alias esw='$SWITCHER_SCRIPT'"
echo "alias edge-switch='$SWITCHER_SCRIPT'"
echo "alias edge-list='$SWITCHER_SCRIPT list'"
echo

# Check dependencies
echo -e "${BLUE}Checking dependencies...${NC}"
missing_deps=()

if ! command -v jq &> /dev/null; then
    missing_deps+=("jq")
fi

if ! command -v fzf &> /dev/null; then
    missing_deps+=("fzf")
fi

if (( ${#missing_deps[@]} > 0 )); then
    echo -e "${YELLOW}Missing dependencies: ${missing_deps[*]}${NC}"
    echo "Install them with:"
    for dep in "${missing_deps[@]}"; do
        echo "  brew install $dep"
    done
else
    echo -e "${GREEN}✅ All dependencies installed${NC}"
fi

echo
echo -e "${GREEN}🎉 Installation complete!${NC}"
echo
echo "Usage examples:"
echo "  $SWITCHER_SCRIPT              # Auto-detect profile and switch"
echo "  $SWITCHER_SCRIPT list         # List available workspaces"
echo "  $SWITCHER_SCRIPT default      # Force default profile"
echo "  $SWITCHER_SCRIPT help         # Show help"
echo
echo "If you created symlinks, you can also use:"
echo "  edge-workspace                # Main switcher"
echo "  edge-workspaces list          # List workspaces"
