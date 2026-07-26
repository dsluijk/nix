{
  inputs,
  config,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.niri;
in {
  config = mkIf cfg.enable {
    home-manager.users.${config.modules.user.username} = {pkgs, ...}: {
      imports = [
        inputs.noctalia.homeModules.default
      ];

      programs.noctalia = {
        enable = true;

        settings = {
          battery.warning_threshold = 30;
          backdrop.blur_intensity = 0.56;
          location.address = "Delft, The Netherlands";
          nightlight.enabled = true;

          theme = {
            mode = config.modules.theme.polarity;
            source = "wallpaper";
            wallpaper_scheme = "m3-rainbow";
          };

          osd = {
            offset_y = 16;
            orientation = "vertical";
            position = "bottom_right";
          };

          wallpaper = {
            enabled = true;
            directory = config.modules.theme.wallpaperFolder;
            default.path = config.modules.theme.wallpaper;
          };

          lockscreen = {
            blurred_desktop = true;
            tint_intensity = 0.4;
          };

          idle = {
            behavior_order = [
              "lock"
              "screen-off"
              "lock-and-suspend"
            ];
            behavior = {
              lock = {
                action = "lock";
                enabled = true;
                timeout = 180;
              };
              lock-and-suspend = {
                action = "lock_and_suspend";
                enabled = true;
                timeout = 600;
              };
              screen-off = {
                action = "screen_off";
                enabled = true;
                timeout = 240;
              };
            };
          };

          shell = {
            app_icon_color = "primary";
            avatar_path = config.modules.theme.profile;
            offline_mode = true;
            password_style = "random";
            polkit_agent = true;
            settings_show_advanced = true;
            animation.speed = 0.6;
            screen_corners.enabled = true;

            panel = {
              clipboard_placement = "attached";
              launcher_categories = false;
              open_near_click_clipboard = true;
              open_near_click_control_center = true;
              open_near_click_session = true;
            };

            session.actions = [
              {
                action = "lock";
                enabled = false;
                shortcut = "1";
                variant = "default";
              }
              {
                action = "logout";
                enabled = true;
                shortcut = "2";
                variant = "default";
              }
              {
                action = "lock_and_suspend";
                enabled = true;
                shortcut = "3";
                variant = "default";
              }
              {
                action = "reboot";
                enabled = true;
                shortcut = "4";
                variant = "default";
              }
              {
                action = "shutdown";
                enabled = true;
                shortcut = "5";
                variant = "destructive";
              }
            ];
          };

          bar.default = {
            background_opacity = 0.5;
            center = ["media" "clock"];
            end = ["network" "tray" "clipboard" "bluetooth" "volume" "brightness" "battery" "notifications" "session"];
            margin_edge = 0;
            margin_ends = 0;
            radius = 0;
            padding = 16;
            scale = 1.1;
            start = ["control-center" "launcher" "workspaces" "active_window"];
          };

          widget = {
            control-center = {
              custom_image = "${pkgs.nixos-icons}/share/icons/hicolor/256x256/apps/nix-snowflake-white.png";
            };
            battery = {
              show_label = false;
            };
            brightness = {
              show_label = false;
            };
            clock = {
              capsule = true;
              capsule_fill = "on_primary";
              capsule_foreground = "primary";
              capsule_opacity = 0.7;
              capsule_padding = 23;
              format = "{:%H:%M:%S}";
            };
            media = {
              capsule = true;
              capsule_fill = "on_primary";
              capsule_foreground = "primary";
              capsule_opacity = 0.7;
              capsule_padding = 20;
              color = "primary";
              hide_when_no_media = true;
              title_scroll = "on_hover";
            };
            volume = {
              show_label = false;
            };
            workspaces = {
              hide_when_empty = true;
            };
          };

          control_center.shortcuts = [
            {
              type = "wifi";
            }
            {
              type = "bluetooth";
            }
            {
              type = "caffeine";
            }
            {
              type = "nightlight";
            }
            {
              type = "notification";
            }
            {
              type = "clipboard";
            }
          ];

          desktop_widgets = {
            schema_version = 2;
            widget_order = [];

            grid = {
              cell_size = 16;
              major_interval = 4;
              visible = true;
            };

            widget = {};
          };

          lockscreen_widgets = {
            enabled = true;
            schema_version = 2;
            widget_order = [
              "lockscreen-login-box@eDP-1"
              "lockscreen-widget-0000000000000001"
              "lockscreen-widget-0000000000000002"
            ];
            grid = {
              cell_size = 16;
              major_interval = 4;
              visible = true;
            };
            widget = {
              "lockscreen-login-box@eDP-1" = {
                box_height = 0;
                box_width = 0;
                cx = 853.5;
                cy = 956.5;
                output = "eDP-1";
                rotation = 0;
                type = "login_box";
                settings = {
                  background_color = "surface_variant";
                  background_opacity = 0.88;
                  background_radius = 12;
                  input_opacity = 1;
                  input_radius = 6;
                  show_login_button = true;
                };
              };
              lockscreen-widget-0000000000000001 = {
                box_height = 160;
                box_width = 512;
                cx = 853.5;
                cy = 245.5;
                output = "eDP-1";
                rotation = 0;
                type = "clock";
                settings = {
                  background_opacity = 0.22;
                  background_radius = 13;
                };
              };
              lockscreen-widget-0000000000000002 = {
                box_height = 144;
                box_width = 336;
                cx = 853.5;
                cy = 813.5;
                output = "eDP-1";
                rotation = 0;
                type = "sysmon";
                settings = {
                  stat2 = "cpu_temp";
                };
              };
            };
          };
        };
      };
    };

    modules = {
      impermanence = {
        unsafe.userFolders = [
          ".local/state/noctalia"
        ];
      };
    };
  };
}
