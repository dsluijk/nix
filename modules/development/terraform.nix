{
  config,
  lib,
  vscode-extensions,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.development.terraform;
in {
  options.modules.development.terraform = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    modules = {
      programs.vscode = {
        additionalExtensions = with vscode-extensions; [
          hashicorp.terraform
        ];

        settings = {
          "[terraform]" = {
            "editor.defaultFormatter" = "hashicorp.terraform";
          };
          "[tfvars]" = {
            "editor.defaultFormatter" = "hashicorp.terraform";
          };
        };
      };
    };
  };
}
