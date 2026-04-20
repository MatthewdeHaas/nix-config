{ pkgs, ... }:

{
	programs.git = {
		enable = true;
		settings = {
			user = {
				name = "Matthew deHaas";
				email = "mattdehaas28@gmail.com";
			};

			init.defaultBranch = "main";
			push.autoSetupRemote = true;
			core.editor = "nvim";
			signing.format = null;	
		};
	};
}
