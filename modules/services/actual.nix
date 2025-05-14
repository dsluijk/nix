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
        dataDir = "/var/lib/private/actual";
      };
    };

    systemd.services.actual.serviceConfig.EnvironmentFile = config.age.secrets.actual.path;
    systemd.services.actual.environment = {
      ACTUAL_OPENID_DISCOVERY_URL = "https://login.dany.dev/application/o/actual/.well-known/openid-configuration";
      ACTUAL_OPENID_CLIENT_ID = "xXtR8tAHJBLqkmZ0JTEl6w4n9M4F251GUHPhp55m";
      ACTUAL_OPENID_SERVER_HOSTNAME = "https://budget.dany.dev";
      ACTUAL_OPENID_ENFORCE = "true";
      ACTUAL_LOGIN_METHOD = "openid";
      ACTUAL_ALLOWED_LOGIN_METHODS = "openid";
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
