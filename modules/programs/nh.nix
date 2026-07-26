{
  config,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.programs.nh;
in {
  options.modules.programs.nh = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/user/proj/dsluijk/nix";
    };
  };
}
