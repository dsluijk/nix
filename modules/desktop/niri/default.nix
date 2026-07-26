{
  config,
  lib,
  inputs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.niri;
in {
  options.modules.desktop.niri = {
    enable = mkBoolOpt false;
    autostart = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    modules = {
      programs = {
        kitty.enable = true;
        nautilus.enable = true;
      };
    };

    programs.niri = {
      enable = true;
      useNautilus = true;
    };

    home-manager.users.${config.modules.user.username} = {pkgs, ...}: {
      home.file.".config/niri/config.kdl" = {
        executable = false;
        text = ''
          spawn-at-startup "noctalia"

          output "eDP-1" {
            mode "2560x1600@165.000"
            variable-refresh-rate
          }

          binds {
            // Core Noctalia binds
            Mod+Space { spawn-sh "noctalia msg panel-toggle launcher"; }
            Mod+Return { spawn "kitty"; }
            Mod+F { maximize-window-to-edges; }
            Mod+Escape { spawn-sh "noctalia msg session lock"; }
            Mod+W { close-window; }

            // Moving stuff
            Mod+H { focus-column-left; }
            Mod+J { focus-workspace-down; }
            Mod+K { focus-workspace-up; }
            Mod+L { focus-column-right; }
            Mod+Shift+H { move-column-left-or-to-monitor-left; }
            Mod+Shift+J { move-window-down-or-to-workspace-down; }
            Mod+Shift+K { move-window-up-or-to-workspace-up; }
            Mod+Shift+L { move-column-right-or-to-monitor-right; }

            // Printscreen
            Print { screenshot show-pointer=false; }
            Shift+Print { screenshot-screen show-pointer=false; }

            // Audio & Brightness
            XF86AudioRaiseVolume { spawn "noctalia" "msg" "volume-up"; }
            XF86AudioLowerVolume { spawn "noctalia" "msg" "volume-down"; }
            XF86AudioMute { spawn "noctalia" "msg" "volume-mute"; }
            XF86MonBrightnessUp { spawn "noctalia" "msg" "brightness-up"; }
            XF86MonBrightnessDown { spawn "noctalia" "msg" "brightness-down"; }
            XF86AudioNext { spawn "noctalia" "msg" "media" "next"; }
            XF86AudioPrev { spawn "noctalia" "msg" "media" "previous"; }
          }

          environment {
            QT_QPA_PLATFORM "wayland"
            NIXOS_OZONE_WL "1"
            DISPLAY null
          }

          hotkey-overlay {
            skip-at-startup
          }

          input {
            warp-mouse-to-focus
            focus-follows-mouse
          }

          window-rule {
            // Rounded corners for a modern look.
            geometry-corner-radius 20

            // Clips window contents to the rounded corner boundaries.
            clip-to-geometry true

            background-effect {
              blur true
              xray false
            }
          }

          window-rule {
            match app-id="dev.noctalia.Noctalia.Settings"
            open-floating true
            default-column-width { fixed 1080; }
            default-window-height { fixed 920; }
          }

          layer-rule {
            match namespace="^noctalia-(background|launcher-overlay|dock)-.*$"
            background-effect {
              xray false
            }
          }

          debug {
            // Allows notification actions and window activation from Noctalia.
            honor-xdg-activation-with-invalid-serial
          }
        '';
      };
    };
  };
}
