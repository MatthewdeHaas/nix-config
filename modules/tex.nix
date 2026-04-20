{ pkgs, ... }:

{
	home.packages = with pkgs; [
		(texlive.combine {
			inherit (texlive) 
			scheme-small
			collection-latexextra 
			collection-mathscience
			amsmath
			physics
			;
		})
	];
}
