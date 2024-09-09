{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.zitadel;
in {
  options.modules.services.zitadel = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.zitadel = {
      enable = true;
      masterKeyFile = config.age.secrets.zitadel.path;
      tlsMode = "external";
      settings = {
        Port = 8123;
        ExternalDomain = "login.dany.dev";
        ExternalPort = 443;
        Database.postgres = {
          Host = "localhost";
          Port = 5432;
          Database = "zitadel";
          User = {
            Username = "zitadel";
            Password = "zitadel";
            SSL.Mode = "disable";
          };
          Admin = {
            Username = "postgres";
            Password = "zitadel";
            SSL.Mode = "disable";
          };
        };
        DefaultInstance.SMTPConfiguration = {
          SMTP = {
            Host = "mail.dany.dev";
            User = "noreply@dany.dev";
            Password = builtins.readfile config.age.secrets.noreply.path;
          };
          TLS = true;
          From = "noreply@dany.dev";
          FromName = "Login - Dany";
        };
      };
      steps = {
        FirstInstance = {
          InstanceName = "Dany";
          Org.Human = {
            UserName = "dsluijk";
            FirstName = "Dany";
            LastName = "Sluijk";
            Email = {
              Address = "me@dany.dev";
              Verified = true;
            };
          };
        };
      };
    };

    modules = {
      secrets.required = ["zitadel"];

      services = {
        nginx = {
          enable = true;
          extraHosts = {
            "login.dany.dev" = {
              forceSSL = true;
              enableACME = true;
              locations."/" = {
                proxyPass = "http://localhost:8123/";
                extraConfig = ''
                  proxy_set_header  X-Script-Name /;
                  proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
                  proxy_pass_header Authorization;
                '';
              };
            };
          };
        };

        postgres = {
          enable = true;
          extraUsers = ["zitadel"];
          usersAllowedTCP = ["zitadel" "postgres"];
        };
      };
    };
  };
}
