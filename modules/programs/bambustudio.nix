{
  config,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.programs.bambustudio;
in {
  options.modules.programs.bambustudio = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.modules.user.username} = {pkgs, ...}: {
      home.packages = with pkgs; [
        bambu-studio
      ];
    };

    modules.impermanence = {
      unsafe.userFolders = [
        ".config/BambuStudio"
      ];
    };
  };
}
