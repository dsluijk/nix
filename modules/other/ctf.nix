{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.other.ctf;
in {
  options.modules.other.ctf = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.modules.user.username} = {pkgs, ...}: {
      home.packages = [
        pkgs.burpsuite
        pkgs.hashcat
        pkgs.seclists
        pkgs.sqlmap
        pkgs.z3
        pkgs.gdb
        # pkgs.toybox
        pkgs.ffuf
        pkgs.jwt-hack
        pkgs.flask-unsign
        pkgs.ghidra
        pkgs.ghidra-extensions.wasm
        # pkgs.ropgadget
        pkgs.nmap
        pkgs.dirb
        pkgs.curl
        # pkgs.binwalk
        # pkgs.pwntools
      ];
    };

    modules = {
      desktop.hyprland.xwayland = true;

      programs = {
        wireshark.enable = true;
        virtualbox.enable = false;
      };

      development = {
        docker.enable = true;
        python = {
          enable = true;
          # Z3
          # pwntools
          # extensions = with vscode-extensions; [
          #   dtoplak.vscode-glsllint # GLSL Linting
          #   circledev.glsl-canvas # GLSL Preview
          #   slevesque.shader # Required for shaders
          #   twxs.cmake # CMake
          # ];
        };
      };
    };
  };
}
