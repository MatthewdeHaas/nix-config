{ pkgs, lib, ... }:

{
	wayland.windowManager.hyprland = {
		enable = true;
		settings = {
			"$mod" = "SUPER";

			# Catppuccin Mocha
			general = {
				gaps_in = 4;
				gaps_out = 8;
				border_size = 2;
				"col.active_border" = "rgba(cba6f7ff)";
				"col.inactive_border" = "rgba(313244ff)";
			};

			decoration = {
				rounding = 8;
				blur.enabled = true;
				blur.size = 4;
				blur.passes = 2;
				shadow.enabled = false;
			};

			animations = {
				enabled = true;
				bezier = "smooth, 0.25, 0.1, 0.25, 1";
				animation = [
					"windows, 1, 4, smooth"
					"windowsOut, 1, 4, smooth, popin 80%"
					"fade, 1, 3, smooth"
					"workspaces, 1, 3, smooth"
				];
			};

			input = {
				touchpad = {
					natural_scroll = true;
					tap-to-click = true;
				};
			};

			misc = {
				disable_hyprland_logo = true;
				disable_splash_rendering = true;
			};

			# Window rules
			windowrulev2 = [
				"float, class:polkit-gnome-authentication-agent-1"
			];

			# Autostart
			exec-once = [
				"waybar"
				"mako"
				"hypridle"
				"${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
			];

			# Keybindings
			bind = [
				"$mod, Return, exec, kitty"
				"$mod, D, exec, rofi -show drun -show-icons"
				"$mod, Q, killactive"
				"$mod, F, fullscreen"
				"$mod, V, togglefloating"
				"$mod, P, pseudo"

				# Focus (vim keys)
				"$mod, H, movefocus, l"
				"$mod, L, movefocus, r"
				"$mod, K, movefocus, u"
				"$mod, J, movefocus, d"

				# Move windows
				"$mod SHIFT, H, movewindow, l"
				"$mod SHIFT, L, movewindow, r"
				"$mod SHIFT, K, movewindow, u"
				"$mod SHIFT, J, movewindow, d"

				# Resize
				"$mod CTRL, H, resizeactive, -40 0"
				"$mod CTRL, L, resizeactive, 40 0"
				"$mod CTRL, K, resizeactive, 0 -40"
				"$mod CTRL, J, resizeactive, 0 40"

				# Workspaces
				"$mod, 1, workspace, 1"
				"$mod, 2, workspace, 2"
				"$mod, 3, workspace, 3"
				"$mod, 4, workspace, 4"
				"$mod, 5, workspace, 5"
				"$mod SHIFT, 1, movetoworkspace, 1"
				"$mod SHIFT, 2, movetoworkspace, 2"
				"$mod SHIFT, 3, movetoworkspace, 3"
				"$mod SHIFT, 4, movetoworkspace, 4"
				"$mod SHIFT, 5, movetoworkspace, 5"

				# Screenshots
				", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
				"$mod, Print, exec, grim - | wl-copy"

				# Lock
				"$mod, Escape, exec, hyprlock"
			];

			# Volume/brightness (repeat on hold)
			bindel = [
				", XF86MonBrightnessUp, exec, brightnessctl set +5%"
				", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
				", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
				", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
				", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
			];

			# Mouse bindings
			bindm = [
				"$mod, mouse:272, movewindow"
				"$mod, mouse:273, resizewindow"
			];
		};
	};

	# Status bar
	programs.waybar = {
		enable = true;
		settings.mainBar = {
			layer = "top";
			height = 32;
			spacing = 8;
			modules-left = [ "hyprland/workspaces" ];
			modules-center = [ "clock" ];
			modules-right = [ "battery" ];
			clock = {
				format = "{:%H:%M}";
				format-alt = "{:%a %b %d}";
				tooltip-format = "{:%Y-%m-%d %H:%M}";
			};
			battery = {
				format = "{icon} {capacity}%";
				format-charging = "󰂄 {capacity}%";
				format-icons = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
				states = {
					warning = 20;
					critical = 10;
				};
			};
		};
		style = ''
			* {
				font-family: "JetBrainsMono Nerd Font";
				font-size: 13px;
			}

			window#waybar {
				background: rgba(30, 30, 46, 0.9);
				color: #cdd6f4;
			}

			#workspaces button {
				color: #6c7086;
				padding: 0 6px;
			}

			#workspaces button.active {
				color: #cba6f7;
			}

			#clock {
				color: #cdd6f4;
			}

			#battery {
				color: #a6e3a1;
			}

			#battery.warning {
				color: #f9e2af;
			}

			#battery.critical {
				color: #f38ba8;
			}
		'';
	};

	# Notifications
	services.mako = {
		enable = true;
		settings = {
			default-timeout = 5000;
			background-color = "#1e1e2e";
			text-color = "#cdd6f4";
			border-color = "#cba6f7";
			border-radius = 8;
			font = "JetBrainsMono Nerd Font 11";
		};
	};

	# Screen lock
	programs.hyprlock = {
		enable = true;
		settings = {
			background = [{
				color = "rgba(30, 30, 46, 1.0)";
			}];
			input-field = [{
				size = "250, 50";
				outline_thickness = 2;
				outer_color = "rgba(203, 166, 247, 1.0)";
				inner_color = "rgba(49, 50, 68, 1.0)";
				font_color = "rgba(205, 214, 244, 1.0)";
				placeholder_text = "";
			}];
		};
	};

	# Idle management
	services.hypridle = {
		enable = true;
		settings = {
			general = {
				lock_cmd = "pidof hyprlock || hyprlock";
				before_sleep_cmd = "loginctl lock-session";
			};
			listener = [
				{ timeout = 300; on-timeout = "hyprlock"; }
				{ timeout = 600; on-timeout = "systemctl suspend"; }
			];
		};
	};

	# App launcher (rofi)
	programs.rofi = {
		enable = true;
		package = pkgs.rofi-wayland;
		theme = let
			inherit (builtins) toString;
		in lib.mkForce (pkgs.writeText "catppuccin-rofi" ''
			* {
				bg: #1e1e2e;
				fg: #cdd6f4;
				accent: #cba6f7;
				urgent: #f38ba8;
			}

			window {
				background-color: @bg;
				border: 2px;
				border-color: @accent;
				border-radius: 8px;
				width: 500px;
			}

			inputbar {
				background-color: @bg;
				text-color: @fg;
				padding: 12px;
			}

			prompt {
				text-color: @accent;
			}

			entry {
				text-color: @fg;
				placeholder-color: #6c7086;
			}

			listview {
				background-color: @bg;
				lines: 8;
				padding: 0 12px 12px 12px;
			}

			element {
				padding: 8px;
				border-radius: 4px;
			}

			element selected {
				background-color: #313244;
				text-color: @accent;
			}

			element-text {
				text-color: inherit;
			}
		'');
	};

	# Desktop packages
	home.packages = with pkgs; [
		grim
		slurp
		wl-clipboard
		wl-clip-persist
	];
}
