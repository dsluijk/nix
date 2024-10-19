{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.development.ccache;
in {
  options.modules.development.ccache = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    programs.ccache.enable = true;

    nix.settings.extra-sandbox-paths = [config.programs.ccache.cacheDir];

    modules.impermanence = {
      unsafe.folders = [
        {
          directory = config.programs.ccache.cacheDir;
          mode = "0770";
        }
      ];
    };
  };
}
