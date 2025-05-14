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
        enforceOpenId = true;
        openId = {
          issuer = "https://login.dany.dev/application/o/actual/.well-known/openid-configuration";
          client_id = "xXtR8tAHJBLqkmZ0JTEl6w4n9M4F251GUHPhp55m";
          client_secret = "OPENID_CLIENT_SECRET";
          server_hostname = "https://budget.dany.dev";
          authMethod = "openid";
        };
      };
    };

    systemd.services.actual.serviceConfig.EnvironmentFile = config.age.secrets.actual.path;

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
