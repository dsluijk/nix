{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.immich;
in {
  options.modules.services.immich = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.immich = {
      enable = true;
      port = 2283;
      secretsFile = config.age.secrets.immich.path;
      accelerationDevices = null;

      settings = {
        passwordLogin.enabled = false;
        server.externalDomain = "https://photo.dany.dev";

        oauth = {
          enabled = true;
          autoLaunch = true;
          issuerUrl = "https://login.dany.dev/application/o/immich/.well-known/openid-configuration";
          clientId = "jbZqJR8NK4lzNeIJHUnxNz5KifDGHMBVQYqnqwPj";
          # Client secret is provided another way, see below.
        };
      };
    };

    users.users.immich.extraGroups = ["video" "render"];

    # Since the Immich people don't give us proper env variables for secrets,
    # we'll have to do it ourselves.
    # https://github.com/immich-app/immich/discussions/14815
    # Taken from: https://github.com/diogotcorreia/dotfiles/blob/nixos/hosts/hera/immich.nix
    systemd.services.immich-server = let
      unpatchedConfigFile = config.services.immich.environment.IMMICH_CONFIG_FILE;
      patchedConfigFile = "/run/immich/config.json";
    in {
      environment = {
        IMMICH_CONFIG_FILE = lib.mkForce patchedConfigFile;
      };
      preStart = ''
        install -m 600 /dev/null ${patchedConfigFile}
        ${lib.getExe pkgs.jq} -c \
          --arg oauthClientSecret "$IMMICH_OAUTH_CLIENT_SECRET" \
          '.oauth.clientSecret += $oauthClientSecret' \
          ${unpatchedConfigFile} > ${patchedConfigFile}
      '';
    };

    modules = {
      secrets.required = ["immich"];

      impermanence = {
        safe.folders = [
          config.services.immich.mediaLocation
        ];
      };

      services = {
        nginx = {
          enable = true;
          extraHosts = {
            "photo.dany.dev" = {
              forceSSL = true;
              enableACME = true;

              locations."/" = {
                proxyPass = "http://localhost:${toString config.services.immich.port}/";
                proxyWebsockets = true;
                recommendedProxySettings = true;
                extraConfig = ''
                  client_max_body_size 50000M;
                  proxy_read_timeout   600s;
                  proxy_send_timeout   600s;
                  send_timeout         600s;
                '';
              };
            };
          };
        };
      };
    };
  };
}
