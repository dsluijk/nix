{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.plex;
in {
  options.modules.services.plex = {
    enable = mkBoolOpt false;
    dataDir = mkStrOpt "/data/plex";
    openFirewall = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    services.plex = {
      enable = true;
      dataDir = cfg.dataDir;
      openFirewall = cfg.openFirewall;
    };

    modules.services.nginx = {
      enable = true;
      extraHosts = {
        "watch.dany.dev" = {
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://localhost:32400/";
            proxyWebsockets = true;
            extraConfig = ''
              proxy_set_header Host $host;
              proxy_set_header X-Script-Name /;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_pass_header Authorization;
              proxy_buffering off;
              proxy_redirect off;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $http_x_forwarded_proto;
            '';
          };
        };
      };
    };
  };
}
