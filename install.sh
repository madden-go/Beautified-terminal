#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[*]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[+]${NC} $1"
}

print_error() {
    echo -e "${RED}[!]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[⚠]${NC} $1"
}

detect_os() {
    case "$(uname -s)" in
        Darwin*)
            OS="macos"
            ;;
        Linux*)
            OS="linux"
            ;;
        MINGW*|MSYS*|CYGWIN*)
            OS="windows"
            ;;
        *)
            print_error "Unsupported OS: $(uname -s)"
            exit 1
            ;;
    esac
    print_status "Detected OS: $OS"
}

select_terminal() {
    echo
    echo "┌─────────────────────────────────────┐"
    echo "│      Terminal Setup Script          │"
    echo "└─────────────────────────────────────┘"
    echo
    echo "Please select your preferred terminal:"
    echo
    echo "1) Alacritty - GPU-accelerated terminal emulator"
    echo "2) Ghostty - Fast, feature-rich terminal emulator"
    echo
    read -p "Enter your choice (1 or 2): " choice

    case $choice in
        1)
            TERMINAL="alacritty"
            CONFIG_DIR="$HOME/.config/alacritty"
            CONFIG_FILE="alacritty.toml"
            print_success "Selected: Alacritty"
            ;;
        2)
            TERMINAL="ghostty"
            CONFIG_DIR="$HOME/.config/ghostty"
            CONFIG_FILE="config"
            print_success "Selected: Ghostty"
            ;;
        *)
            print_error "Invalid choice. Please run the script again."
            exit 1
            ;;
    esac
}

install_dependencies() {
    print_status "Installing required dependencies..."

    case $OS in
        macos)
            if ! command -v brew &> /dev/null; then
                print_status "Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
            
            if ! command -v zsh &> /dev/null; then
                brew install zsh
            fi
            
            if ! command -v git &> /dev/null; then
                brew install git
            fi
            ;;
        linux)
        
            if command -v apt-get &> /dev/null; then
                sudo apt-get update
                sudo apt-get install -y zsh git curl wget
            elif command -v yum &> /dev/null; then
                sudo yum install -y zsh git curl wget
            elif command -v dnf &> /dev/null; then
                sudo dnf install -y zsh git curl wget
            elif command -v pacman &> /dev/null; then
                sudo pacman -S --noconfirm zsh git curl wget
            else
                print_error "Could not find package manager. Please install zsh, git, curl, and wget manually."
                exit 1
            fi
            ;;
        windows)
            print_warning "Windows detected. Please ensure Git Bash or WSL is installed."
            if ! command -v git &> /dev/null; then
                print_error "Git for Windows is required. Please install from https://git-scm.com/download/win"
                exit 1
            fi
            ;;
    esac
}

# Install terminal
install_terminal() {
    print_status "Installing $TERMINAL..."

    case $OS in
        macos)
            if [ "$TERMINAL" = "alacritty" ]; then
                brew install --cask alacritty
            else
                # Ghostty on macOS
                brew install --cask ghostty
            fi
            ;;
        linux)
            if [ "$TERMINAL" = "alacritty" ]; then
                # Install Alacritty on Linux
                if command -v apt-get &> /dev/null; then
                    sudo apt-get install -y alacritty
                elif command -v dnf &> /dev/null; then
                    sudo dnf install -y alacritty
                elif command -v pacman &> /dev/null; then
                    sudo pacman -S --noconfirm alacritty
                else
                    print_warning "Please install Alacritty manually from https://github.com/alacritty/alacritty"
                fi
            else
                # Ghostty on Linux - build from source
                print_warning "Ghostty requires building from source on Linux."
                print_status "Installing build dependencies..."
                
                if command -v apt-get &> /dev/null; then
                    sudo apt-get install -y libgtk-3-dev libxcb-render0-dev libxcb-shape0-dev libxcb-xfixes0-dev libxkbcommon-dev libssl-dev
                fi
                
                git clone https://github.com/ghostty-org/ghostty
                cd ghostty
                zig build -Doptimize=ReleaseFast
                sudo zig build install
                cd ..
                rm -rf ghostty
            fi
            ;;
        windows)
            if [ "$TERMINAL" = "alacritty" ]; then
                print_warning "Please download Alacritty from https://github.com/alacritty/alacritty/releases"
            else
                print_warning "Ghostty on Windows: Please use WSL2 or check documentation"
            fi
            ;;
    esac
}

install_rust_and_starship() {
    if ! command -v rustc &> /dev/null; then
        print_status "Installing Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
    else
        print_success "Rust is already installed"
    fi
    
    if ! command -v starship &> /dev/null; then
        print_status "Installing Starship..."
        curl -sS https://starship.rs/install.sh | sh -s -- -y
    else
        print_success "Starship is already installed"
    fi
}

install_oh_my_zsh() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        print_status "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        print_success "Oh My Zsh is already installed"
    fi
}

install_zinit() {
    if [ ! -d "$HOME/.zinit" ]; then
        print_status "Installing Zinit..."
        bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
    else
        print_success "Zinit is already installed"
    fi
}


install_zsh_plugins() {
    print_status "Installing zsh-syntax-highlighting..."
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    fi
    
    print_status "Installing zsh-autosuggestions..."
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    fi
}

setup_config_files() {
    print_status "Creating config directory: $CONFIG_DIR"
    mkdir -p "$CONFIG_DIR"
    

    if [ -f "./$CONFIG_FILE" ]; then
        cp "./$CONFIG_FILE" "$CONFIG_DIR/"
        print_success "Copied $CONFIG_FILE to $CONFIG_DIR/"
    else
        print_error "./$CONFIG_FILE not found. Please ensure it exists in the current directory."
        exit 1
    fi
    

    if [ -f "./starship.toml" ]; then
        cp "./starship.toml" "$HOME/.config/"
        print_success "Copied starship.toml to ~/.config/"
    else
        print_error "./starship.toml not found. Please ensure it exists in the current directory."
        exit 1
    fi
    

    if [ -f "./.zshrc" ]; then
        cp "./.zshrc" "$HOME/"
        print_success "Copied .zshrc to $HOME/"
    else
        print_error "./.zshrc not found. Please ensure it exists in the current directory."
        exit 1
    fi
}


main() {
    print_status "Starting terminal setup script..."
    
    detect_os
    select_terminal
    install_dependencies
    install_terminal
    install_rust_and_starship
    install_oh_my_zsh
    install_zinit
    install_zsh_plugins
    setup_config_files
    
    print_success "Installation completed successfully!"
    echo
    print_warning "Please restart your terminal or run 'source ~/.zshrc' to apply changes."
    echo
    print_status "You may need to:"
    echo "  1. Set $TERMINAL as your default terminal"
    echo "  2. Log out and back in for all changes to take effect"
}


main
