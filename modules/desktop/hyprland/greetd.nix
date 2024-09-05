{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.hyprland;
in {
  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;

      settings = rec {
        initial_session = {
          command = "${pkgs.hyprland}/bin/Hyprland";
          user = "${config.modules.user.username}";
        };
        default_session = initial_session;
      };
    };
  };
}
