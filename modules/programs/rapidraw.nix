{
  config,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.programs.rapidraw;
in {
  options.modules.programs.rapidraw = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.modules.user.username} = {pkgs, ...}: {
      home.packages = with pkgs; [
        rapidraw
      ];
    };
  };
}
