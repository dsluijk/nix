{
  lib,
  config,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.wireless;
in {
  options.modules.wireless = {
    enable = mkBoolOpt false;
    extra = mkOpt (types.attrsOf types.str) [];
  };

  config = mkIf cfg.enable {
    modules.secrets.required = ["wireless"];

    networking.wireless = {
      enable = true;
      userControlled.enable = true;
      secretsFile = config.age.secrets.wireless.path;

      networks =
        {
          "The Promised LAN".pskRaw = "ext:PSK_THE_PROMISED_LAN";
          "AbcoudeNMDT".pskRaw = "ext:PSK_ABCOUDE_NMDT";
          "Proteus-Eretes Wifi".pskRaw = "ext:PSK_PROTEUS_ERETES_WIFI";

          "Cobalt" = {
            pskRaw = "ext:PSK_COBALT";
            priority = 5;
          };

          "eduroam" = {
            authProtocols = ["WPA-EAP"];
            auth = ''
              eap=PEAP
              identity="dsluijk@tudelft.nl"
              anonymous_identity="anonymous@tudelft.nl"
              phase2="auth=MSCHAPV2"
              password=ext:PSK_EDUROAM
            '';
          };
        }
        // (mapAttrs (_: psk: {inherit psk;}) cfg.extra);
    };
  };
}
