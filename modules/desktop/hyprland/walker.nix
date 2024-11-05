{
  config,
  lib,
  inputs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.hyprland;
in {
  config = mkIf cfg.enable {
    home-manager.users.${config.modules.user.username} = {pkgs, ...}: {
      imports = [inputs.walker.homeManagerModules.default];

      programs.walker = {
        enable = true;
        runAsService = true;
      };
    };
  };
}
