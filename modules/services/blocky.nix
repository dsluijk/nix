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
    prometheus = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.blocky = {
      enable = true;

      settings = {
        prometheus.enable = cfg.prometheus.enable;

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
  };
}