{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.outline;
in {
  options.modules.services.outline = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.outline = {
      enable = true;
      publicUrl = "https://write.dany.dev";
      forceHttps = false;
      storage.storageType = "local";
      databaseUrl = "postgres://outline:@localhost:5432/outline";

      oidcAuthentication = {
        authUrl = "https://login.dany.dev/application/o/authorize";
        tokenUrl = "https://login.dany.dev/application/o/token";
        userinfoUrl = "https://login.dany.dev/application/o/userinfo";
        clientId = "kgFF9SrUGqcG6BHb5XMJ4A7ithsw7INaDfy5QnPZ";
        clientSecretFile = config.age.secrets.outline-oidc.path;
        scopes = ["openid" "email" "profile"];
        usernameClaim = "preferred_username";
        displayName = "Login";
      };

      smtp = {
        host = "mail.dany.dev";
        username = "noreply@dany.dev";
        fromEmail = "noreply@dany.dev";
        passwordFile = config.age.secrets.outline-smtp.path;
      };
    };

    modules = {
      secrets.required = ["outline-oidc" "outline-smtp"];

      impermanence = {
        safe.folders = [
          "/var/lib/outline"
        ];
      };

      services.postgres = {
        enable = true;
        extraUsers = ["outline"];
        usersAllowedTCP = ["outline"];
      };
    };
  };
}
