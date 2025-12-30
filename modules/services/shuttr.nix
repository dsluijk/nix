{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.shuttr;
in {
  imports = [
    inputs.shuttr.nixosModules.shuttr
  ];

  options.modules.services.shuttr = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.shuttr = {
      enable = true;
      secretsFile = config.age.secrets.shuttr.path;
      host = "localhost";
      port = 4562;
      title = "Gallery - Dany";
      header = "Gallery - Dany Sluijk";
      description = "Photo gallery of Dany Sluijk";
      links = [
        {
          icon = "i-lucide-house";
          to = "https://dany.dev";
        }
        {
          icon = "i-simple-icons-github";
          to = "https://github.com/dsluijk";
        }
      ];

      auth.authentik = {
        enable = true;
        displayName = "Authentik Dany";
        domain = "login.dany.dev";
        clientId = "WoqWyNBdsUDJSrpdZkETkImbRiRgDotopVOFMB86";
        adminGroups = ["admins"];
      };

      storage.file.enable = true;
    };

    modules = {
      secrets.required = ["shuttr"];
      services.postgres.enable = true;

      impermanence = {
        safe.folders = [
          config.services.shuttr.storage.file.path
        ];
      };

      services = {
        nginx = {
          enable = true;
          extraHosts = {
            "gallery.dany.dev" = {
              forceSSL = true;
              enableACME = true;

              locations."/" = {
                proxyPass = "http://localhost:${toString config.services.shuttr.port}/";
                recommendedProxySettings = true;
                extraConfig = ''
                  client_max_body_size 50000M;
                  proxy_read_timeout   600s;
                  proxy_send_timeout   600s;
                  send_timeout         600s;
                '';
              };
            };
          };
        };
      };
    };
  };
}
