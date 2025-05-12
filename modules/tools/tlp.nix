{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.tools.tlp;
in {
  options.modules.tools.tlp = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.power-profiles-daemon.enable = false;

    services.tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";

        INTEL_GPU_MIN_FREQ_ON_AC = 650;
        INTEL_GPU_MIN_FREQ_ON_BAT = 500;

        START_CHARGE_THRESH_BAT0 = 70;
        STOP_CHARGE_THRESH_BAT0 = 90;
      };
    };
  };
}
