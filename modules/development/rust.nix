{
  config,
  lib,
  vscode-extensions,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.development.rust;
in {
  options.modules.development.rust = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    modules = {
      programs.vscode = {
        extensions = with vscode-extensions; [
          rust-lang.rust-analyzer
        ];

        settings = {
          "[rust]" = {
            "editor.defaultFormatter" = "rust-lang.rust-analyzer";
          };
        };
      };
    };

    home-manager.users.${config.modules.user.username} = {pkgs, ...}: {
      home.packages = [
        pkgs.openssl
        pkgs.pkg-config
        pkgs.cargo
        pkgs.rustc
        pkgs.rustfmt
        pkgs.clippy
        pkgs.gcc
      ];
    };
  };
}
