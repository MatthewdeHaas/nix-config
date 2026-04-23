{ pkgs, ... }:

{

	programs.zsh = {
		enable = true;
		enableCompletion = true;
		autosuggestion.enable = false;
		syntaxHighlighting.enable = true;

		# Oh My Zsh
		oh-my-zsh = {
			enable = true;
			plugins = [
				"git" 
				"python" 
				"docker" 
				"docker-compose" 
				"extract"
				"pip"
				"gh"
				"sudo"
				"colored-man-pages"
			];
		};

		# Aliases
		shellAliases = {
			nv = "nvim";
			snv = "nvim --";
			py = "python3";
			c = "clear";
			r = "Rscript";
			ghostscript = "gs";
		};

		# Shell history
		history = {
			size = 10000;
			ignoreDups = true;
			ignoreAllDups = true;
			ignoreSpace = true;
			expireDuplicatesFirst = true;
			share = true;
		};

		# Misc. config
		initContent = ''
			# Set cursor to steady beam in precmd
			precmd() { echo -ne '\e[6 q'; }

			# Python UV Management
			export UV_PYTHON_PREFERENCE=only-managed

			# Kitty image display function
			show() {
				echo ""
				kitty +kitten icat "$1"
				echo ""
			}
			# Only autocomplete image files for show
			compdef '_files -g "*.{png,jpg,jpeg,gif,webp,svg}"' show

			nixswitch() {
				local profile=''${1:-matthewdehaas}
				home-manager switch --flake ~/nix-config#"$profile"
			}

			nixsync() {
				local OPTIND opt msg
				local commit_msg=""

				while getopts "m:" opt; do
					case $opt in
						m) COMMIT_MSG="$OPTARG" ;;
						*) echo "Usage $0 [-m 'commit message']" && exit 1 ;;
					esac
				done

				shift $((OPTIND - 1))

				cd ~/nix-config || return
				git add .

				if nixswitch "@0"; then
					echo "--- Switch Successful ---"
				else
					echo "--- Switch Failed! Aborting Git sync. ---"
					return 1
				fi

				if git diff-index --quiet HEAD --; then
					echo "--- No changes detected. Nothing to commit. ---"
				else
					if [ -z "$commit_msg" ]; then
						commit_msg="Sync $(date +'%Y-%m-%d %H:%M')"
					fi
					git commit -m "$commit_msg"
					echo "--- Pushing change...s ---"
					git push
				fi
				echo "--- Done! ---"
			}



			export GPG_TTY=$TTY
			export DIRENV_LOG_FORMAT=""
		'';

	};

	# Tools Zsh evals
	programs.starship = {
		enable = true;
		enableZshIntegration = true;
	};

	# Set PATH based on flake file in a project directory 
	programs.direnv = {
		enable = true;
		nix-direnv.enable = true;
		enableZshIntegration = true;
	};

}
