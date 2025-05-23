{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.mealie;
  domain = "food.dany.dev";
in {
  options.modules.services.mealie = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.mealie = {
      enable = true;
      port = 8512;
      listenAddress = "localhost";
      credentialsFile = config.age.secrets.mealie.path;

      settings = {
        BASE_URL = "https://${domain}";
        ALLOW_SIGNUP = "False";
        DB_ENGINE = "postgres";
        POSTGRES_URL_OVERRIDE = "postgresql://mealie:@/mealie?host=/run/postgresql";

        OIDC_AUTH_ENABLED = "True";
        OIDC_AUTO_REDIRECT = "True";
        OIDC_PROVIDER_NAME = "Authentik";
        OIDC_ADMIN_GROUP = "admins";
        OIDC_CONFIGURATION_URL = "https://login.dany.dev/application/o/mealie/.well-known/openid-configuration";
      };
    };

    systemd.services.mealie.environment.DATA_DIR = mkForce "/var/lib/private/mealie";

    modules = {
      secrets.required = ["mealie"];

      impermanence = {
        safe.folders = [
          "/var/lib/private/mealie"
        ];
      };

      services = {
        postgres = {
          enable = true;
          extraUsers = ["mealie"];
          usersAllowedTCP = ["mealie"];
        };

        nginx = {
          enable = true;
          extraHosts = {
            "${domain}" = {
              forceSSL = true;
              enableACME = true;
              locations."/" = {
                proxyPass = "http://localhost:${toString config.services.mealie.port}/";
                proxyWebsockets = true;
                recommendedProxySettings = true;
                extraConfig = ''
                  proxy_set_header  X-Script-Name /;
                  proxy_set_header  X-Real-IP $remote_addr;
                  proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
                  proxy_pass_header Authorization;
                '';
              };
            };
          };
        };
      };
    };
  };
}
