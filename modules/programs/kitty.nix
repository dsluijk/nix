{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.programs.kitty;
in {
  options.modules.programs.kitty = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    modules = {
      tools.shell.enable = true;
    };

    home-manager.users.${config.modules.user.username} = {pkgs, ...}: {
      programs.kitty = {
        enable = true;

        shellIntegration.enableZshIntegration = config.modules.tools.shell.enable;
      };

      programs.zsh = {
        shellAliases = {
          ssh = "kitten ssh";
        };
      };
    };
  };
}
