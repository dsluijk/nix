{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.programs.kubectl;
  gdk = pkgs.google-cloud-sdk.withExtraComponents (with pkgs.google-cloud-sdk.components; [
    gke-gcloud-auth-plugin
  ]);
in {
  options.modules.programs.kubectl = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.modules.user.username} = {pkgs, ...}: {
      home.packages = with pkgs; [
        kubectl
        k9s
        gdk
        fluxcd
      ];
    };

    modules.impermanence = {
      unsafe.userFolders = [
        ".kube"
        ".config/gcloud"
      ];
    };
  };
}
