{ pkgs, ... }:

{

	imports = [
		./neovim.nix
		./zsh.nix
		./kitty.nix
		./tmux.nix
		./git.nix
		./eza.nix
	];

	home.username = "matthewdehaas";
	home.homeDirectory = "/Users/matthewdehaas";
	home.stateVersion = "23.11";

	# Global packages
	home.packages = with pkgs; [
		nerd-fonts.jetbrains-mono
	];

	# Let Home Manager install and manage itself 
	programs.home-manager.enable = true;
}
