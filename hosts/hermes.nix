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

    wireless = {
      enable = true;
      extra = {};
    };

    theme.wallpaper = ../assets/wallpapers/national.jpg;

    desktop.hyprland = {
      enable = true;
      fancy = false;
      monitors = [
        "eDP-1, preferred, 0x0, 0.666667"
      ];
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
      discord.enable = true;
      vscode.enable = true;
      sshagent.enable = true;
      # bambustudio.enable = true;
      # steam.enable = true;
      # kubectl.enable = true;
      # bruno.enable = true;
    };

    development = {
      python.enable = true;

      docker = {
        enable = true;
        onBoot = false;
      };

      # node.enable = true;
      # nuxt.enable = true;
      # ccache.enable = true;
      # terraform.enable = true;
    };

    services = {
      tailscale.enable = true;
    };
  };
}
