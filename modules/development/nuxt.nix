{
  config,
  lib,
  vscode-extensions,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.development.nuxt;
in {
  options.modules.development.nuxt = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    modules = {
      development.node.enable = true;

      programs.vscode.extensions = with vscode-extensions; [
        nuxtr.nuxt-vscode-extentions
        vue.volar
        antfu.goto-alias
        nuxtr.nuxtr-vscode
        nuxt.mdc
      ];
    };

    programs = {
      nix-ld.enable = true;

      nix-ld.libraries = with pkgs; [
        wrangler
      ];
    };

    home-manager.users.${config.modules.user.username} = {pkgs, ...}: {
      home = {
        sessionVariables = {
          NUXT_TELEMETRY_DISABLED = 1;
        };
      };
    };
  };
}
