{
  lib,
  config,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.boot;
in {
  options.modules.boot = {};

  config = {
    boot = {
      plymouth.enable = true;
      initrd.verbose = false;

      kernelParams = [
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "loglevel=3"
        "rd.systemd.show_status=false"
        "rd.udev.log_level=3"
        "udev.log_priority=3"
      ];

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
