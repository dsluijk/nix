{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.niri;
in {
  imports = [
    inputs.noctalia-greeter.nixosModules.default
  ];

  config = mkIf (cfg.enable && cfg.autostart) {
    services.greetd = {
      enable = true;

      settings = rec {
        initial_session = {
          command = "${pkgs.niri}/bin/niri";
          user = "${config.modules.user.username}";
        };
        default_session = initial_session;
      };
    };

    programs.noctalia-greeter = {
      enable = true;
      package = inputs.noctalia-greeter.packages.${pkgs.stdenv.hostPlatform.system}.default;

      # Optional configuration
      greeter-args = "";
      settings.cursor = {
        theme = "Adwaita";
        size = 24;
        package = pkgs.adwaita-icon-theme;
      };
    };
  };
}
