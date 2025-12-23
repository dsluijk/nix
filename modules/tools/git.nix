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
    lfs = mkBoolOpt true;
    name = mkStrOpt "Dany Sluijk";
    email = mkStrOpt "me@dany.dev";
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.modules.user.username} = {pkgs, ...}: {
      programs.git = {
        enable = true;
        lfs.enable = cfg.lfs;

        settings = {
          pull.ff = "only";
          push.autoSetupRemote = true;
          init.defaultBranch = "main";

          user = {
            name = cfg.name;
            email = cfg.email;
          };
        };
      };
    };
  };
}
