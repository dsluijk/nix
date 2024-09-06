{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.postgres;
in {
  options.modules.services.postgres = {
    enable = mkBoolOpt false;
    extraUsers = mkOpt (types.listOf types.str) [];
  };

  config = mkIf cfg.enable {
    services = {
      postgresql = {
        enable = true;
        package = lib.mkForce pkgs.postgresql_16;
        ensureDatabases = [] ++ cfg.extraUsers;
        ensureUsers =
          []
          ++ (map (u: {
              name = u;
              ensureDBOwnership = true;
            })
            cfg.extraUsers);

        identMap = ''
          # ArbitraryMapName systemUser DBUser
          superuser_map      root      postgres
          superuser_map      ${config.modules.user.username}   postgres
          superuser_map      postgres  postgres
          # Let other names login as themselves
          superuser_map      /^(.*)$   \1
        '';

        authentication = pkgs.lib.mkOverride 10 ''
          #type database  DBuser   auth-method optional_ident_map
          local sameuser  all      peer        map=superuser_map
          local all       postgres peer        map=superuser_map
        '';
      };

      postgresqlBackup = {
        enable = true;
        location = "/backup/postgres";
        startAt = "*-*-* 02:15:00";
      };
    };

    modules.impermanence = {
      safe.folders = [
        "/var/lib/postgresql"
      ];
    };
  };
}
