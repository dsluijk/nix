{
  self,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../hardware/proxmox.nix
  ];

  system.stateVersion = "24.05";

  networking = {
    interfaces.ens18 = {
      ipv4.addresses = [
        {
          address = "10.42.0.2";
          prefixLength = 32;
        }
      ];
    };
    defaultGateway = {
      address = "10.42.0.1";
      interface = "ens18";
    };
    nameservers = ["10.42.0.1" "1.1.1.1" "8.8.8.8"];
    firewall.enable = true;
  };

  modules = {
    hm.stateVersion = "24.05";

    disk = {
      device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0";
      swapSize = "8G";

      # extraDisks = {
      #   "/data" = "/dev/disk/by-id/ata-Samsung_SSD_870_QVO_4TB_S5STNF0W910195X";
      # };
    };

    theme.wallpaper = ../assets/wallpapers/national.jpg;

    services = {
      mail.enable = true;
      postgres.enable = true;
      radicale.enable = true;
      roundcube.enable = true;
      vaultwarden.enable = true;
      authentik.enable = true;
      outline.enable = false;
      headscale.enable = false;
      blocky.enable = false;
      immich.enable = true;
      nextcloud.enable = true;
      mealie.enable = true;
      actual.enable = false;
      shuttr.enable = true;

      nietflix = {
        enable = false;
        dataDir = "/data/nietflix";
      };

      tailscale = {
        enable = false;
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
        };
      };
    };
  };
}
