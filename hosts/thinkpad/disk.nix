{ ... }:

{
	disko.devices.disk.main = {
		device = "/dev/nvme0n1";
		type = "disk";
		content = {
			type = "gpt";
			partitions = {
				esp = {
					size = "512M";
					type = "EF00";
					content = {
						type = "filesystem";
						format = "vfat";
						mountpoint = "/boot";
						mountOptions = [ "umask=0077" ];
					};
				};
				root = {
					size = "100%";
					content = {
						type = "luks";
						name = "cryptroot";
						settings.allowDiscards = true;
						content = {
							type = "btrfs";
							extraArgs = [ "-f" ];
							subvolumes = {
								"@root" = {
									mountpoint = "/";
									mountOptions = [ "compress=zstd:1" "noatime" ];
								};
								"@home" = {
									mountpoint = "/home";
									mountOptions = [ "compress=zstd:1" "noatime" ];
								};
								"@nix" = {
									mountpoint = "/nix";
									mountOptions = [ "compress=zstd:1" "noatime" ];
								};
								"@swap" = {
									mountpoint = "/swap";
									mountOptions = [ "noatime" ];
								};
							};
						};
					};
				};
			};
		};
	};
}
