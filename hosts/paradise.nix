{
  self,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../hardware/um480xt.nix
  ];

  system.stateVersion = "24.05";

  modules = {
    hm.stateVersion = "24.05";

    disk = {
      device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_2TB_S4J4NM0W712895Y";
      swapSize = "32G";

      extraDisks = {
        "/data" = "/dev/disk/by-id/ata-Samsung_SSD_870_QVO_4TB_S5STNF0W910195X";
      };
    };

    wireless = {
      enable = true;
      extra = {};
    };

    theme.wallpaper = ../assets/wallpapers/national.jpg;

    services = {
      mail.enable = true;
      postgres.enable = true;
      radicale.enable = true;
      roundcube.enable = true;
      vaultwarden.enable = true;
      authentik.enable = true;
      outline.enable = true;
      headscale.enable = true;
      blocky.enable = true;
      immich.enable = true;
      nextcloud.enable = true;

      plex = {
        enable = true;
        dataDir = "/data/plex";
      };

      tailscale = {
        enable = true;
        routingFeatures = "server";
      };

      nginx = {
        enable = true;
        extraHosts = {
          "dany.dev" = {
            default = true;
            addSSL = true;
            enableACME = true;

            locations."/" = {
              return = "302 https://github.com/dsluijk";
            };
          };

          "atlasdev.nl" = {
            addSSL = true;
            enableACME = true;

            locations."/" = {
              return = "302 https://dany.dev";
            };
          };

          "books.dany.dev" = {
            addSSL = true;
            enableACME = true;

            locations."/" = {
              proxyPass = "http://10.42.0.27:8083";
              extraConfig = ''
                client_max_body_size "1G";
              '';
            };
          };

          "cloud.dany.dev" = {
            addSSL = true;
            enableACME = true;

            locations."/" = {
              proxyPass = "http://10.42.0.15:8080";
              extraConfig = ''
                client_max_body_size "10G";
              '';
            };
          };

          "image.dany.dev" = {
            addSSL = true;
            enableACME = true;

            locations."/" = {
              proxyPass = "http://10.42.0.13:2283";
              extraConfig = ''
                client_max_body_size "1G";
              '';
            };
          };

          "request.dany.dev" = {
            addSSL = true;
            enableACME = true;

            locations."/" = {
              proxyPass = "http://10.42.0.26:5000";
            };
          };

          "recipes.dany.dev" = {
            addSSL = true;
            enableACME = true;

            locations."/" = {
              proxyPass = "http://10.42.0.21:80";
              extraConfig = ''
                client_max_body_size "50M";
              '';
            };
          };

          "tautulli.dany.dev" = {
            addSSL = true;
            enableACME = true;

            locations."/" = {
              proxyPass = "http://10.42.0.24:8181";
            };
          };
        };
      };
    };
  };

  # TEMP: force a static, wireless IP. Should change this when we are wired.
  networking.interfaces.wlp2s0.ipv4.addresses = [
    {
      address = "10.42.0.69";
      prefixLength = 24;
    }
  ];
  networking.defaultGateway = "10.42.0.1";
  networking.nameservers = ["10.42.0.1" "1.1.1.1" "8.8.8.8"];
  networking.firewall.enable = true;
}
