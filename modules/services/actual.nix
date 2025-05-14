{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.actual;
in {
  options.modules.services.actual = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.actual = {
      enable = true;
      openFirewall = mkForce false;
      settings = {
        port = 8714;
        loginMethod = "openid";
        allowedLoginMethods = ["openid"];
        dataDir = "/var/lib/private/actual";
        openId = {
          discoveryURL = "https://login.dany.dev/application/o/actual/.well-known/openid-configuration";
          client_id = "xXtR8tAHJBLqkmZ0JTEl6w4n9M4F251GUHPhp55m";
          client_secret = "OPENID_CLIENT_SECRET";
          server_hostname = "https://budget.dany.dev";
          authMethod = "openid";
          enforce = true;
        };
      };
    };

    # Since the Actual people don't give us proper env variables for secrets,
    # we'll have to do it ourselves.
    # Taken from: https://github.com/diogotcorreia/dotfiles/blob/nixos/hosts/hera/immich.nix
    systemd.services.actual = let
      unpatchedConfigFile = "${config.systemd.services.actual.environment.ACTUAL_CONFIG_PATH}";
      patchedConfigFile = "/run/actual/config.json";
    in {
      environment = {
        ACTUAL_CONFIG_PATH = lib.mkForce patchedConfigFile;
      };
      preStart = ''
        install -m 600 /dev/null ${patchedConfigFile}
        ${lib.getExe pkgs.jq} -c \
          --arg oauthClientSecret "$ACTUAL_OAUTH_CLIENT_SECRET" \
          '.openId.client_secret += $oauthClientSecret' \
          ${unpatchedConfigFile} > ${patchedConfigFile}
      '';
    };

    services.nginx.virtualHosts."budget.dany.dev" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.actual.settings.port}";
        recommendedProxySettings = true;
      };
    };

    modules = {
      secrets.required = ["actual"];

      impermanence = {
        safe.folders = [
          "/var/lib/private/actual"
        ];
      };
    };
  };
}
