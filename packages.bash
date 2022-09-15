must_have=(
	zsh
	tmux
	nvim
	fd
	rg
	bat
	git
	http
	jq
	curl
)

optional=(
	alacritty
	i3
	i3status-rs
	docker
	starship
)

check_missing() {
	for cmd; do
		if ! command -v "$cmd" &> /dev/null; then
			printf "%s\n" "$cmd"
		fi
	done
}

missing_must_have=($(check_missing "${must_have[@]}"))
missing_optional=($(check_missing "${optional[@]}"))

if (( "${#missing_must_have}" )); then
	print "The following MUST HAVE commands are missing:\n  "
	printf "%s " "${missing_must_have[@]}"
	printf "\n\n"
fi

if (( "${#missing_optional}" )); then
	print "The following optional commands are missing:\n  "
	printf "%s " "${missing_optional[@]}"
	printf "\n"
fi
