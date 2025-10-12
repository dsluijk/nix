{
  config,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.hyprland;
in {
  config = mkIf cfg.enable {
    home-manager.users.${config.modules.user.username} = {
      pkgs,
      config,
      ...
    }: {
      services.hyprpaper = {
        enable = true;

        settings = {
          splash = false;
          ipc = "off";

          preload = [
            # "${config.xdg.dataHome}/wallpaper-${baseNameOf config.stylix.image}"
            config.stylix.image
          ];
          wallpaper = [
            # ",${config.xdg.dataHome}/wallpaper-${baseNameOf config.stylix.image}"
            config.stylix.image
          ];
        };
      };

      # xdg.dataFile.wallpaper = {
      #   enable = true;
      #   executable = false;
      #   source = config.stylix.image;
      #   target = "wallpaper-${baseNameOf config.stylix.image}";
      #   onChange = "${pkgs.systemd}/bin/systemctl restart --user hyprpaper";
      # };
    };
  };
}
