{ pkgs, ... };

{

	programs.kitty = {
		enable = true;
		
		# Font
		font = {
			name = "JetBrainsMono Nerd Font Mono";
			size = 12;
		};

		# Theme
		themeFile = "Catppuccin-Mocha";

		# Settings
		settings = {
      # Window & Padding
      window_padding_width = 10;
      hide_window_decorations = "yes";

      # Tab Bar
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      active_tab_foreground = "#11111b";
      active_tab_background = "#cba6f7";
      inactive_tab_foreground = "#cdd6f4";
      inactive_tab_background = "#181825";

      # Cursor
      cursor_shape = "beam";
      cursor_beam_thickness = "1.5";

      # Mouse & Interaction
      focus_follows_mouse = "yes";
      detect_urls = "yes";
    };

    # Misc. 
    extraConfig = ''
      # Allow scrolling to send actual up/down keys
      mouse_reporting yes
    '';
	};

	# Ensure font is available
	home.packages = [
		(pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
	];

}
