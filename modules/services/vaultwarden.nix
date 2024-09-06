{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.vaultwarden;
in {
  options.modules.services.vaultwarden = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.vaultwarden = {
      enable = true;
      dbBackend = "postgresql";
      config = {
        DOMAIN = "https://vault.dany.dev";
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8222;
        ROCKET_LOG = "critical";
        DATABASE_URL = "postgresql://vaultwarden@/vaultwarden?host=/var/run/postgresql";
        SIGNUPS_ALLOWED = false;
        ROCKET_WORKERS = 2;
      };
    };

    services.nginx.virtualHosts."vault.dany.dev" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8222";
      };
    };

    modules.services.postgres = {
      extraUsers = ["vaultwarden"];
    };
  };
}
