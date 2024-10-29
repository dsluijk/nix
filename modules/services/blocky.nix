{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.blocky;
in {
  options.modules.services.blocky = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.blocky = {
      enable = true;

      settings = {
        ports.dns = "0.0.0.0:53,[::]:53";

        upstreams = {
          init.strategy = "fast";
          groups.default = [
            "1.1.1.1"
            "1.0.0.1"
            "8.8.8.8"
            "8.8.4.4"
          ];
        };

        blocking = {
          blockTTL = "1h";
          denylists = {
            ads = [
              # Adware list
              "https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt"
              # Tracking list
              "https://s3.amazonaws.com/lists.disconnect.me/simple_tracking.txt"
              # Combined Adware + Malware list
              "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
            ];
          };
        };
      };
    };

    networking.firewall = {
      allowedTCPPorts = [53];
      allowedUDPPorts = [53];
    };
  };
}
