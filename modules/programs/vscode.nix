{
  config,
  lib,
  vscode-extensions,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.programs.vscode;
in {
  options.modules.programs.vscode = {
    enable = mkBoolOpt false;
    additionalExtensions = mkOpt (types.listOf types.package) [];
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.modules.user.username} = {pkgs, ...}: {
      home.packages = with pkgs; [nixpkgs-fmt alejandra];
      stylix.targets.vscode.enable = false;

      programs.vscode = {
        enable = true;
        package = pkgs.unstable.vscode;
        enableUpdateCheck = false;
        enableExtensionUpdateCheck = false;
        mutableExtensionsDir = false;
        userSettings = {
          "window.titleBarStyle" = "custom";
          "editor.formatOnSave" = true;
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
          "update.showReleaseNotes" = false;
          "workbench.startupEditor" = "none";
          "alejandra.program" = "alejandra";
          "redhat.telemetry.enabled" = false;
          "[nix]" = {
            "editor.defaultFormatter" = "kamadorueda.alejandra";
          };
        };
        extensions = with vscode-extensions;
          [
            esbenp.prettier-vscode
            jnoortheen.nix-ide
            editorconfig.editorconfig
            kamadorueda.alejandra
            ms-vscode-remote.remote-containers
          ]
          ++ cfg.additionalExtensions;
      };
    };

    modules.impermanence = {
      unsafe.userFolders = [
        ".config/Code"
      ];
    };
  };
}
