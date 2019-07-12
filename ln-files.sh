#! /usr/bin/env sh

set -e

DOTFILES_HOME="${DOTFILES_HOME:-"$HOME/dotfiles"}"

linkit() {
  if [ -e "$2" ] || [ -h "$2" ]; then
    echo "File $2 already exists, override it? (y/N) "
    read confirmed
    case "$confirmed" in
      [yY]|[yY][eE][sS])
          mv "$2" "$2.old"
          ;;
      *)
        echo "Skipping file $2"
        return 0
	;;
    esac
  fi

  echo "Creating file $2..."
  ln -s "$1" "$2"
}

# Functions
mkdir -p "$HOME/functions"

# Basic
linkit "$DOTFILES_HOME/.zshrc" "$HOME/.zshrc"

# Zsh themes and plugins
linkit "$DOTFILES_HOME/third-party/oh-my-zsh" "$HOME/.oh-my-zsh"
linkit "$DOTFILES_HOME/third-party/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" "$HOME/highlighting.zsh"
linkit "$DOTFILES_HOME/third-party/zsh-autosuggestions/zsh-autosuggestions.zsh" "$HOME/autosuggestion.zsh"

# Pure theme
linkit "$DOTFILES_HOME/third-party/pure/async.zsh" "$HOME/functions/async"
linkit "$DOTFILES_HOME/third-party/pure/pure.zsh" "$HOME/functions/prompt_pure_setup"

# Tmux
linkit "$DOTFILES_HOME/third-party/tmux-theme/.tmux.conf" "$HOME/.tmux.conf"
linkit "$DOTFILES_HOME/.tmux.conf.local" "$HOME/.tmux.conf.local"

# VIM
linkit "$DOTFILES_HOME/.vimrc" "$HOME/.vimrc"
linkit "$DOTFILES_HOME/.vimrc" "$HOME/.config/nvim/init.vim"
mkdir -p "$HOME/.config/nvim/site/autoload"
linkit "$DOTFILES_HOME/.vimrc" "$HOME/.config/nvim/site/autoload/plug.vim"

