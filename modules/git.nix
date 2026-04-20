{ pkgs, ... }:

{
	programs.git = {
		enable = true;
		userName = "Matthew deHaas";
		userEmail = "mattdehaas28@gmail.com";

		# block large files
		lfs.enable = true;

		extraConfig = {
			init.defaultBranch = "main";
			push.autoSetupRemote = true;
			core.editor = "nvim";
		};
		
	};
}
