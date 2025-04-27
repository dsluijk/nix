{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  nietflixCfg = config.modules.services.nietflix;
  cfg = nietflixCfg.sonarr;
  enabled = nietflixCfg.enable && cfg.enable;
  sonarrDir = "${nietflixCfg.dataDir}/sonarr";
in {
  options.modules.services.nietflix.sonarr = {
    enable = mkBoolOpt true;
  };

  config = mkIf enabled {
    services.sonarr = {
      enable = true;
      dataDir = sonarrDir;
    };

    users.users.sonarr.extraGroups = ["nietflix"];
  };
}
