{
  config,
  lib,
  vscode-extensions,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.programs.claude;
in {
  options.modules.programs.claude = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.modules.user.username} = {pkgs, ...}: {
      home.packages = with pkgs; [
        claude-code
      ];
    };

    modules = {
      programs.vscode = {
        settings = {
          claudeCode.hideOnboarding = true;
          claudeCode.preferredLocation = "panel";
        };

        extensions = with vscode-extensions; [
          anthropic.claude-code
        ];
      };

      impermanence.safe = {
        userFiles = [
          ".claude.json"
        ];
        userFolders = [
          ".claude"
        ];
      };
    };
  };
}
