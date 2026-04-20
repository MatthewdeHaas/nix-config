{ pkgs, ... };

{

	imports = [
		./neovim.nix
		./zsh.nix
		./kitty.nix
	];

	home.username = "matt";
	home.homeDirectory = "/User/matthewdehaas";
	home.stateVersion = "23.11";

	# Packages
	home.packages = with pkgs; [
		direnv
		nix-direnv
	]

	programs.zsh = {
		enable = true;
		shellAlias = {
			nixswitch = "home-manager switch --flake ~/nix-config#matt";
		};
	};

	# Let Home Manager install and manage itself 
	programs.home-manager.enable = true;
}
