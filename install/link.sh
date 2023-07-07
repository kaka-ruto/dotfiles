#!/usr/bin/env bash

DOTFILES=$HOME/Code/Vim/neodotfiles

# TODO: break down each of these blocks into their own files
#
# Set up oh-my-zsh before creating zshrc with the symlinks so it's not overwritten
echo -e "\\n\\nSetting up oh-my-zsh"
echo "=============================="
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing oh-my-zsh"
    curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
    
    echo "Renaming zshrc created by oh-my-zsh"
    mv "$HOME/.zshrc" "$HOME/.zshrc.from-oh-my-zsh"
else
    echo "oh-my-zsh already installed... skipping."
fi

echo -e "\\n\\nSetting up zsh-autosuggestions and zsh-syntax-highlighting"
echo "=============================="
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
else
    echo "zsh-autosuggestions already installed... skipping."
fi

if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
    echo "Installing zsh-syntax-highlighting"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
else
    echo "zsh-syntax-highlighting already installed... skipping."
fi

echo -e "\\nCreating symlinks"
echo "=============================="
linkables=$( find -H "$DOTFILES" -maxdepth 3 -name '*.symlink' )
for file in $linkables ; do
    target="$HOME/.$( basename "$file" '.symlink' )"
    if [ -e "$target" ]; then
        echo "~${target#$HOME} already exists... Skipping."
    else
        echo "Creating symlink for $file"
        ln -s "$file" "$target"
    fi
done

echo -e "\\n\\nCreating the ~/.config dir if it doesn't exist"
echo "=============================="
if [ ! -d "$HOME/.config" ]; then
    echo "Creating ~/.config"
    mkdir -p "$HOME/.config"
fi

config_files=$( find "$DOTFILES/config" -d 1 2>/dev/null )
for config in $config_files; do
    target="$HOME/.config/$( basename "$config" )"
    if [ -e "$target" ]; then
        echo "~${target#$HOME} already exists... Skipping."
    else
        echo "Creating symlink for $config"
        ln -s "$config" "$target"
    fi
done

echo -e "\\n\\nCloning Neovim with Astronvim"
echo "=============================="

if [ ! -d "$HOME/.config/nvim" ]; then
    echo "Cloning astronvim into ~/.config/nvim"
    git clone https://github.com/AstroNvim/AstroNvim ~/.config/nvim
else
    echo "Astronvim already cloned... Skipping."
fi

echo -e "\\n\\nCloning my personal astronvim configuration"
echo "=============================="

if [ ! -d "$HOME/.config/nvim/lua/user" ]; then
    echo "Cloning astronvim config into ~/.config/nvim/lua/user"
    git clone https://github.com/kaka-ruto/astronvim.git ~/.config/nvim/lua/user
else
    echo "Astronvim config already cloned... Skipping."
fi


echo -e "\\n\\nInstalling tmux plugin manager"
echo "=============================="

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "Cloning tpm into ~/.tmux/plugins/tpm"
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
    echo "Tpm already cloned... Skipping."
fi

echo -e "\\n\\nInstalling ASDF"
echo "=============================="

if [ ! -d "$HOME/.asdf" ]; then
    echo "Cloning asdf into ~/.asdf"
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.12.0
else
    echo "asdf already cloned... Skipping."
fi
