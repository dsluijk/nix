{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  nietflixCfg = config.modules.services.nietflix;
  cfg = nietflixCfg.sonarr;
  enabled = nietflixCfg.enable && cfg.enable;
  sonarrDir = "${nietflixCfg.dataDir}/sonarr";
in {
  options.modules.services.nietflix.sonarr = {
    enable = mkBoolOpt true;
  };

  config = mkIf enabled {
    services.sonarr = {
      enable = true;
      dataDir = sonarrDir;
    };

    users.users.sonarr.extraGroups = ["nietflix" "sabnzbd"];

    modules.services.nginx = {
      enable = true;
      extraHosts = {
        "sonarr.dany.dev" = {
          forceSSL = true;
          enableACME = true;
          http2 = true;

          extraConfig = ''
            proxy_buffers 8 16k;
            proxy_buffer_size 32k;
          '';

          locations = {
            "/" = {
              proxyPass = "http://localhost:8989/";
              proxyWebsockets = true;
              recommendedProxySettings = true;
              extraConfig = ''
                auth_request     /outpost.goauthentik.io/auth/nginx;
                error_page       401 = @goauthentik_proxy_signin;
                auth_request_set $auth_cookie $upstream_http_set_cookie;
                add_header       Set-Cookie $auth_cookie;

                auth_request_set $authentik_username $upstream_http_x_authentik_username;
                auth_request_set $authentik_groups $upstream_http_x_authentik_groups;
                auth_request_set $authentik_entitlements $upstream_http_x_authentik_entitlements;
                auth_request_set $authentik_email $upstream_http_x_authentik_email;
                auth_request_set $authentik_name $upstream_http_x_authentik_name;
                auth_request_set $authentik_uid $upstream_http_x_authentik_uid;

                proxy_set_header X-authentik-username $authentik_username;
                proxy_set_header X-authentik-groups $authentik_groups;
                proxy_set_header X-authentik-entitlements $authentik_entitlements;
                proxy_set_header X-authentik-email $authentik_email;
                proxy_set_header X-authentik-name $authentik_name;
                proxy_set_header X-authentik-uid $authentik_uid;
              '';
            };

            "/outpost.goauthentik.io" = {
              proxyPass = "http://localhost:9000/outpost.goauthentik.io";
              extraConfig = ''
                proxy_set_header        Host $host;
                proxy_set_header        X-Original-URL $scheme://$http_host$request_uri;
                add_header              Set-Cookie $auth_cookie;
                auth_request_set        $auth_cookie $upstream_http_set_cookie;
                proxy_pass_request_body off;
                proxy_set_header        Content-Length "";
              '';
            };

            "@goauthentik_proxy_signin" = {
              return = "302 /outpost.goauthentik.io/start?rd=$scheme://$http_host$request_uri";
              extraConfig = ''
                internal;
                add_header Set-Cookie $auth_cookie;
              '';
            };
          };
        };
      };
    };
  };
}
