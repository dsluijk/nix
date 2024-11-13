{
  config,
  lib,
  inputs,
  system,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.hyprland;
in {
  config = mkIf cfg.enable {
    fonts.packages = with pkgs; [
      (nerdfonts.override {fonts = ["JetBrainsMono"];})
    ];

    services.upower.enable = true;
    services.gvfs.enable = true;

    home-manager.users.${config.modules.user.username} = {pkgs, ...}: {
      wayland.windowManager.hyprland.settings."exec-once" = [
        "${inputs.hyprpanel.packages.${system}.default}/bin/hyprpanel"
      ];

      home.file = {
        ".cache/ags/hyprpanel/options.json" = {
          executable = false;
          text = builtins.toJSON {
            wallpaper.enable = false;
            notifications.ignore = ["spotify"];

            menus = {
              bluetooth.showBattery = true;
              dashboard.powermenu.avatar = {
                name = config.modules.user.username;
                image = ../../../assets/profile.jpg;
              };
              clock = {
                time.military = true;
                weather.unit = "metric";
                weather.location = "Amsterdam";
              };
            };

            theme = {
              font.size = "0.8rem";

              bar = {
                transparent = true;
                buttons.monochrome = true;
                outer_spacing = "0.6em";

                buttons = {
                  enableBorders = false;
                  spacing = "0.0em";
                  radius = "0.0em";
                  workspaces.numbered_active_highlight_padding = "0.4em";
                };
              };
            };

            bar = {
              launcher.icon = "";
              network.showWifiInfo = true;
              battery.hideLabelWhenFull = true;
              clock.format = "%H:%M %d %b";

              media = {
                format = "{title}";
                show_active_only = true;
              };

              workspaces = {
                workspaces = 0;
                show_icons = false;
                show_numbered = true;
                numbered_active_indicator = "highlight";
              };

              layouts = {
                "0" = {
                  left = ["dashboard" "workspaces" "windowtitle"];
                  middle = [];
                  right = [
                    "media"
                    "volume"
                    # "network"
                    "bluetooth"
                    "battery"
                    "clock"
                    "systray"
                    "notifications"
                  ];
                };
                "1" = {
                  left = ["dashboard" "workspaces" "windowtitle"];
                  middle = [];
                  right = ["media" "volume" "clock" "notifications"];
                };
                "2" = {
                  left = ["dashboard" "workspaces" "windowtitle"];
                  middle = [];
                  right = ["media" "volume" "clock" "notifications"];
                };
              };
            };
          };
        };
      };
    };
  };
}
