#!/bin/bash

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Install Homebrew if it is not already installed
if ! command_exists brew; then
  echo "Homebrew not found. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew is already installed."
fi

# Update Homebrew
echo "Updating Homebrew..."
brew update

# Define the list of packages and casks to install
PACKAGES=(
  git
  node
  python
  htop
  tmux
  neovim
  stow
  fzf
  ripgrep
  bat
)

CASKS=()

# Install packages
echo "Installing packages..."
for PACKAGE in "${PACKAGES[@]}"; do
  if brew list -1 | grep -q "^${PACKAGE}\$"; then
    echo "$PACKAGE is already installed."
  else
    brew install "$PACKAGE"
  fi
done

# Install casks
echo "Installing casks..."
for CASK in "${CASKS[@]}"; do
  if brew list --cask -1 | grep -q "^${CASK}\$"; then
    echo "$CASK is already installed."
  else
    brew install --cask "$CASK"
  fi
done

#Stow dotfiles
echo "Stow dotfiles..."
stow git
stow nvim
stow tmux
stow zsh

echo "Installation complete!"
