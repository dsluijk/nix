{
  self,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../hardware/fw16.nix
  ];

  system.stateVersion = "24.05";

  modules = {
    hm.stateVersion = "24.05";
    optimize.autoUpgrade = false;

    disk = {
      device = "/dev/disk/by-id/nvme-Samsung_SSD_990_PRO_2TB_S7DNNJ0X116212L";
      swapSize = "64G";
    };

    networking = {
      enable = true;
      networkmanager = true;
      extra = {};
    };

    bluetooth.enable = true;
    hardware = {
      logitech.enable = true;
      displaylink.enable = true;
    };

    theme.wallpaper = ../assets/wallpapers/DSC01792.jpg;

    desktop.hyprland = {
      enable = false;
      autostart = false;
    };

    desktop.niri = {
      enable = true;
    };

    tools = {
      git.enable = true;
      tlp.enable = true;
    };

    programs = {
      kitty.enable = true;
      firefox.enable = true;
      spotify.enable = true;
      libreoffice.enable = true;
      mpv.enable = true;
      loupe.enable = true;
      kubectl.enable = true;
      bruno.enable = true;
      discord.enable = true;
      # bambustudio.enable = true;
      vscode.enable = true;
      sshagent.enable = true;
      steam.enable = true;
      zotero.enable = true;
      nh.enable = true;
      claude.enable = true;
    };

    development = {
      node.enable = true;
      nuxt.enable = true;
      python.enable = true;
      docker.enable = true;
      ccache.enable = true;
      terraform.enable = true;
      latex.enable = true;
      rust.enable = true;
    };

    services = {
      tailscale.enable = false;
    };

    other = {
      ctf.enable = true;
    };
  };
}
