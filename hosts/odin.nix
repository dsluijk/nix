{
  self,
  config,
  pkgs,
  vscode-extensions,
  ...
}: {
  imports = [
    ../hardware/fw16.nix
  ];

  system.stateVersion = "24.05";

  modules = {
    hm.stateVersion = "24.05";
    optimize.allowReboot = false;

    disk = {
      device = "/dev/disk/by-id/nvme-Samsung_SSD_990_PRO_2TB_S7DNNJ0X116212L";
      swapSize = "64G";
    };

    wireless = {
      enable = true;
      extra = {};
    };

    bluetooth.enable = true;

    theme.wallpaper = ../assets/wallpapers/mountains.jpg;

    desktop.hyprland = {
      enable = true;
      xwayland = false;
    };

    tools = {
      git.enable = true;
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
      bambustudio.enable = true;

      vscode = {
        enable = true;
        additionalExtensions = with vscode-extensions; [dtoplak.vscode-glsllint slevesque.shader];
      };
    };

    development = {
      node.enable = true;
      nuxt.enable = true;
      python.enable = true;
      docker.enable = true;
    };
  };
}
