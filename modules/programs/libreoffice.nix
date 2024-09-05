{
  config,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.programs.libreoffice;
in {
  options.modules.programs.libreoffice = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.modules.user.username} = {pkgs, ...}: {
      home.packages = with pkgs; [
        libreoffice-fresh
        hunspell
        hunspellDicts.nl_NL
        hunspellDicts.en_US
      ];
    };
  };
}
