{
  config,
  lib,
  vscode-extensions,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.hardware.logitech;
in {
  options.modules.hardware.logitech = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    hardware.logitech.wireless.enable = true;

    services.logiops = {
      enable = true;
      config = {
        devices = [
          {
            name = "MX Anywhere 3s";
            dpi = 1600;

            smartshift = {
              on = true;
              threshold = 20;
              default_threshold = 20;
            };

            hiresscroll = {
              hires = true;
              invert = false;
              target = true;

              # up = {
              #   mode = "Axis";
              #   axis = "REL_WHEEL_HI_RES";
              #   axis_multiplier = 8;
              # };

              # down = {
              #   mode = "Axis";
              #   axis = "REL_WHEEL_HI_RES";
              #   axis_multiplier = -8;
              # };
            };

            buttons = [
              {
                cid = (fromTOML "hex = 0x52").hex; # Mode Shift Button
                action = {
                  type = "Gestures";
                  gestures = [
                    {
                      direction = "Down";
                      mode = "OnRelease";
                      action = {
                        type = "Keypress";
                        keys = ["KEY_LEFTMETA" "KEY_J"];
                      };
                    }
                  ];
                };
              }
              # {
              #   cid = (fromTOML "hex = 0x52").hex; # Magspeed Wheel
              #   action = {
              #     type = "Keypress";
              #     keys = ["KEY_DICTATE"];
              #   };
              # }
              # {
              #   cid = (fromTOML "hex = 0xc4").hex; # Mode Shift Button
              #   action = {
              #     type = "Keypress";
              #     keys = ["KEY_DICTATE"];
              #   };
              # }
              {
                cid = (fromTOML "hex = 0x53").hex; # Back (thumb button)
                action = {
                  type = "Keypress";
                  keys = ["KEY_PREVIOUSSONG"];
                };
              }
              {
                cid = (fromTOML "hex = 0x56").hex; # Forward (thumb btn)
                action = {
                  type = "Keypress";
                  keys = ["KEY_NEXTSONG"];
                };
              }
            ];
          }
        ];
      };
    };
  };
}
