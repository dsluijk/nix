{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.mail;
in {
  options.modules.services.mail = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    imports = [inputs.nixos-mailserver.nixosModule];

    mailserver = {
      enable = true;
      fqdn = "mail.dany.dev";
      domains = ["dany.dev" "atlasdev.nl"];
      certificateScheme = "acme-nginx";
      openFirewall = true;

      dmarcReporting = {
        enable = true;
        organizationName = "Dany";
        localpart = "dmarc-noreply";
        domain = "dany.dev";
      };

      loginAccounts = {
        "me@dany.dev" = {
          name = "me@dany.dev";
          quota = "100G";
          # TODO: this really shouldn't be in here, especially not public.
          # Should switch to SSO asap.
          hashedPassword = "$2a$10$6a9NpmHrOQKo3O8yt5efgeNOu0ZMtBTs2ttG.uAizTWhY86srDKeK";
          aliases = ["@dany.dev" "@atlasdev.nl"];
        };
      };
    };

    modules.impermanence = {
      safe.folders = [
        "/var/vmail"
        "/var/dkim"
        "/var/lib/rspamd"
      ];
    };
  };
}
