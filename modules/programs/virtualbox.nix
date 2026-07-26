{
  config,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.programs.virtualbox;
in {
  options.modules.programs.virtualbox = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    virtualisation.virtualbox.host = {
      enable = true;
      enableExtensionPack = true;
    };

    users.users.${config.modules.user.username}.extraGroups = ["vboxusers"];

    modules.impermanence = {
      unsafe.userFolders = [
        ".config/VirtualBox"
      ];
    };
  };
}
