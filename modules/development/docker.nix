{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.development.docker;
in {
  options.modules.development.docker = {
    enable = mkBoolOpt false;
    compose = mkBoolOpt true;
    autoPrune = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      autoPrune.enable = cfg.autoPrune;
    };

    home-manager.users.${config.modules.user.username} = {pkgs, ...}: {
      home.packages = mkIf cfg.compose [
        pkgs.docker-compose
      ];
    };

    users.users.${config.modules.user.username} = {
      extraGroups = ["docker"];
    };

    modules.impermanence = {
      unsafe.folders = [
        "/var/lib/docker"
      ];
    };
  };
}
