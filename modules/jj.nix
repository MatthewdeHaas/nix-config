{ pkgs, ... }:

{
  home.packages = [ pkgs.jujutsu ];

	xdg.configFile."jj/config.toml".text = builtins.concatStringsSep "\n" [
		"[user]"
		"name = \"Matthew\""
		"email = \"mattdehaas28@gmail.com\""
		""
		"[ui]"
		"paginate = \"never\""
		"default-command = \"log\""
		''log-template = 'separate(" ", if(current_working_copy, "@", if(immutable, "◆", "○")), change_id.shortest(), if(empty, "(empty)"), if(conflict, "(conflict)"), description.first_line()) ++ "\n"' ''
		""
		"[aliases]"
		''l = ["log", "--no-pager"]''
	];

  programs.zsh.initExtra = ''
    # jj completions
    source <(COMPLETE=zsh jj)
  '';
}
