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
    extraHosts = mkOpt (types.attrsOf inferred) {};
  };

  config = mkIf cfg.enable {
    services.nginx = {
      enable = true;

      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      sslProtocols = "TLSv1.2 TLSv1.3";
      sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

      virtualHosts = {} // cfg.extraHosts;
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = "acme@dany.dev";
    };
  };
}
