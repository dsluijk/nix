{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.tools.ssh;
in {
  options.modules.tools.ssh = {
    enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;

      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };

    modules.impermanence = {
      unsafe.userFiles = [".ssh/id_ed25519"];
    };
  };
}
