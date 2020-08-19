#! zsh

set -eu

export DOTFILES_HOME="${DOTFILES_HOME:-"$HOME/dotfiles"}"

if type git &> /dev/null; then
	(
		cd "$DOTFILES_HOME"
		git config user.email augusto.borgesm@gmail.com
		git config user.name "Augusto Moura"
	)
fi

yes n | "$DOTFILES_HOME/ln-files.sh"

yes y | "$DOTFILES_HOME/third-party/fzf/install"
