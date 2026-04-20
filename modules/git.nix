{ pkgs, ... }:

{
	programs.git = {
		enable = true;
		settings = {
			user = {
				name = "Matthew deHaas";
				email = "mattdehaas28@gmail.com";
			};
			signing = {
				key = "AEA7178A37D0A93B";
				signByDefault = true;
				format = "openpgp";
			};

			init.defaultBranch = "main";
			push.autoSetupRemote = true;
			core.editor = "nvim";
		};
	};
}
