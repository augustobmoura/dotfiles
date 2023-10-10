#! /usr/bin/env bash

set -euo pipefail

FORCE="${FORCE:-}"

source="$1"
target="$2"

existing=none

# Colors
colored() {
  local color="$1" text="$2"
  printf "\033[%sm%s\033[39;49m\n" "$color" "$text"
}

export RED=31 GREEN=32 YELLOW=33 BLUE=34 MAGENTA=35 CYAN=36

if [[ -e "$target" ]]; then
	if [[ "$(realpath "$target")" = "$(realpath "$source")" ]]; then
		echo "File $target already linked"
		existing=linked
	else
		existing=other
		if ! [[ $FORCE ]]; then
			printf "$(colored $RED "[error]") File %s already exists, use FORCE=1 to replace it (it saves a backup of the current file)\n" "$target"
			exit 1
		fi
		printf "$(colored $YELLOW "[warning]") File %s already exists, overriding it\n" "$target"
	fi
fi

if [[ $existing = none || ($existing = other && $FORCE) ]]; then
	ln -bs "$source" "$target"
	printf "$(colored $GREEN '[linked]') Linked %s to %s\n" "$source" "$target"
fi
