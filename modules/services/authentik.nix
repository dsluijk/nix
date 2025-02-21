{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.authentik;
in {
  imports = [
    inputs.authentik-nix.nixosModules.default
  ];

  options.modules.services.authentik = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.authentik = {
      enable = true;
      environmentFile = config.age.secrets.authentik.path;
      createDatabase = false;

      settings = {
        disable_startup_analytics = true;
        avatars = "initials";

        postgresql = {
          user = "authentik";
          host = "localhost";
        };

        email = {
          host = "mail.dany.dev";
          port = 587;
          username = "noreply@dany.dev";
          use_tls = true;
          use_ssl = false;
          from = "noreply@dany.dev";
        };
      };

      nginx = {
        enable = true;
        enableACME = true;
        host = "login.dany.dev";
      };
    };

    modules = {
      secrets.required = ["authentik"];

      impermanence = {
        safe.folders = [
          "/var/lib/private/authentik/media"
        ];
      };

      services.postgres = {
        enable = true;
        extraUsers = ["authentik"];
        usersAllowedTCP = ["authentik"];
      };
    };
  };
}
