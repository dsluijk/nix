{
  config,
  lib,
  inputs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.programs.vim;
in {
  # imports = [
  #   inputs.nixvim.nixosModules.default
  # ];

  options.modules.programs.vim = {
    enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.modules.user.username} = {pkgs, ...}: {
      imports = [inputs.nixvim.homeModules.default];

      # home.packages = [pkgs.libqalculate pkgs.papirus-icon-theme];

      # wayland.windowManager.hyprland.settings.exec-once = [
      #   "${pkgs.walker}/bin/walker --gapplication-service"
      # ];

      programs.nixvim = {
        enable = true;

        colorschemes.catppuccin.enable = true;
        plugins.lualine.enable = true;
      };
    };

    # virtualisation.virtualbox.host = {
    #   enable = true;
    #   enableExtensionPack = true;
    # };

    # users.users.${config.modules.user.username}.extraGroups = ["vboxusers"];

    # modules.impermanence = {
    #   unsafe.userFolders = [
    #     ".config/VirtualBox"
    #   ];
    # };
  };
}
