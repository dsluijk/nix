{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.theme;
in {
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  options.modules.theme = {
    wallpaper = mkOpt types.path ../assets/wallpapers/mountains.jpg;
    wallpaperFolder = mkOpt types.path ../assets/wallpapers;
    profile = mkOpt types.path ../assets/profile.jpg;
    polarity = mkOpt (types.enum ["dark" "light" "either"]) "dark";
  };

  config = {
    stylix = {
      enable = true;
      image = cfg.wallpaper;
      polarity = cfg.polarity;
      fonts.serif = config.stylix.fonts.sansSerif;
      targets.plymouth = {
        logo = "${pkgs.nixos-icons}/share/icons/hicolor/256x256/apps/nix-snowflake-white.png";
        logoAnimated = false;
      };
    };
  };
}
