#! /usr/bin/env sh

set -eu

# Choose a name not existent to rename the file, echoing it at the end
mv_to_non_existent() (
	file_name="$1"
	i=''

	# A file that always exist, will always fail the while the first time
	# Just to not repeat the logic of building the file name
	new_file_name="."

	while [ -e "$new_file_name" ]; do
		i=$(($i + 1))
		new_file_name="$file_name.old$i"
	done

	mv "$file_name" "$new_file_name"
	echo "$new_file_name"
)

# Soft links with confirmation of overriding
# You can pipe `yes` to override all
linkit() (
	original_file="$1"
	new_file="$2"

	if [ -e "$new_file" ] || [ -h "$new_file" ]; then
		printf "File $new_file already exists, override it? (y/N): "
		read confirmed

		case "$confirmed" in
			[yY]|[yY][eE][sS]|[sS])
				moved_file_name="$(mv_to_non_existent "$new_file")"
				echo "File $new_file moved to $moved_file_name"
				;;
			*)
				echo "Skipping file $new_file"
				return 0
				;;
		esac
	fi

	echo "Creating file $new_file..."
	ln -s "$original_file" "$new_file"
)

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
linkit "$DOTFILES_HOME/third-party/oh-my-tmux/.tmux.conf" "$HOME/.tmux.conf"
linkit "$DOTFILES_HOME/.tmux.conf.local" "$HOME/.tmux.conf.local"

# VIM
linkit "$DOTFILES_HOME/.vimrc" "$HOME/.vimrc"
linkit "$DOTFILES_HOME/.vimrc" "$HOME/.config/nvim/init.vim"
mkdir -p "$HOME/.local/share/nvim/site/autoload"
linkit "$DOTFILES_HOME/plug.vim" "$HOME/.local/share/nvim/site/autoload/plug.vim"
mkdir -p "$HOME/.vim/autoload"
linkit "$DOTFILES_HOME/plug.vim" "$HOME/.vim/autoload/plug.vim"

# asdf
linkit "$DOTFILES_HOME/third-party/asdf" "$HOME/.asdf"

# i3
mkdir -p "$HOME/.i3"
linkit "$DOTFILES_HOME/i3config" "$HOME/.i3/config"
