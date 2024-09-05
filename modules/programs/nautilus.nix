{
  config,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.programs.nautilus;
in {
  options.modules.programs.nautilus = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.modules.user.username} = {pkgs, ...}: {
      home.packages = with pkgs; [
        gnome.nautilus
      ];
    };
  };
}
