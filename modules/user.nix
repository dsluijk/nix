{
  lib,
  config,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.user;
in {
  options.modules.user = {
    username = mkStrOpt "dsluijk";
    sudo = mkBoolOpt true;
    dialout = mkBoolOpt true;
    authorizedKeys = mkOpt (types.listOf types.str) [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICPboZ99kJlrtxjdkUSmvVbgLicyEXrS4PGmXKBs7ptp me@dany.dev"
    ];
  };

  config = {
    users.users.${cfg.username} = {
      isNormalUser = true;
      home = "/home/${cfg.username}";
      initialPassword = "changeme";
      extraGroups = mkMerge [
        (mkIf cfg.sudo ["wheel"])
        (mkIf cfg.dialout ["dialout"])
      ];
      openssh.authorizedKeys.keys = cfg.authorizedKeys;
    };
  };
}
