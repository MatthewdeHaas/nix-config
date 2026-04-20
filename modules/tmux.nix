{ pkgs, ... }:

{
	programs.tmux = {
		enable = true;
		shell = "${pkgs.zsh}/bin/zsh";
		terminal = "xterm-kitty";
		mouse = true;

		# Theme + config
		plugins = with pkgs.tmuxPlugins; [
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavor 'mocha'
          set -g @catppuccin_window_status_style "slanted"
          set -g @catppuccin_status_modules_right "application session date_time"
        '';
      }
    ];

		# Cursor adjustments
		extraConfig = ''
      # Hide the status bar (as per your config)
      set -g status off

      # Pass cursor shape sequences to Kitty
      # This ensures your Neovim cursor stays a beam in Insert mode inside Tmux
      set -as terminal-overrides ',xterm-kitty:Ss=\E[%p1%d q:Se=\E[2 q'

      # Fix colors
      set -ga terminal-overrides ",xterm-256color:Tc"
    '';
	};
}
