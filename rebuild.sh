#!/usr/bin/env zsh


COMMIT_MSG=""

while getopts "m:" opt; do
	case $opt in
		m) COMMIT_MSG="$OPTARG" ;;
		*) echo "Usage $0 [-m 'commit message']" && exit 1 ;;
	esac
done

echo "--- Starting Nix Switch ---"

if nixswitch; then
	echo "--- Switch Successful ---"
else
	echo "--- Switch Failed! Aborting Git sync. ---"
    exit 1
fi

git add .

if git diff-index --quiet HEAD --; then
	echo "--- No changes detected. Nothing to commit. ---"
else
	if [ -z "$COMMIT_MSG" ]; then
		COMMIT_MSG="Sync $(date +'%Y-%m-%d %H:%M')"
	fi
	git commit -m "$commit_msg"
	echo "--- Pushing change...s ---"
	git push
fi

echo "--- Done! ---"
