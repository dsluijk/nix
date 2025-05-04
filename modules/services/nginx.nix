{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.nginx;
in {
  options.modules.services.nginx = {
    enable = mkBoolOpt false;
    extraHosts = mkOpt types.attrs {};
  };

  config = mkIf cfg.enable {
    services.nginx = {
      enable = true;

      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedTlsSettings = true;
      recommendedProxySettings = mkForce false;

      sslProtocols = "TLSv1.2 TLSv1.3";
      sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

      virtualHosts = {} // cfg.extraHosts;
    };

    networking.firewall.allowedTCPPorts = [80 443];

    security.acme = {
      acceptTerms = true;
      defaults.email = "acme@dany.dev";
    };

    modules.impermanence = {
      safe.folders = [
        "/var/lib/acme"
      ];
      unsafe.folders = [
        "/var/log/nginx"
      ];
    };
  };
}
