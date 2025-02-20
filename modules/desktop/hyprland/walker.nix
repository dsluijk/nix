{
  config,
  lib,
  inputs,
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
            applications.actions.enabled = false;
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

        theme = {
          layout = {
            ui = {
              anchors = {
                bottom = true;
                left = true;
                right = true;
                top = true;
              };

              window = {
                h_align = "fill";
                v_align = "fill";

                box = {
                  orientation = "vertical";
                  h_align = "center";
                  v_align = "start";
                  spacing = 10;
                  width = 600;

                  margins = {
                    bottom = 200;
                    top = 150;
                  };

                  search = {
                    v_align = "start";
                    spacing = 10;
                    width = 600;
                  };

                  scroll = {
                    list = {
                      always_show = true;
                      max_height = 600;
                      max_width = 600;
                      min_width = 600;
                      width = 600;

                      item = {
                        spacing = 5;

                        activation_label = {
                          width = 20;
                          x_align = 1;
                        };

                        icon = {
                          theme = "Papirus";
                        };

                        text = {
                          revert = true;
                        };
                      };
                    };
                  };
                };
              };
            };
          };

          style = ''
            #window {
              background: none;
            }

            #box {
              background: rgba(${rgb "base00"}, 1.0);
              padding: 16px;
              padding-top: 0px;
              border-radius: 8px;
              box-shadow:
                0 19px 38px rgba(0, 0, 0, 0.3),
                0 15px 12px rgba(0, 0, 0, 0.22);
            }

            #password,
            #input,
            #typeahead {
              background: rgba(${rgb "base01"}, 0.8);
              box-shadow: none;
              color: rgba(${rgb "base05"}, 1.0);
              padding-left: 12px;
              padding-right: 12px;
            }
          '';
        };
      };
    };
  };
}
