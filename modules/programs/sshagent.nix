{
  config,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.programs.sshagent;
in {
  options.modules.programs.sshagent = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.modules.user.username} = {pkgs, ...}: {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
      };

      services.ssh-agent.enable = true;
    };
  };
}
