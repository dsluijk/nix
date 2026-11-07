{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.nginx;
  hasPassthrough = cfg.passthroughHosts != {};
  localSSLPort = 8443;
in {
  options.modules.services.nginx = {
    enable = mkBoolOpt false;
    extraHosts = mkOpt types.attrs {};
    # Server name (nginx `hostnames` map syntax, e.g. "*.apps.dany.dev") -> upstream address.
    # TLS is passed through untouched with a PROXY protocol header, plain HTTP is reverse proxied.
    passthroughHosts = mkOpt (types.attrsOf types.str) {};
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

      virtualHosts =
        {}
        // cfg.extraHosts
        // optionalAttrs hasPassthrough (mapAttrs' (name: upstream:
          nameValuePair "passthrough-${name}" {
            serverName = name;
            locations."/" = {
              proxyPass = "http://${upstream}";
              extraConfig = ''
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
              '';
            };
          })
        cfg.passthroughHosts);
    };

    # With TLS passthrough, port 443 is owned by the stream module which routes on SNI.
    # Locally terminated HTTPS moves to a loopback port, with the PROXY protocol to keep the client IP.
    services.nginx.defaultListen = mkIf hasPassthrough [
      {
        addr = "127.0.0.1";
        port = localSSLPort;
        ssl = true;
        proxyProtocol = true;
      }
      {
        addr = "0.0.0.0";
        port = 80;
        ssl = false;
      }
      {
        addr = "[::]";
        port = 80;
        ssl = false;
      }
    ];

    services.nginx.appendHttpConfig = mkIf hasPassthrough ''
      set_real_ip_from 127.0.0.1;
      real_ip_header proxy_protocol;
    '';

    services.nginx.streamConfig = mkIf hasPassthrough ''
      map $ssl_preread_server_name $sni_upstream {
        hostnames;
        ${concatStrings (mapAttrsToList (name: upstream: "${name} ${upstream}:443;\n") cfg.passthroughHosts)}
        default 127.0.0.1:${toString localSSLPort};
      }

      server {
        listen 443;
        listen [::]:443;
        ssl_preread on;
        proxy_pass $sni_upstream;
        proxy_protocol on;
      }
    '';

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
