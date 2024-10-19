{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.headscale;
in {
  options.modules.services.headscale = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.headscale = {
      enable = true;
      port = 8079;
      address = "127.0.0.1";

      settings = {
        server_url = "https://connect.dany.dev:443";

        db_type = "postgres";
        db_host = "/var/run/postgresql";
        db_name = "headscale";
        db_user = "headscale";

        oidc = {
          issuer = "https://login.dany.dev/application/o/headscale/";
          client_id = "pO0k3omaCGjksh5gklKzcUmdZIbkkvmSIceOL2yl";
          client_secret_path = config.age.secrets.headscale-oidc.path;

          authUrl = "https://login.dany.dev/application/o/authorize/";
          tokenUrl = "https://login.dany.dev/application/o/token/";
          userinfoUrl = "https://login.dany.dev/application/o/userinfo/";
        };
      };
    };

    modules = {
      secrets.required = ["headscale-oidc"];

      impermanence = {
        safe.folders = [
          "/var/lib/headscale"
        ];
      };

      services = {
        postgres = {
          enable = true;
          extraUsers = ["headscale"];
        };

        nginx = {
          enable = true;
          extraHosts = {
            "connect.dany.dev" = {
              forceSSL = true;
              enableACME = true;
              locations."/" = {
                proxyPass = "http://localhost:${toString config.services.headscale.port}/";
                proxyWebsockets = true;
                extraConfig = ''
                  proxy_set_header  X-Script-Name /;
                  proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
                  proxy_pass_header Authorization;
                  proxy_buffering off;
                  proxy_set_header X-Real-IP $remote_addr;
                  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                  proxy_set_header X-Forwarded-Proto $http_x_forwarded_proto;
                '';
              };
            };
          };
        };
      };
    };
  };
}
