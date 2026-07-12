{ pkgs, lib, ... }:

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
			l = "ls";
			nv = "nvim";
			snv = "nvim --";
			py = "python3";
			c = "clear";
			r = "Rscript";
			e = "exit";
			cl = "claude";
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

		initContent = builtins.concatStringsSep "\n" [
			(builtins.readFile ./shell/env.zsh)
			(builtins.readFile ./shell/prompt.zsh)
			(builtins.readFile ./shell/functions.zsh)
			(builtins.readFile ./shell/nix-helpers.zsh)
			''
				[ -f ~/.zshrc.local ] && source ~/.zshrc.local
			''
		];

	};

	# Set PATH based on flake file in a project directory 
	programs.direnv = {
		enable = true;
		nix-direnv.enable = true;
		enableZshIntegration = true;
	};

}
