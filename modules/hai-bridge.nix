{ config, ... }:

{
  launchd.agents.hai-lan-bridge = {
    enable = true;
    config = {
      Label = "local.hai-lan-bridge";
      ProgramArguments = [
        "/run/current-system/sw/bin/node"
        "${config.home.homeDirectory}Projects/hai-proxy-tunnel/hai-lan-bridge.js"
        "--port" "6656"
      ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "/tmp/hai-lan-bridge.log";
      StandardErrorPath = "/tmp/hai-lan-bridge.err";
      EnvironmentVariables = {
        PATH = "/run/current-system/sw/bin:/usr/local/bin:/usr/bin:/bin";
      };
    };
  };
}
