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
    home-manager.users.${config.modules.user.username} = {pkgs, ...}: {
      programs.hyprlock = {
        enable = true;

        settings = {
          general = {
            grace = 5;
          };

          background = [
            {
              monitor = "";
              path = "screenshot";
              blur_size = 6;
              blur_passes = 3;
              brightness = 0.6;
              vibrancy = 0.25;
            }
          ];

          input-field = [
            {
              monitor = "";
              fade_on_empty = true;
              rounding = 8;
              placeholder_text = "Password..";
              outer_color = "rgba(255, 255, 255, 0.0)";
              inner_color = "rgba(255, 255, 255, 0.1)";
              font_color = "rgba(255, 255, 255, 1.0)";
              outline_thickness = 0;
              swap_font_color = false;
              size = "450, 70";
              position = "0, -300";
            }
          ];

          label = [
            {
              monitor = "";
              text = "$TIME";
              color = "rgba(255, 255, 255, 1.0)";
              font_size = 92;
              position = "-60, 120";
              halign = "right";
              valign = "bottom";
            }
            {
              monitor = "";
              text = "cmd[update:60000] ${pkgs.hyprland}/bin/hyprctl splash";
              color = "rgba(255, 255, 255, 0.8)";
              font_size = 26;
              position = "-60, 40";
              halign = "right";
              valign = "bottom";
            }
          ];
        };
      };
    };
  };
}
