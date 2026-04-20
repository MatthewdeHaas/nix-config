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
	home.homeDirectory = "/User/matthewdehaas";
	home.stateVersion = "23.11";

	# Global packages
	home.packages = with pkgs; [
		(nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
	];

	# Let Home Manager install and manage itself 
	programs.home-manager.enable = true;
}
