{ pkgs, ... }:

{
	programs.zathura = {
		enable = true;
		options = {
			selection-clipboard = "clipboard";
			recolor = true;
			recolor-keephue = true;

			# Catppuccin Mocha theme
			default-bg = "#1e1e2e";
			default-fg = "#cdd6f4";
		};
	};
}
