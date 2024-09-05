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
    authorizedKeys = mkOpt (types.listOf types.str) [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICPboZ99kJlrtxjdkUSmvVbgLicyEXrS4PGmXKBs7ptp me@dany.dev"
    ];
  };

  config = {
    users.users.${cfg.username} = {
      isNormalUser = true;
      home = "/home/${cfg.username}";
      initialPassword = "changeme";
      extraGroups = mkIf cfg.sudo ["wheel"];
      openssh.authorizedKeys.keys = cfg.authorizedKeys;
    };
  };
}
