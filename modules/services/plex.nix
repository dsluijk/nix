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
          http2 = true;

          locations."/" = {
            proxyPass = "http://localhost:32400/";
            proxyWebsockets = true;
            extraConfig = ''
              send_timeout 100m;

              ssl_stapling on;
              ssl_stapling_verify on;

              proxy_pass_header Authorization;
              proxy_buffering off;
              proxy_redirect off;
              proxy_set_header Host $host;
              proxy_set_header Referer $server_addr;
              proxy_set_header Origin $server_addr;
              proxy_set_header X-Script-Name /;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $http_x_forwarded_proto;

              gzip on;
              gzip_vary on;
              gzip_min_length 1000;
              gzip_proxied any;
              gzip_types text/plain text/css text/xml application/xml text/javascript application/x-javascript image/svg+xml;
              gzip_disable "MSIE [1-6]\.";

              client_max_body_size 100M;

              proxy_set_header X-Plex-Client-Identifier $http_x_plex_client_identifier;
              proxy_set_header X-Plex-Device $http_x_plex_device;
              proxy_set_header X-Plex-Device-Name $http_x_plex_device_name;
              proxy_set_header X-Plex-Platform $http_x_plex_platform;
              proxy_set_header X-Plex-Platform-Version $http_x_plex_platform_version;
              proxy_set_header X-Plex-Product $http_x_plex_product;
              proxy_set_header X-Plex-Token $http_x_plex_token;
              proxy_set_header X-Plex-Version $http_x_plex_version;
              proxy_set_header X-Plex-Nocache $http_x_plex_nocache;
              proxy_set_header X-Plex-Provides $http_x_plex_provides;
              proxy_set_header X-Plex-Device-Vendor $http_x_plex_device_vendor;
              proxy_set_header X-Plex-Model $http_x_plex_model;
            '';
          };
        };
      };
    };
  };
}
