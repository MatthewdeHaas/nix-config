{ pkgs, ... };

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
      tlog = "tspin";
      dashboard = "btop";
      l = "eza --icons --group-directories-first";
      ls = "eza --icons --group-directories-first";
      ll = "eza -lh --icons --group-directories-first --git";
      la = "eza -a --icons --group-directories-first";
      lt = "eza --tree --level=2 --icons";
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
		initExtra = ''
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
	programs.starship.enable = true;
	programs.starship.enableZshIngegration = true;

}
