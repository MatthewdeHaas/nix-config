{ pkgs, ... }:

let
  jjConfig = pkgs.writeText "jj-config.toml" ''
    [user]
    name = "Matthew"
    email = "mattdehaas28@gmail.com"

    [ui]
    paginate = "never"
		log-template = 'separate(" ", change_id.shortest(), if(empty, "(empty)"), if(conflict, "(conflict)"), description.first_line())'

    [aliases]
    l = ["log", "--no-pager"]
  '';
in
{
  home.packages = [ pkgs.jujutsu ];

  xdg.configFile."jj/config.toml".source = jjConfig;

  programs.zsh.initContent = ''
    source <(COMPLETE=zsh jj)
  '';
}
