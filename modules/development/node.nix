{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.development.node;
in {
  options.modules.development.node = {
    enable = mkBoolOpt false;
    package = mkOpt types.package pkgs.unstable.nodejs_22;
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.modules.user.username} = {pkgs, ...}: {
      home.packages = [
        cfg.package
        pkgs.yarn
      ];
    };
  };
}
