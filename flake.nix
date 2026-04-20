# Tells nix to fetch Nixpkgs and Home Manager Libraries
{
	description = "Matt's Universal Nix Configuration file";

	inputs = {
		# Where packages are retrieved from
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

		# Home manager
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { self, nixpkgs, home-manager, ... }: {
		homeConfigurations = {
			# Mac OS 	
			"matthewdehaas" = home-manager.lib.homeManagerConfiguration {
				pkgs = nixpkgs.legacyPackages.aarch64-darwin;
				modules = [ ./modules/home.nix ];
			};

			# NixOS
			"manix" = home-manager.lib.homeManagerConfiguration {
				pkgs = nixpkgs.legacyPackages.x86_64-linux;
				modules = [ ./modules/home.nix ];
			};
		};
	};
	
}
