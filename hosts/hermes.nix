{
  self,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../hardware/14-cf0610nd.nix
  ];

  system.stateVersion = "25.05";

  modules = {
    hm.stateVersion = "25.05";
    optimize.autoUpgrade = false;

    disk = {
      device = "/dev/disk/by-id/wwn-0x5002538d00677825";
      swapSize = "4G";
    };

    theme.wallpaper = ../assets/wallpapers/national.jpg;

    desktop.hyprland = {
      enable = true;
    };

    tools = {
      git.enable = true;
    };

    programs = {
      kitty.enable = true;
      firefox.enable = true;
      # spotify.enable = true;
      libreoffice.enable = true;
      # mpv.enable = true;
      # loupe.enable = true;
      # kubectl.enable = true;
      # bruno.enable = true;
      # discord.enable = true;
      # bambustudio.enable = true;
      vscode.enable = true;
      sshagent.enable = true;
      # steam.enable = true;
    };

    development = {
      # node.enable = true;
      # nuxt.enable = true;
      # python.enable = true;
      # docker.enable = true;
      # ccache.enable = true;
      # terraform.enable = true;
    };

    services = {
      tailscale.enable = true;
    };
  };
}
