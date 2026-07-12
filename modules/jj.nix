{ pkgs, ... }:

{
	programs.jujutsu = {
		enable = true;
		settings = {
			user = {
				name = "Matthew";
				email = "mattdehaas28@gmail.com";
			};
			ui = {
				paginate = "never";
				log-template = ''separate(" ", change_id.shortest(), if(empty, "(empty)"), if(conflict, "(conflict)"), description.first_line())'';
			};
			aliases = {
				l = ["log" "--no-pager"];
			};
		};
	};

	programs.zsh.initContent = ''
		source <(COMPLETE=zsh jj)
	'';
}
