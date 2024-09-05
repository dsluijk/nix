{
  config,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.hyprland;
in {
  options.modules.desktop.hyprland = {
    withAudio = mkBoolOpt true;
  };

  config = mkIf cfg.withAudio {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
