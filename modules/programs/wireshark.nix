{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.programs.wireshark;
in {
  options.modules.programs.wireshark = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    programs.wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };

    users.users.${config.modules.user.username}.extraGroups = ["wireshark"];
  };
}
