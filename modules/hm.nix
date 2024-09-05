{
  config,
  lib,
  inputs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.hm;
in {
  options.modules.hm = {
    stateVersion = mkStrOpt null;
  };

  config = {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {inherit inputs;};

      users.${config.modules.user.username} = {pkgs, ...}: {
        programs.home-manager.enable = true;

        home = {
          stateVersion = cfg.stateVersion;
          username = config.modules.user.username;
          homeDirectory = "/home/${config.modules.user.username}";

          packages = with pkgs; [
            wget
            btop
            vim
            acpi
          ];
        };
      };
    };
  };
}
