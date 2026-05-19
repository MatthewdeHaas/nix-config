{ pkgs, ... }:

{
  home.packages = [ pkgs.jujutsu ];

  xdg.configFile."jj/config.toml".text = ''
    [user]
    name = "Matthew"
    email = "mattdehaas28@gmail.com"

    [ui]
    paginate = "never"
    default-command = "log"
		log-template = "builtin_log_compact"

    [aliases]
    l = ["log", "--no-pager"]

  '';

  programs.zsh.initExtra = ''
    # jj completions
    source <(COMPLETE=zsh jj)
  '';
}
