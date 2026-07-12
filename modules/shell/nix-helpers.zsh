NIX_CONFIG_DIR="$HOME/nix-config"

nixswitch() {
	local profile=${1:-macbook}
	home-manager switch --option warn-dirty false --flake "$NIX_CONFIG_DIR#$profile" &>/dev/null
}

nixsync() {
	local OPTIND opt
	local commit_msg=""

	while getopts "m:" opt; do
		case $opt in
			m) commit_msg="$OPTARG" ;;
			*) printf "\033[33musage:\033[0m nixsync [-m 'message'] [profile]\n"; return 1 ;;
		esac
	done
	shift $((OPTIND - 1))
	local target_profile="$1"

	cd "$NIX_CONFIG_DIR" || return
	git add .

	printf "\033[34m⟳\033[0m switching...\n"
	if nixswitch "$target_profile"; then
		printf "\033[32m✓\033[0m switch complete\n"
	else
		printf "\033[31m✗\033[0m switch failed\n"
		return 1
	fi

	if git diff-index --quiet HEAD --; then
		printf "\033[90m  no changes to commit\033[0m\n"
	else
		[[ -z "$commit_msg" ]] && commit_msg="Sync $(date +'%Y-%m-%d %H:%M')"
		git commit -qm "$commit_msg"
		printf "\033[34m⟳\033[0m pushing...\n"
		git push -q
		printf "\033[32m✓\033[0m pushed \033[90m%s\033[0m\n" "$(git log -1 --format='%h %s')"
	fi
}
