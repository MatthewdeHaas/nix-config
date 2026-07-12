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

		# Hardware
		nixos-hardware.url = "github:NixOS/nixos-hardware/master";

		# Declarative disk partitioning
		disko = {
			url = "github:nix-community/disko";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { self, nixpkgs, home-manager, nixos-hardware, disko, ... }:
		let
			macUser = "matthewdehaas";
			nixUser = "matt";
		in
		{
			# Mac OS
			homeConfigurations."macbook" = home-manager.lib.homeManagerConfiguration {
				pkgs = nixpkgs.legacyPackages.aarch64-darwin;
				modules = [
					./modules/home.nix

					# Let Home Manager install and manage itself (standalone mode only)
					{ programs.home-manager.enable = true; }
				];
				extraSpecialArgs = { user = macUser; };
			};

			# ThinkPad + NixOS
			nixosConfigurations.thinkpad = nixpkgs.lib.nixosSystem {
				specialArgs = { user = nixUser; };
				modules = [
					{ nixpkgs.hostPlatform = "x86_64-linux"; }
					./hosts/thinkpad/configuration.nix
					./hosts/thinkpad/disk.nix
					./hosts/thinkpad/hardware-configuration.nix

					disko.nixosModules.disko

					# TODO: Change to actual machine model after purchase
					nixos-hardware.nixosModules.common-pc-laptop

					home-manager.nixosModules.home-manager

					# Configure home manager in line here
					{
						home-manager.useGlobalPkgs = true;
						home-manager.useUserPackages = true;
						home-manager.users.${nixUser} = {
							imports = [
								./modules/home.nix
								./modules/hyprland.nix
							];
						};
						home-manager.extraSpecialArgs = { user = nixUser; };
					}
				];
			};
		};
}
