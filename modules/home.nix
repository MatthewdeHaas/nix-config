{ pkgs, lib, ... }:

{

	home.sessionPath = [
		"$HOME/.local/bin"
	];

	nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
		"claude-code"
	];

	imports = [
		./neovim.nix
		./zsh.nix
		./kitty.nix
		./tmux.nix
		./git.nix
		./eza.nix
		# ./zathura.nix
		./tex.nix
		./jj.nix
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
		rustup
		nodejs_22
		pnpm
		python314
		uv
		R
		solc

		# Development Tools
		git
		gh
		tmux
		cmake
		meson
		gcc
		claude-code

		# Security/Secrets
		gnupg
		pinentry_mac

		# Cloud Infrastructure
		doctl
		kubo

		# Media Tools
		ffmpeg
		mpv
		# zathura  # temporarily disabled — appstream build broken on macOS in current nixpkgs
		poppler
		ghostscript
		tesseract
	];

	# Security/Secrets manager
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
