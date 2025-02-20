{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.hyprland;
  colors = config.lib.stylix.colors;
  rgb = color: "${colors."${color}-rgb-r"}, ${colors."${color}-rgb-g"}, ${colors."${color}-rgb-b"}";
in {
  config = mkIf cfg.enable {
    home-manager.users.${config.modules.user.username} = {pkgs, ...}: {
      programs.hyprlock = {
        enable = true;

        settings = {
          general = {
            grace = 5;
            hide_cursor = true;
          };

          auth.fingerprint.enabled = true;

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
              rounding = 6;
              placeholder_text = "";
              outer_color = "rgba(${rgb "base02"}, 0.6)";
              inner_color = "rgba(${rgb "base00"}, 0.6)";
              font_color = "rgba(${rgb "base05"}, 1.0)";
              check_color = "rgba(${rgb "base01"}, 1.0)";
              fail_color = "rgba(${rgb "base08"}, 1.0)";
              outline_thickness = 2;
              size = "450, 70";
              position = "0, -400";
            }
          ];

          label = [
            {
              monitor = "";
              text = "$TIME";
              color = "rgba(${rgb "base05"}, 1.0)";
              font_size = 92;
              position = "-60, 120";
              halign = "right";
              valign = "bottom";
            }
            {
              monitor = "";
              text = "cmd[update:60000] ${pkgs.hyprland}/bin/hyprctl splash";
              color = "rgba(${rgb "base04"}, 0.6)";
              font_size = 26;
              position = "-60, 60";
              halign = "right";
              valign = "bottom";
            }
            {
              monitor = "";
              text = "$FPRINTMESSAGE";
              color = "rgba(${rgb "base04"}, 1.0)";
              font_size = 21;
              position = "0, -300";
              halign = "center";
              valign = "center";
            }
          ];

          image = [
            {
              monitor = "";
              path = toString ../../../assets/profile.jpg;
              size = 250;
              rounding = 32;
              border_size = 2;
              border_color = "rgba(${rgb "base02"}, 0.8)";
              position = "0, 0";
              halign = "center";
              valign = "center";
            }
          ];
        };
      };
    };

    modules.impermanence = {
      unsafe.folders = [
        "/var/lib/fprint"
      ];
    };
  };
}
