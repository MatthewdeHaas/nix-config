{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellScriptBin "hai-toggle" (builtins.readFile ./hai-toggle.sh))
  ];
}
