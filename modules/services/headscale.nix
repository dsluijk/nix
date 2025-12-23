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
        server_url = "https://connect.dany.dev";

        dns = {
          base_domain = "tailnet.dany.dev";
          search_domains = ["dany.home"];
          nameservers.global = ["1.1.1.1" "10.42.0.2"];
        };

        database = {
          type = "postgres";

          postgres = {
            host = "/var/run/postgresql";
            name = "headscale";
            user = "headscale";
          };
        };

        oidc = {
          issuer = "https://login.dany.dev/application/o/headscale/";
          client_id = "pO0k3omaCGjksh5gklKzcUmdZIbkkvmSIceOL2yl";
          client_secret_path = config.age.secrets.headscale-oidc.path;
          scope = [
            "openid"
            "profile"
            "email"
            "offline_access"
          ];
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
                recommendedProxySettings = true;
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
