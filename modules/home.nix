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
		./tex.nix
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
		fd
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
		uv

		# Development Tools
		git
		tmux
		starship
		cmake
		meson
		gcc

		# Security/Secrets
		gnupg
		pinentry_mac

		# Cloud Infrastructure
		doctl
		kubo

		# Media Tools
		ffmpeg
		mpv
		zathura
		poppler
		ghostscript
		tesseract

	];

	services.gpg-agent = {
		enable = true;
		defaultCacheTtl = 1800;
		pinentry.package = pkgs.pinentry_mac;
		extraConfig = ''
			pinentry-program ${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac
		'';
	};

	# Let Home Manager install and manage itself 
	programs.home-manager.enable = true;
}
