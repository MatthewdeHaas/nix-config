{ config, pkgs, lib, ... }:

{
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	boot.initrd.luks.devices."cryptroot" = {
		device = "/dev/disk/by-uuid/REPLACE-AT-INSTALL";
		allowDiscards = true;
	};

	fileSystems."/" = {
		device = "/dev/mapper/cryptroot";
		fsType = "btrfs";
		options = [ "subvol=@root" "compress=zstd:1" "noatime" ];
	};

	fileSystems."/home" = {
		device = "/dev/mapper/cryptroot";
		fsType = "btrfs";
		options = [ "subvol=@home" "compress=zstd:1" "noatime" ];
	};

	fileSystems."/nix" = {
		device = "/dev/mapper/cryptroot";
		fsType = "btrfs";
		options = [ "subvol=@nix" "compress=zstd:1" "noatime" ];
	};

	fileSystems."/swap" = {
		device = "/dev/mapper/cryptroot";
		fsType = "btrfs";
		options = [ "subvol=@swap" "noatime" ];
	};

	fileSystems."/boot" = {
		device = "/dev/disk/by-uuid/REPLACE-AT-INSTALL";
		fsType = "vfat";
	};

	swapDevices = [{
		device = "/swap/swapfile";
		size = 8192;
	}];

	# Networking
	networking.hostName = "manix";
	networking.networkmanager.enable = true;
	networking.firewall.enable = true;

	# Bluetooth
	hardware.bluetooth = {
		enable = true;
		powerOnBoot = true;
		settings.General.Experimental = true;
	};
	services.blueman.enable = true;

	# Audio
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		pulse.enable = true;
	};

	# Hyprland
	programs.hyprland.enable = true;

	services.greetd = {
		enable = true;
		settings.default_session = {
			command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
			user = "greeter";
		};
	};

	xdg.portal = {
		enable = true;
		extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
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
			START_CHARGE_THRESH_BAT0 = 75;
			STOP_CHARGE_THRESH_BAT0 = 80;
			CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
			CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
		};
	};
	services.thermald.enable = true;

	# Firmware updates
	services.fwupd.enable = true;

	# User
	users.users.matt = {
		isNormalUser = true;
		extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
		shell = pkgs.zsh;
	};
	programs.zsh.enable = true;

	# System packages
	environment.systemPackages = with pkgs; [
		vim
		git
		wget
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
