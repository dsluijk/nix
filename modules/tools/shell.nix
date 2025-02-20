{
  config,
  lib,
  pkgs,
  inputs,
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
      imports = [inputs.nix-index-database.hmModules.nix-index];

      home.packages = [
        pkgs.chroma
      ];

      programs = {
        zsh = {
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
            update = "sudo nixos-rebuild switch --flake github:dsluijk/nix --refresh";
            update-dev = "sudo nixos-rebuild switch --flake path:.";
            cat = "ccat";
          };

          oh-my-zsh = {
            enable = true;
            theme = "robbyrussell";
            plugins = [
              "colorize"
              "common-aliases"
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

        nix-index.enable = true;
        nix-index-database.comma.enable = true;
      };
    };

    modules.impermanence = {
      unsafe.userFiles = [
        ".zsh_history"
      ];
    };
  };
}
