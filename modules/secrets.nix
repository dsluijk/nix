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
        authentik = {
          file = ../secrets/authentik.age;
          mode = "500";
          owner = "authentik";
          group = "authentik";
        };
        outline-oidc = {
          file = ../secrets/outline/oidc.age;
          mode = "500";
          owner = "outline";
          group = "outline";
        };
        outline-smtp = {
          file = ../secrets/outline/smtp.age;
          mode = "500";
          owner = "outline";
          group = "outline";
        };
        headscale-oidc = {
          file = ../secrets/headscale/oidc.age;
          mode = "500";
          owner = "headscale";
          group = "headscale";
        };
        immich = {
          file = ../secrets/immich.age;
          mode = "500";
          owner = config.services.immich.user;
          group = config.services.immich.group;
        };
        mealie = {
          file = ../secrets/mealie.age;
          mode = "500";
          owner = "mealie";
          group = "users";
        };
        actual = {
          file = ../secrets/actual.age;
          mode = "500";
          owner = "actual";
          group = "actual";
        };
        shuttr = {
          file = ../secrets/shuttr.age;
          mode = "500";
          owner = "shuttr";
          group = "shuttr";
        };
      };
    };
  };
}
