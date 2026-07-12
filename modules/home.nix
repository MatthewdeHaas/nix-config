{ pkgs, lib, user, ... }:

{

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
		gh
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
	] ++ lib.optionals pkgs.stdenv.isLinux [
		bluetui
		protonvpn-cli
		protonvpn-gui
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

	nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
		"claude-code"
	];

}
