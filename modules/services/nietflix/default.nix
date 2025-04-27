{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.nietflix;
in {
  options.modules.services.nietflix = {
    enable = mkBoolOpt false;
    dataDir = mkStrOpt "/data/nietflix";
  };

  config = mkIf cfg.enable {
    users.groups.nietflix = {};
  };
}
