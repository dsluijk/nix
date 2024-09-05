{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.tools.git;
in {
  options.modules.tools.git = {
    enable = mkBoolOpt true;
    name = mkStrOpt "Dany Sluijk";
    email = mkStrOpt "me@dany.dev";
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.modules.user.username} = {pkgs, ...}: {
      programs.git = {
        enable = true;
        userName = cfg.name;
        userEmail = cfg.email;
        extraConfig = {
          pull.ff = "only";
          init.defaultBranch = "main";
        };
      };
    };
  };
}
