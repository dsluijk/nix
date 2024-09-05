{
  lib,
  inputs,
  config,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.disk;
in {
  imports = [
    inputs.disko.nixosModules.disko
  ];

  options.modules.disk = {
    device = mkStrOpt null;
    swapSize = mkStrOpt null;
  };

  config = {
    disko.devices = {
      disk.main = {
        type = "disk";
        device = cfg.device;
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              name = "ESP";
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            swap = {
              name = "SWAP";
              size = cfg.swapSize;
              content = {
                type = "swap";
                resumeDevice = true;
              };
            };
            root = {
              name = "root";
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = ["-f"];
                subvolumes = {
                  "root" = {
                    mountpoint = "/";
                    mountOptions = ["noatime"];
                  };
                  "persist" = {
                    mountpoint = "/persist";
                  };
                  "persist-unsafe" = {
                    mountpoint = "/persist-unsafe";
                  };
                  "nix" = {
                    mountpoint = "/nix";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                };
              };
            };
          };
        };
      };
    };

    fileSystems."/".neededForBoot = true;
    fileSystems."/persist".neededForBoot = true;
    fileSystems."/persist-unsafe".neededForBoot = true;

    services.btrfs.autoScrub = {
      enable = true;
      interval = "weekly";
    };

    boot.initrd = {
      supportedFilesystems = ["btrfs"];

      systemd = {
        enable = true;

        services.rollback = {
          description = "Rollback BTRFS root subvolume to a pristine state";
          wantedBy = [
            "initrd.target"
          ];
          before = [
            "sysroot.mount"
          ];
          after = [
            "initrd-root-device.target"
          ];
          unitConfig.DefaultDependencies = "no";
          serviceConfig.Type = "oneshot";
          script = ''
            mkdir /btrfs_tmp
            mount /dev/disk/by-partlabel/disk-main-root /btrfs_tmp -t btrfs
            if [[ -e /btrfs_tmp/root ]]; then
              mkdir -p /btrfs_tmp/old_roots
              timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
              mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
            fi

            delete_subvolume_recursively() {
              IFS=$'\n'
              for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
                delete_subvolume_recursively "/btrfs_tmp/$i"
              done
              btrfs subvolume delete "$1"
            }

            for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
              delete_subvolume_recursively "$i"
            done

            btrfs subvolume create /btrfs_tmp/root
            umount /btrfs_tmp
          '';
        };
      };
    };
  };
}
