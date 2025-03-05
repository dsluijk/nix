{
  config,
  lib,
  pkgs,
  vscode-extensions,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.development.cg;
in {
  options.modules.development.cg = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    modules = {
      programs.vscode = {
        enable = true;
        extensions = with vscode-extensions; [
          dtoplak.vscode-glsllint # GLSL Linting
          circledev.glsl-canvas # GLSL Preview
          slevesque.shader # Required for shaders
          twxs.cmake # CMake
        ];
      };
    };
  };
}
