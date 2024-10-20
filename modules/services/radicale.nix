{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.radicale;
  # TODO: This should be replaced with SSO.
  htpasswd = pkgs.writeText "radicale.users" (
    concatStrings
    (flip mapAttrsToList config.mailserver.loginAccounts (
      mail: user:
        mail + ":" + user.hashedPassword + "\n"
    ))
  );
in {
  options.modules.services.radicale = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services = {
      radicale = {
        enable = true;
        settings = {
          auth = {
            type = "htpasswd";
            htpasswd_filename = htpasswd;
            htpasswd_encryption = "bcrypt";
          };
        };
      };

      nginx = {
        enable = true;
        virtualHosts = {
          "cal.dany.dev" = {
            forceSSL = true;
            enableACME = true;
            locations."/" = {
              proxyPass = "http://localhost:5232/";
              extraConfig = ''
                proxy_set_header  X-Script-Name /;
                proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_pass_header Authorization;
              '';
            };
          };
        };
      };
    };

    modules.impermanence = {
      safe.folders = [
        "/var/lib/radicale/collections"
      ];
    };
  };
}
