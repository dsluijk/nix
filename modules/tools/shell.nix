{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.tools.shell;
in {
  options.modules.tools.shell = {
    enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    users.users.${config.modules.user.username} = {
      shell = pkgs.zsh;
      ignoreShellProgramCheck = true;
    };

    home-manager.users.${config.modules.user.username} = {pkgs, ...}: {
      home.packages = [
        pkgs.chroma
      ];

      programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        history = {
          path = "/home/${config.modules.user.username}/.zsh_history";
          size = 10000;
        };

        initExtra = ''
          setopt INC_APPEND_HISTORY
          unsetopt HIST_SAVE_BY_COPY
        '';

        shellAliases = {
          update = "sudo nixos-rebuild switch";
          update-dev = "sudo nixos-rebuild switch --flake path:/home/${config.modules.user.username}/proj/github.com/dsluijk/nix";
          cat = "ccat";
        };

        oh-my-zsh = {
          enable = true;
          theme = "robbyrussell";
          plugins = [
            "colorize"
            "common-aliases"
            "fd"
            "magic-enter"
            "perms"
            "sudo"
            "systemd"
            "safe-paste"
            "z"
            "zbell"
          ];
        };
      };
    };

    modules.impermanence = {
      unsafe.userFiles = [
        ".zsh_history"
      ];
    };
  };
}
