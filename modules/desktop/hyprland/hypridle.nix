{
  config,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.hyprland;
in {
  config = mkIf cfg.enable {
    home-manager.users.${config.modules.user.username} = {pkgs, ...}: {
      services.hypridle = {
        enable = true;

        settings = {
          general = {
            before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
            after_sleep_cmd = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
            lock_cmd = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
          };

          listener = [
            {
              timeout = 180;
              on-timeout = "${pkgs.systemd}/bin/loginctl lock-session";
              on-resume = "";
            }
            {
              timeout = 240;
              on-timeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
              on-resume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
            }
            {
              timeout = 600;
              on-timeout = "${pkgs.systemd}/bin/systemctl suspend-then-hibernate";
              on-resume = "";
            }
          ];
        };
      };
    };
  };
}
