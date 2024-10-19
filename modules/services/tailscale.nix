{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.tailscale;
in {
  options.modules.services.tailscale = {
    enable = mkBoolOpt false;
    routingFeatures = mkStrOpt "client";
  };

  config = mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      useRoutingFeatures = cfg.routingFeatures;

      extraSetFlags = [
        "--webclient"
      ];
    };

    modules.impermanence = {
      unsafe.folders = [
        "/var/lib/tailscale"
      ];
    };
  };
}
