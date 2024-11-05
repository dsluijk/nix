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

    home-manager.users.${config.modules.user.username} = {pkgs, ...}: {
      wayland.windowManager.hyprland.settings."exec-once" = [
        "${inputs.hyprpanel.packages.${system}.default}/bin/hyprpanel"
      ];

      home.file = {
        ".cache/ags/hyprpanel/options.json" = {
          executable = false;
          text = builtins.toJSON {
            "theme.font.size" = "0.8rem";
            "menus.bluetooth.showBattery" = true;
            "menus.clock.time.military" = true;
            "menus.clock.weather.location" = "Amsterdam";
            "menus.clock.weather.unit" = "metric";
            "bar.launcher.icon" = "";
            "bar.workspaces.show_numbered" = true;
            "bar.network.showWifiInfo" = true;
            "wallpaper.enable" = false;
            "menus.dashboard.powermenu.avatar.image" = ../../../assets/profile.jpg;
          };
        };
      };
    };
  };
}
