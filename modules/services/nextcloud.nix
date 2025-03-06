{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.nextcloud;
  ncpkg = pkgs.nextcloud31;
  pwdFile = pkgs.writeText "nextcloud-default-password" "TempPasswordReplace!";
in {
  options.modules.services.nextcloud = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.nextcloud = {
      enable = true;
      package = ncpkg;
      configureRedis = true;
      hostName = "files.dany.dev";
      https = true;
      database.createLocally = true;

      extraAppsEnable = true;
      extraApps = with ncpkg.packages.apps; {
        inherit user_oidc;
      };

      settings = {
        overwriteprotocol = "https";
        default_phone_region = "NL";
      };

      config = {
        adminuser = "root";
        adminpassFile = toString pwdFile;
        dbtype = "pgsql";
      };
    };

    modules = {
      impermanence = {
        safe.folders = [
          config.services.nextcloud.home
        ];
      };

      services = {
        postgres = {
          enable = true;
          extraUsers = ["nextcloud"];
        };
      };
    };
  };
}
