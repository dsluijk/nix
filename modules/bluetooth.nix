{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.bluetooth;
in {
  options.modules.bluetooth = {
    enable = mkBoolOpt false;
    onBoot = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = cfg.onBoot;
      settings.General.Experimental = true;
    };

    modules.impermanence = {
      safe.folders = [
        "/var/lib/bluetooth"
      ];
    };
  };
}
