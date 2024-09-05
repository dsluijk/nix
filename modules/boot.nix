{ lib, config, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.boot;
in
{
  options.modules.boot = { };

  config = {
    boot = {
      kernelParams = [ "quiet" "loglevel=3" ];
      initrd = {
        systemd.enable = true;
      };

      loader = {
        timeout = 0;
        efi.canTouchEfiVariables = true;

        systemd-boot = {
          enable = true;
          consoleMode = "2";
          editor = false;
          configurationLimit = 15;
        };
      };
    };
  };
}
