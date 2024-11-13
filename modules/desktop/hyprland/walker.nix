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

      home.packages = [pkgs.libqalculate pkgs.papirus-icon-theme];

      wayland.windowManager.hyprland.settings.exec-once = [
        "${pkgs.walker}/bin/walker --gapplication-service"
      ];

      programs.walker = {
        enable = true;
        runAsService = false;
        config = {
          terminal = "kitty";
          ignore_mouse = true;
          disabled = [
            "runner"
            "ssh"
            "windows"
            "clipboard"
            "commands"
            "switcher"
            "custom_commands"
            "emojis"
            "dmenu"
            "finder"
          ];

          builtins = {
            applications.actions = false;
            applications.context_aware = false;
            applications.show_generic = false;
            websearch.engines = ["duckduckgo"];
            calc = {
              min_chars = 2;
              weight = 1;
              recalculate_score = false;
            };
          };

          plugins = [
            {
              name = "power";
              placeholder = "Power";
              switcher_only = false;
              recalculate_score = false;
              show_icon_when_single = true;
              weight = 4;
              entries = [
                {
                  label = "Shutdown";
                  icon = "system-shutdown";
                  exec = "shutdown now";
                }
                {
                  label = "Reboot";
                  icon = "system-reboot";
                  exec = "reboot";
                }
                {
                  label = "Lock Screen";
                  icon = "system-lock-screen";
                  exec = "hyprlock";
                }
              ];
            }
          ];
        };
      };
    };
  };
}
