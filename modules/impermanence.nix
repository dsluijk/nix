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
  directoryEntry = types.submodule {
    options = {
      directory = mkStrOpt null;
      mode = mkOpt (types.nullOr types.str) null;
      user = mkOpt (types.nullOr types.str) null;
      group = mkOpt (types.nullOr types.str) null;
    };
  };
in {
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  options.modules.impermanence = {
    safe = {
      files = mkOpt (types.listOf types.str) [];
      folders = mkOpt (types.listOf (types.coercedTo types.str (f: {directory = f;}) directoryEntry)) [];
      userFiles = mkOpt (types.listOf types.str) [];
      userFolders = mkOpt (types.listOf (types.coercedTo types.str (f: {directory = f;}) directoryEntry)) [];
    };
    unsafe = {
      files = mkOpt (types.listOf types.str) [];
      folders = mkOpt (types.listOf (types.coercedTo types.str (f: {directory = f;}) directoryEntry)) [];
      userFiles = mkOpt (types.listOf types.str) [];
      userFolders = mkOpt (types.listOf (types.coercedTo types.str (f: {directory = f;}) directoryEntry)) [];
    };
  };

  config = {
    environment.persistence."/persist" = {
      hideMounts = true;
      files =
        [
        ]
        ++ cfg.safe.files;
      directories =
        [
          "/etc/nixos"
          {
            directory = "/etc/ssh";
            mode = "0755";
          }
        ]
        ++ lists.forEach cfg.safe.folders (e: attrsets.filterAttrs (n: v: v != null) e);

      users.${config.modules.user.username} = {
        files = [] ++ cfg.safe.userFiles;
        directories = ["proj"] ++ lists.forEach cfg.safe.userFolders (e: attrsets.filterAttrs (n: v: v != null) e);
      };
    };

    environment.persistence."/persist-unsafe" = {
      hideMounts = true;
      files =
        []
        ++ cfg.unsafe.files;
      directories =
        [
          "/var/log"
          "/var/lib/nixos"
          "/var/lib/systemd/timers"
        ]
        ++ lists.forEach cfg.unsafe.folders (e: attrsets.filterAttrs (n: v: v != null) e);

      users.${config.modules.user.username} = {
        files = [] ++ cfg.unsafe.userFiles;
        directories = [] ++ lists.forEach cfg.unsafe.userFolders (e: attrsets.filterAttrs (n: v: v != null) e);
      };
    };
  };
}
