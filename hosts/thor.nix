{
  self,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../hardware/b450.nix
  ];

  system.stateVersion = "25.05";

  modules = {
    hm.stateVersion = "25.05";
    optimize.allowReboot = false;

    disk = {
      device = "/dev/disk/by-id/nvme-KINGSTON_SA2000M81000G_50026B7683877B64";
      swapSize = "64G";
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
      spotify.enable = true;
      # libreoffice.enable = true;
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
      node.enable = true;
      nuxt.enable = true;
      # python.enable = true;
      docker.enable = true;
      # ccache.enable = true;
      # terraform.enable = true;
    };

    services = {
      tailscale.enable = true;
    };
  };
}
