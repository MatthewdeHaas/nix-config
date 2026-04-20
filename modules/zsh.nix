{ pkgs, ... }:

{

	programs.zsh = {
		enable = true;
		enableCompletion = true;
		autosuggestion.enable = true;
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
			nixswitch = "home-manager switch --flake ~/nix-config#matt";
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

			# Mocha-specific Autosuggestion style
			ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#585b70"
			ZSH_AUTOSUGGEST_HISTORY_IGNORE="c|ls|cd|exit"
		'';

	};

	# Tools Zsh evals
	programs.starship = {
		enable = true;
		enableZshIntegration = true; # Change 'Ingegration' to 'Integration'
	};
	# Set PATH based on flake file in a project directory 
	programs.direnv = {
		enable = true;
		nix-direnv.enable = true;
	};

}
