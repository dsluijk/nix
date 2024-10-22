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
        additionalExtensions = with vscode-extensions; [
          dtoplak.vscode-glsllint # GLSL Linting
          slevesque.shader # Required for shaders
          ms-vscode.cpptools # C++
          twxs.cmake # CMake
        ];
      };
    };
  };
}
