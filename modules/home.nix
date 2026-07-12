{ pkgs, lib, user, ... }:

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

	home.username = user;
	home.homeDirectory = 
		if pkgs.stdenv.isDarwin
		then "/Users/${user}"
		else "/home/${user}";
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
		nodejs_24
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
		(if pkgs.stdenv.isDarwin then pinentry_mac else pinentry-gnome3)

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
		pinentry.package = 
			if pkgs.stdenv.isDarwin
			then pkgs.pinentry_mac
			else pkgs.pinentry-gnome3;
	};

}
