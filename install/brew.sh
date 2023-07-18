#!/usr/bin/env bash

if test ! "$( command -v brew )"; then
    echo "Installing homebrew"
    ruby -e "$( curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install )"
fi

echo -e "\\n\\nInstalling homebrew packages..."
echo "=============================="

formulas=(
    bat
    ccat
    diff-so-fancy
    dnsmasq
    fzf
    fd
    git
    grep
    highlight
    hub
    markdown
    mas
    reattach-to-user-namespace
    the_silver_searcher
    shellcheck
    tmux
    tmuxinator
    trash
    tree
    wget
    z
    zsh
    ripgrep
    git-standup
    entr
    universal-ctags
    gpg
    gawk
    redis
    "jesseduffield/lazygit/lazygit"
)

for formula in "${formulas[@]}"; do
    formula_name=$( echo "$formula" | awk '{print $1}' )
    if brew list "$formula_name" > /dev/null 2>&1; then
        echo "$formula_name already installed... skipping."
    else
        brew install "$formula"
        # arch_name="$(uname -m)"
 
        # if [ "${arch_name}" = "x86_64" ]; then
        #     if [ "$(sysctl -in sysctl.proc_translated)" = "1" ]; then
        #         echo "Running on Rosetta 2"
        #         arch -x86_64 brew install "$formula"
        #     else
        #         echo "Running on native Intel"
        #         brew install "$formula"
        #     fi 
        # elif [ "${arch_name}" = "arm64" ]; then
        #     echo "Running on ARM"
        #     arch -arm64 brew install "$formula"
        # else
        #     echo "Unknown architecture: ${arch_name}"
        # fi
    fi
done

# After the install, setup fzf
echo -e "\\n\\nRunning fzf install script..."
echo "=============================="
/usr/local/opt/fzf/install --all --no-bash --no-fish

# after the install, install neovim python libraries
# echo -e "\\n\\nRunning Neovim Python install"
# echo "=============================="
# pip3 install pynvim

# Change the default shell to zsh
zsh_path="$( command -v zsh )"
if ! grep "$zsh_path" /etc/shells; then
    echo "adding $zsh_path to /etc/shells"
    echo "$zsh_path" | sudo tee -a /etc/shells
fi

if [[ "$SHELL" != "$zsh_path" ]]; then
    chsh -s "$zsh_path"
    echo "default shell changed to $zsh_path"

    # Source zshrc
    echo "source $DOTFILES/zsh/zshenv.symlink" >> ~/.zshrc
    echo "source $DOTFILES/zsh/zshrc.symlink" >> ~/.zshrc
fi
