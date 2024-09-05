{
  lib,
  inputs,
  config,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.impermanence;
in {
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  options.modules.impermanence = {
    safe = {
      files = mkOpt (types.listOf types.str) [];
      folders = mkOpt (types.listOf types.str) [];
      userFiles = mkOpt (types.listOf types.str) [];
      userFolders = mkOpt (types.listOf types.str) [];
    };
    unsafe = {
      files = mkOpt (types.listOf types.str) [];
      folders = mkOpt (types.listOf types.str) [];
      userFiles = mkOpt (types.listOf types.str) [];
      userFolders = mkOpt (types.listOf types.str) [];
    };
  };

  config = {
    environment.persistence."/persist" = {
      hideMounts = true;
      files =
        [
          "/etc/ssh/ssh_host_ed25519_key"
          "/etc/ssh/ssh_host_ed25519_key.pub"
          "/etc/ssh/ssh_host_rsa_key"
          "/etc/ssh/ssh_host_rsa_key.pub"
        ]
        ++ cfg.safe.files;
      directories =
        [
          "/etc/nixos"
        ]
        ++ cfg.safe.folders;

      users.${config.modules.user.username} = {
        files = [] ++ cfg.safe.userFiles;
        directories = ["proj"] ++ cfg.safe.userFolders;
      };
    };

    environment.persistence."/persist-unsafe" = {
      hideMounts = true;
      files =
        [
          "/etc/machine-id"
        ]
        ++ cfg.unsafe.files;
      directories =
        [
          "/var/log"
          "/var/lib/nixos"
          "/var/lib/systemd/timers"
        ]
        ++ cfg.unsafe.folders;

      users.${config.modules.user.username} = {
        files = [] ++ cfg.unsafe.userFiles;
        directories = [] ++ cfg.unsafe.userFolders;
      };
    };
  };
}
