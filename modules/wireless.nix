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
      environmentFile = config.age.secrets.wireless.path;

      networks =
        {
          "The Promised LAN".psk = "@PSK_THE_PROMISED_LAN@";
          "AbcoudeNMDT".psk = "@PSK_ABCOUDE_NMDT@";
          "Zebrasoma".psk = "@PSK_ZEBRASOMA@";
          "Cobalt".psk = "@PSK_COBALT@";
          "Proteus-Eretes Wifi".psk = "@PSK_PROTEUS_ERETES_WIFI@";

          "eduroam".auth = ''
            key_mgmt=WPA-EAP
            eap=PEAP
            identity="dsluijk@tudelft.nl"
            anonymous_identity="anonymous@tudelft.nl"
            phase2="auth=MSCHAPV2"
            password="@PSK_EDUROAM@"
          '';
        }
        // (mapAttrs (_: psk: {inherit psk;}) cfg.extra);
    };
  };
}
