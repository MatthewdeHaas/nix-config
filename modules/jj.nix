{ pkgs, ... }:

let
  jjConfig = pkgs.writeText "jj-config.toml" ''
    [user]
    name = "Matthew"
    email = "mattdehaas28@gmail.com"

    [ui]
    paginate = "never"
    default-command = "log"
    log-template = 'separate(" ", change_id.shortest(), if(empty, "(empty)"), if(conflict, "(conflict)"), description.first_line()) ++ "\n"'

    [aliases]
    l = ["log", "--no-pager"]
  '';
in
{
  home.packages = [ pkgs.jujutsu ];

  xdg.configFile."jj/config.toml".source = jjConfig;

  programs.zsh.initExtra = ''
    source <(COMPLETE=zsh jj)
  '';
}
