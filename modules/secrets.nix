{
  lib,
  config,
  inputs,
  system,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.secrets;
in {
  imports = [inputs.agenix.nixosModules.default];

  options.modules.secrets = {
    required = mkOpt (types.listOf types.str) [];
  };

  config = {
    environment.systemPackages = [inputs.agenix.packages.${system}.default];

    age = {
      identityPaths = ["/persist/etc/ssh/ssh_host_ed25519_key"];

      secrets = filterAttrs (n: _: elem n cfg.required) {
        wireless = {
          file = ../secrets/wireless.age;
          mode = "500";
          owner = "root";
          group = "root";
        };
        zitadel = {
          file = ../secrets/zitadel.age;
          mode = "500";
          owner = "zitadel";
          group = "zitadel";
        };
      };
    };
  };
}
