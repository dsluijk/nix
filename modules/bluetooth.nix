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
    mpris = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = cfg.onBoot;
      settings.General.Experimental = true;
    };

    home-manager.users.${config.modules.user.username} = {pkgs, ...}: {
      services.mpris-proxy.enable = cfg.mpris;
    };

    modules.impermanence = {
      safe.folders = [
        "/var/lib/bluetooth"
      ];
    };
  };
}
