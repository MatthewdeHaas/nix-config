# Tells nix to fetch Nixpkgs and Home Manager Libraries
{
	description = "Matt's Universal Nix Configuration file";

	inupts = {
		# Where packages are retrieved from
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

		# Home manager
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = {
		let 
			system = "aarch64-darwin";
			pkgs = nixpkgs.legacyPackages.${system};
		in {
			homeConfigurations."matt" = home-manager.lib.homeManagerConfiguration {
				inherit pkgs;
				modules = [ .modules/home.nix ]
			};
		};
	};
}
