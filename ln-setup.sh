#! /usr/bin/env sh

DOTFILES_HOME="${DOTFILES_HOME:-"$HOME/dotfiles"}"

linkit() {
  (2>&1 ln -s "$@") > /dev/null || true
}

# Basic
linkit "$DOTFILES_HOME/.zshrc" "$HOME/.zshrc"

# Zsh themes and plugins
linkit "$DOTFILES_HOME/oh-my-zsh" "$HOME/.oh-my-zsh"
linkit "$DOTFILES_HOME/functions" "$HOME/functions"
linkit "$DOTFILES_HOME/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" "$HOME/highlighting.zsh"
linkit "$DOTFILES_HOME/zsh-autosuggestions/zsh-autosuggestions.zsh" "$HOME/autosuggestion.zsh"

# Tmux
linkit "$DOTFILES_HOME/tmux-theme/.tmux.conf" "$HOME/.tmux.conf"
linkit "$DOTFILES_HOME/.tmux.conf.local" "$HOME/.tmux.conf"

linkit "$DOTFILES_HOME/.vimrc" "$HOME/.vimrc"
linkit "$DOTFILES_HOME/.vimrc" "$HOME/.config/nvim/init.vim"

