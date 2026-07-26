{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.hardware.displaylink;
in {
  options.modules.hardware.displaylink = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      displaylink
    ];

    services.xserver.videoDrivers = ["displaylink" "modesetting"];
  };
}
