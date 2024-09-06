{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.roundcube;
in {
  options.modules.services.roundcube = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services = {
      roundcube = {
        enable = true;
        hostName = "mail.dany.dev";
        dicts = with pkgs.aspellDicts; [nl en];

        database = {
          host = "localhost";
          dbname = "roundcube";
          username = "roundcube";
          password = "roundcube";
        };

        extraConfig = ''
          # starttls needed for authentication, so the fqdn required to match
          # the certificate
          $config['smtp_server'] = "tls://${config.mailserver.fqdn}";
          $config['smtp_user'] = "%u";
          $config['smtp_pass'] = "%p";
        '';
      };
    };

    modules.postgres = {
      extraUsers = ["roundcube"];
    };
  };
}
