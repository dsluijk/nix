{
  config,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.programs.spotify;
in {
  options.modules.programs.spotify = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.modules.user.username} = {pkgs, ...}: {
      home.packages = with pkgs; [
        spotify
      ];
    };

    modules.impermanence = {
      unsafe.userFolders = [
        ".config/spotify"
        ".cache/spotify"
      ];
    };
  };
}
