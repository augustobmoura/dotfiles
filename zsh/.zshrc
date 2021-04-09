# Uncoment to skip config (test in )
if [ -n "$AGT_SKIP_CONFIG" ]; then
	return 0
fi

# Path to your oh-my-zsh installation.
export DOTFILES_HOME="${DOTFILES_HOME:-$HOME/dotfiles}"

export fpath=("$HOME/.zsh/functions" "$DOTFILES_HOME/zsh/functions" $fpath)

export ZSH="$DOTFILES_HOME/zsh/plugins/oh-my-zsh"

function isjetbrains() {
	[[ $TERMINAL_EMULATOR =~ 'JetBrains-JediTerm' ]] || return
}

function cmd_exists() {
	type "$@" &> /dev/null
	return
}

function isvscode() {
	# Needs to configure VSCode to pass this env var
	[[ $TERMINAL_EMULATOR =~ 'VSCode' ]] || return
}

path=(
	"$HOME/.local/bin"
	"$DOTFILES_HOME/bin"
	$path
	"$HOME/.cargo/bin"
)

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
if isjetbrains || isvscode; then
	export ZSH_TMUX_AUTOSTART=false
fi

# Should load before omz for custom directoty configuration
if cmd_exists direnv; then
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
	asdf
	ripgrep
	cargo
	colored-man-pages
	docker
	fancy-ctrl-z
	httpie
	sdk
	emoji
	kubectl
	bgnotify
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
cmd_exists base16_seti && base16_seti

# Enable autosuggestions if exists
if [ -e "$DOTFILES_HOME/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
	source "$DOTFILES_HOME/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# This speeds up pasting w/ autosuggest
# https://github.com/zsh-users/zsh-autosuggestions/issues/238
function pasteinit() {
	OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
	zle -N self-insert url-quote-magic
}

function  pastefinish() {
	zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

# Applies sdkman if configured, I mostly use asdf by now, but whatever
export SDKMAN_DIR="$HOME/.sdkman"
[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Applies n if configured, I mostly use asdf by now, but whatever
if cmd_exists n; then
	export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"
fi

if [ -f "$ASDF_DIR/plugins/java/set-java-home.zsh" ]; then
	. "$ASDF_DIR/plugins/java/set-java-home.zsh"
fi

# Machine local configuration
if [ -e "$HOME/.local.zsh" ]; then
	source "$HOME/.local.zsh"
fi

# Bind alt-j & alt-k to Down & Up for historic in the home row
bindkey -s '^[j' '^[OB'
bindkey -s '^[k' '^[OA'

if [[ $ZSH_THEME = '' ]]; then
	# Choose theme, prefer starship and then Pure
	if cmd_exists starship; then
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
globalias() {
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

