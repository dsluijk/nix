{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.development.python;
in {
  options.modules.development.python = {
    enable = mkBoolOpt false;
    package = mkOpt types.package pkgs.python3;
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.modules.user.username} = {pkgs, ...}: {
      home.packages = [
        (cfg.package.withPackages (python-pkgs: [
          python-pkgs.numpy
          python-pkgs.matplotlib
          python-pkgs.requests
        ]))
      ];
    };
  };
}
