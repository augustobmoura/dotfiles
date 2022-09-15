# Path to your oh-my-zsh installation.
export DOTFILES_HOME="${DOTFILES_HOME:-$HOME/dotfiles}"

export fpath=("$HOME/.zsh/functions" "$DOTFILES_HOME/zsh/functions" $fpath)

export ZSH="$DOTFILES_HOME/zsh/plugins/oh-my-zsh"

if ! type is_executable &> /dev/null; then
	function is_executable() type "$@" &> /dev/null
fi

function isjetbrains() [[ "${TERMINAL_EMULATOR:l}" = *jetbrains* ]]
function isvscode() [[ "${TERM_PROGRAM:l}" = *vscode* ]]
function isvim() [[ "$VIM" ]]

LOCAL_PATH=("$HOME/"{bin,.local/bin} "$DOTFILES_HOME/bin")
export LOCAL_PATH

# Keeps PATH deduped
typeset -U LOCAL_PATH PATH path

# Add this directories now, because we gonna need them for other scripts
# We fix the priority again at the end in the case that some script gets
# prioritized over the local ones
path=(
	"${LOCAL_PATH[@]}"
	"$HOME/.cargo/bin"
	"${path[@]}"
)

source "$DOTFILES_HOME/sh/profile"

# ---
# Oh my zsh
# ---

# Config
if [ -n "$NO_TMUX" ];  then
	ZSH_TMUX_AUTOSTART=false
fi

export ZSH_TMUX_AUTOSTART=${ZSH_TMUX_AUTOSTART:-true}
export ZSH_TMUX_AUTOSTART_ONCE=true
export ZSH_TMUX_AUTOCONNECT=false

# I can update omz manually instead of being prompted
export DISABLE_AUTO_UPDATE=true

# Tmux is usually buggy on embedded terminals, also is kinda unecessary in this context
if isjetbrains || isvscode || isvim; then
	export ZSH_TMUX_AUTOSTART=false
fi

# Should load before omz for custom directoty configuration
if is_executable direnv; then
	eval "$(direnv hook zsh)"
fi

# Should be provided by either Pure or Starship
ZSH_THEME= # OMZ theme

plugins=(
	git
	node
	yarn
	npm
	tmux
	gradle
	mvn
	asdf
	ripgrep
	rust
	colored-man-pages
	docker
	fancy-ctrl-z
	httpie
	sdk
	emoji
	kubectl
	bgnotify
	ant
	adb
	poetry
	extract
	gh
	#minikube # Giving some weird prints in random commands, disabled for now
)

# Run OMZ
source "$ZSH/oh-my-zsh.sh"

# ---
# Customizations
# ---

# Personal preference
disable r

# Better globbing
setopt extendedglob glob_dots

source "$DOTFILES_HOME/sh/variables"
source "$DOTFILES_HOME/sh/aliases"

# Configure fzf, if it exists
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Generate Base16 color schemes
export BASE16_SHELL="$DOTFILES_HOME/sh/base16-shell/"
[ -n "$PS1" ] && \
	[ -s "$BASE16_SHELL/profile_helper.sh" ] && 
		eval "$("$BASE16_SHELL/profile_helper.sh")"

# Applies theme
is_executable base16_seti && base16_seti

# Enable autosuggestions if exists
if [ -e "$DOTFILES_HOME/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
	source "$DOTFILES_HOME/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# This speeds up pasting w/ autosuggest
# https://github.com/zsh-users/zsh-autosuggestions/issues/238
function fix_paste {
	function pasteinit {
		OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
		zle -N self-insert url-quote-magic
	}

	function  pastefinish {
		zle -N self-insert $OLD_SELF_INSERT
	}
	zstyle :bracketed-paste-magic paste-init pasteinit
	zstyle :bracketed-paste-magic paste-finish pastefinish
}
fix_paste

# Applies sdkman if configured, I mostly use asdf now, but whatever
SDKMAN_DIR="$HOME/.sdkman"
if [ -d "$SDKMAN_DIR" ]; then
	[ -r "$SDKMAN_DIR/bin/sdkman-init.sh" ] && SDKMAN_DIR="$SDKMAN_DIR" source "$SDKMAN_DIR/bin/sdkman-init.sh"
	export SDKMAN_DIR
fi

# Applies n if configured, I mostly use asdf now, but whatever
N_PREFIX="${N_PREFIX:-$HOME/n}"
if [ -d "$N_PREFIX" ]; then
	path+=("$N_PREFIX/bin")
	export N_PREFIX
fi

if [ -d "$HOME/.poetry/bin" ]; then
	path+=("$HOME/.poetry/bin")
fi

if [ -f "$ASDF_DIR/plugins/java/set-java-home.zsh" ]; then
	. "$ASDF_DIR/plugins/java/set-java-home.zsh"
fi

# Machine local configuration
: "${LOCAL_RC_FILE:=$HOME/.local.zsh}" 
if [ -r "$LOCAL_RC_FILE" ]; then
	source "$LOCAL_RC_FILE"
fi

# Bind alt-j & alt-k to Down & Up for historic in the home row
bindkey -s '^[j' '^[OB'
bindkey -s '^[k' '^[OA'

if ! [ $ZSH_THEME ]; then
	# Choose theme, prefer starship and then Pure
	if is_executable starship; then
		# Activates starship
		eval "$(starship init zsh)"
	else
		# Activates Pure them
		autoload -U promptinit; promptinit
		prompt pure
	fi
fi

# Better expansion on ^X*
# Adapted from the globalias plugin
function globalias {
	zle _expand_alias
	zle expand-word
	zle self-insert

	# Needed to not add * at the end
	zle backward-delete-char
}
zle -N globalias
bindkey '^X*' globalias

if [ -e "$DOTFILES_HOME/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
	source "$DOTFILES_HOME/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# Always gives priority for local binaries
path=(
	"${LOCAL_PATH[@]}"
	"${path[@]}"
)

export PATH="$HOME/.poetry/bin:$PATH"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/amoura/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    # if [ -f "/home/amoura/anaconda3/etc/profile.d/conda.sh" ]; then
    #     . "/home/amoura/anaconda3/etc/profile.d/conda.sh"
    # else
    #     export PATH="/home/amoura/anaconda3/bin:$PATH"
    # fi
fi
unset __conda_setup
# <<< conda initialize <<<

