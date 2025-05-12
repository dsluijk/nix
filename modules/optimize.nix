{
  lib,
  config,
  inputs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.optimize;
in {
  options.modules.optimize = {
    enable = mkBoolOpt true;
    autoOptimize = mkBoolOpt true;
    autoUpgrade = mkBoolOpt true;
    allowReboot = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    nix = {
      settings.auto-optimise-store = cfg.autoOptimize;

      # Optimize the store at every build and automatically.
      optimise = {
        automatic = true;
        dates = ["03:45"];
      };

      # Do some garbaging.
      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 7d";
      };

      # Don't remove the cached files so we don't download the entire internet every time we boot.
      extraOptions = ''
        keep-outputs = true
        keep-derivations = true
      '';
    };

    # Automatically upgrade the system periodically.
    system.autoUpgrade = {
      enable = cfg.autoUpgrade;
      allowReboot = cfg.allowReboot;
      flake = "github:dsluijk/nix";
      flags = [
        "-L"
      ];
      dates = "02:00";
      randomizedDelaySec = "45min";
    };
  };
}
