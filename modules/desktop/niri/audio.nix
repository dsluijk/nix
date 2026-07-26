{
  config,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.niri;
in {
  options.modules.desktop.niri = {
    withAudio = mkBoolOpt true;
  };

  config = mkIf cfg.withAudio {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      audio.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    modules = {
      impermanence = {
        unsafe.userFolders = [
          ".local/state/wireplumber"
        ];
      };
    };
  };
}
