{
  config,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.hyprland;
in {
  config = mkIf cfg.polkit {
    security.polkit.enable = true;

    home-manager.users.${config.modules.user.username} = {pkgs, ...}: {
      home.packages = with pkgs; [
        lxqt.lxqt-policykit
      ];

      wayland.windowManager.hyprland.settings."exec-once" = ["${pkgs.lxqt.lxqt-policykit}/bin/lxqt-policykit-agent"];
    };
  };
}
