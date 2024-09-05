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
    services.upower.enable = true;
    services.gvfs.enable = true;

    home-manager.users.${config.modules.user.username} = {pkgs, ...}: {
      imports = [inputs.waw.homeManagerModules.default];

      programs.waw.enable = true;
    };

    modules.impermanence = {
      unsafe.userFolders = [
        ".cache/ags/apps"
      ];
    };
  };
}
