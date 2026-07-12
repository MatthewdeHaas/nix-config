{ config, pkgs, lib, user, ... }:

{
	# EFI boot loader
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	# Not compressed as it would introduce CPU load during memory swaps, slowing performance further
	swapDevices = [{
		device = "/swap/swapfile";
		size = 8192;
	}];

	# Networking
	networking.hostName = "thinkpad";
	networking.networkmanager.enable = true;
	networking.firewall.enable = true;

	# Audio
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		pulse.enable = true;
	};

	# Bluetooth
	hardware.bluetooth = {
		enable = true;
		powerOnBoot = true;
		settings.General.Experimental = true;
	};

	# Hyprland
	programs.hyprland.enable = true;

	# Wayland gateway for apps performing sensitive actions (share screen, read files, etc.)
	xdg.portal = {
		enable = true;
		extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
	};

	# Login TUI
	services.greetd = {
		enable = true;
		settings.default_session = {
			command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
			user = "greeter";
		};
	};

	# Snapshots (btrfs)
	services.snapper = {
		snapshotInterval = "hourly";
		cleanupInterval = "1d";
		configs = {
			root = {
				SUBVOLUME = "/";
				TIMELINE_CREATE = true;
				TIMELINE_CLEANUP = true;
				TIMELINE_LIMIT_HOURLY = 10;
				TIMELINE_LIMIT_DAILY = 7;
				TIMELINE_LIMIT_WEEKLY = 4;
				TIMELINE_LIMIT_MONTHLY = 3;
			};
			home = {
				SUBVOLUME = "/home";
				TIMELINE_CREATE = true;
				TIMELINE_CLEANUP = true;
				TIMELINE_LIMIT_HOURLY = 10;
				TIMELINE_LIMIT_DAILY = 7;
				TIMELINE_LIMIT_WEEKLY = 4;
				TIMELINE_LIMIT_MONTHLY = 3;
			};
		};
	};

	# Power management (ThinkPad)
	services.tlp = {
		enable = true;
		settings = {
			# Only charge below...
			START_CHARGE_THRESH_BAT0 = 75;

			# Stop charging at...
			STOP_CHARGE_THRESH_BAT0 = 80;

			# CPU-level power policy
			CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
			CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

			# Platform-level power policy
			PLATFORM_PROFILE_ON_BAT = "low-power";
			PLATFORM_PROFILE_ON_AC = "performance";
		};
	};

	# Thermal daemon (Intel chip only)
	services.thermald.enable = true;

	# Firmware updates
	services.fwupd.enable = true;

	# User
	users.users.${user} = {
		isNormalUser = true;
		extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
		shell = pkgs.zsh;
	};
	programs.zsh.enable = true;

	# System packages
	environment.systemPackages = with pkgs; [
		vim
		git
		curl
		brightnessctl
		polkit_gnome
	];

	# Security
	security.polkit.enable = true;
	security.rtkit.enable = true;

	# Locale
	time.timeZone = "America/Vancouver";
	i18n.defaultLocale = "en_CA.UTF-8";

	# Hardware
	hardware.graphics.enable = true;

	# Nix
	nixpkgs.config.allowUnfree = true;
	nix.settings.experimental-features = [ "nix-command" "flakes" ];

	system.stateVersion = "24.11";
}
