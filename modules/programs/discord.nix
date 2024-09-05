{
  config,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.programs.discord;
in {
  options.modules.programs.discord = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.modules.user.username} = {pkgs, ...}: {
      home.packages = with pkgs; [
        discord
      ];
    };

    modules.impermanence = {
      unsafe.userFolders = [
        ".config/discord"
      ];
    };
  };
}
