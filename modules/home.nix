{ pkgs, ... }:

{

	imports = [
		./neovim.nix
		./zsh.nix
		./kitty.nix
		./tmux.nix
		./git.nix
		./eza.nix
		./zathura.nix
	];

	home.username = "matthewdehaas";
	home.homeDirectory = "/Users/matthewdehaas";
	home.stateVersion = "23.11";

	# Global packages
	home.packages = with pkgs; [
		nerd-fonts.jetbrains-mono
		# Core CLI tools
		bat
		fzf
		ripgrep
		htop
		fastfetch
		pstree
		watch
		fswatch
		pandoc
		pass

		# Languages + Runtimes
		nodejs_22
		pnpm
		(python3.withPackages (ps: with ps; [ pip requests ]))
		uv
		R
		solc

		# Development Tools
		git
		tmux
		starship
		cmake
		meson
		gcc

		# Cloud Infrastructure
		doctl

		# Media Tools
		ffmpeg
		mpv
		zathura
		poppler

	];

	# Let Home Manager install and manage itself 
	programs.home-manager.enable = true;
}
