{
  lib,
  config,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.common;
in {
  options.modules.common = {
    timezone = mkStrOpt "Europe/Amsterdam";
    locale = mkStrOpt "en_US.UTF-8";
  };

  config = {
    nix.settings = {
      experimental-features = ["nix-command" "flakes"];
    };

    time.timeZone = cfg.timezone;
    i18n.defaultLocale = cfg.locale;
  };
}
