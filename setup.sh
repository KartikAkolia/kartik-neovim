#!/bin/bash

RC='\e[0m'
RED='\e[31m'
YELLOW='\e[33m'
GREEN='\e[32m'
BLUE='\e[34m'

# KANVIM - Kartik's Neovim Setup Script
echo -e "${BLUE}╔══════════════════════════════════════╗${RC}"
echo -e "${BLUE}║            KANVIM SETUP              ║${RC}"
echo -e "${BLUE}║        Kartik's Neovim Config        ║${RC}"
echo -e "${BLUE}╚══════════════════════════════════════╝${RC}"

# Configuration paths
NVIM_CONFIG_DIR="$HOME/.config/nvim"
GITHUB_DIR="$HOME/kartik-neovim"
BACKUP_DIR="$HOME/.config/nvim-backup-$(date +%Y%m%d_%H%M%S)"

# Check if we're in the right directory
if [[ ! -d "$(pwd)" ]]; then
    echo -e "${RED}Error: Script must be run from within the kartik-neovim directory${RC}"
    exit 1
fi

SCRIPT_DIR=$(pwd)

echo -e "${YELLOW}Setting up KANVIM configuration...${RC}"

# Backup existing neovim config if it exists
if [ -d "$NVIM_CONFIG_DIR" ] || [ -L "$NVIM_CONFIG_DIR" ]; then
    echo -e "${YELLOW}Backing up existing Neovim configuration to $BACKUP_DIR${RC}"
    mv "$NVIM_CONFIG_DIR" "$BACKUP_DIR"
fi

# Clean up old neovim data
echo -e "${YELLOW}Cleaning up old Neovim data...${RC}"
rm -rf ~/.local/share/nvim ~/.cache/nvim

# Create necessary directories
echo -e "${YELLOW}Creating necessary directories...${RC}"
mkdir -p "$HOME/.vim/undodir"
mkdir -p "$HOME/.scripts"
mkdir -p "$HOME/.config"

# Create symlink from config directory to github directory
echo -e "${YELLOW}Creating symlink: $NVIM_CONFIG_DIR -> $SCRIPT_DIR${RC}"
ln -sf "$SCRIPT_DIR" "$NVIM_CONFIG_DIR"

# Verify symlink was created correctly
if [ -L "$NVIM_CONFIG_DIR" ] && [ -d "$NVIM_CONFIG_DIR" ]; then
    echo -e "${GREEN}✓ Symlink created successfully${RC}"
    echo -e "${GREEN}  $NVIM_CONFIG_DIR -> $(readlink $NVIM_CONFIG_DIR)${RC}"
else
    echo -e "${RED}✗ Failed to create symlink${RC}"
    exit 1
fi

# Detect OS and install dependencies
echo -e "${YELLOW}Detecting operating system and installing dependencies...${RC}"

# Determine clipboard package based on session type
if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
    CLIPBOARD_PKG="wl-clipboard"
    echo -e "${BLUE}Detected Wayland session - using wl-clipboard${RC}"
else
    CLIPBOARD_PKG="xclip"
    echo -e "${BLUE}Detected X11 session - using xclip${RC}"
fi

if [ -f /etc/os-release ]; then
    . /etc/os-release
    
    case "${ID_LIKE:-$ID}" in
        arch|manjaro)
            echo -e "${BLUE}Detected Arch-based system${RC}"
            echo -e "${YELLOW}Installing dependencies with pacman...${RC}"
            
            # Core dependencies for KANVIM
            PACKAGES=(
                "ripgrep"           # Fast search tool
                "fd"                # Fast find alternative  
                "$CLIPBOARD_PKG"    # Clipboard integration
                "neovim"            # Neovim itself
                "python"            # Python runtime
                "python-pip"        # Python package manager
                "python-virtualenv" # Python virtual environments
                "nodejs"            # Node.js runtime
                "npm"               # Node package manager
                "go"                # Go runtime (for gopls)
                "rust"              # Rust runtime
                "ruby"              # Ruby runtime
                "rubygems"          # Ruby package manager
                "php"               # PHP runtime
                "composer"          # PHP package manager
                "jdk-openjdk"       # Java development kit
                "lua"               # Lua runtime
                "luarocks"          # Lua package manager
                "shellcheck"        # Shell script linter
                "git"               # Version control
                "curl"              # HTTP client
                "wget"              # File downloader
                "unzip"             # Archive extraction
                "gcc"               # C compiler (for some mason packages)
                "make"              # Build tool
            )
            
            # Install packages
            sudo pacman -S --needed --noconfirm "${PACKAGES[@]}"
            
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}✓ Dependencies installed successfully${RC}"
            else
                echo -e "${RED}✗ Some dependencies failed to install${RC}"
                echo -e "${YELLOW}You may need to install missing packages manually${RC}"
            fi
            ;;
            
        debian|ubuntu)
            echo -e "${BLUE}Detected Debian-based system${RC}"
            echo -e "${YELLOW}Installing dependencies with apt...${RC}"
            sudo apt update
            sudo apt install -y ripgrep fd-find $CLIPBOARD_PKG python3-venv luarocks golang-go nodejs npm ruby-full php composer default-jdk shellcheck git curl wget unzip build-essential
            ;;
            
        fedora)
            echo -e "${BLUE}Detected Fedora system${RC}"
            echo -e "${YELLOW}Installing dependencies with dnf...${RC}"
            sudo dnf install -y ripgrep fzf $CLIPBOARD_PKG neovim python3-virtualenv luarocks golang nodejs npm ruby php composer java-openjdk-devel ShellCheck git curl wget unzip gcc make
            ;;
            
        opensuse*)
            echo -e "${BLUE}Detected openSUSE system${RC}"
            echo -e "${YELLOW}Installing dependencies with zypper...${RC}"
            sudo zypper install -y ripgrep fzf $CLIPBOARD_PKG neovim python3-virtualenv luarocks go nodejs npm ruby php composer java-openjdk-devel ShellCheck git curl wget unzip gcc make
            ;;
            
        *)
            echo -e "${YELLOW}Unsupported OS: ${ID}${RC}"
            echo -e "${YELLOW}Please install the following packages manually:${RC}"
            echo "  - ripgrep, fd, $CLIPBOARD_PKG"
            echo "  - neovim, git, curl, wget, unzip"
            echo "  - python3, python3-pip, python3-venv"
            echo "  - nodejs, npm"
            echo "  - go, rust"
            echo "  - ruby, rubygems"
            echo "  - php, composer"
            echo "  - java (openjdk)"
            echo "  - lua, luarocks"
            echo "  - shellcheck"
            echo "  - gcc, make"
            ;;
    esac
else
    echo -e "${RED}Unable to determine OS. Please install required packages manually.${RC}"
    exit 1
fi

echo ""
echo -e "${GREEN}╔══════════════════════════════════════╗${RC}"
echo -e "${GREEN}║          SETUP COMPLETE!             ║${RC}"
echo -e "${GREEN}╚══════════════════════════════════════╝${RC}"
echo ""
echo -e "${BLUE}Next steps:${RC}"
echo -e "${YELLOW}1. Start Neovim: ${RC}nvim"
echo -e "${YELLOW}2. Let Lazy.nvim install plugins automatically${RC}"
echo -e "${YELLOW}3. Run ${RC}:Mason ${YELLOW}to install language servers${RC}"
echo -e "${YELLOW}4. Run ${RC}:checkhealth ${YELLOW}to verify everything is working${RC}"
echo ""
echo -e "${BLUE}Configuration location:${RC}"
echo -e "${GREEN}  Symlink: $NVIM_CONFIG_DIR${RC}"
echo -e "${GREEN}  Target:  $SCRIPT_DIR${RC}"
echo ""
if [ -d "$BACKUP_DIR" ]; then
    echo -e "${BLUE}Your previous config was backed up to:${RC}"
    echo -e "${YELLOW}  $BACKUP_DIR${RC}"
    echo ""
fi
echo -e "${BLUE}Happy coding with KANVIM! 🚀${RC}"
