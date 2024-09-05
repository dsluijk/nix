{
  inputs,
  lib,
  pkgs,
  self,
  ...
}:
with lib;
with lib.my; let
  sys = "x86_64-linux";

  recursiveMerge = attrList: let
    f = attrPath:
      zipAttrsWith (
        n: values:
          if tail values == []
          then head values
          else if all isList values
          then unique (concatLists values)
          else if all isAttrs values
          then f (attrPath ++ [n]) values
          else mkMerge values
      );
  in
    f [] attrList;

  mergeFunctions = elems: (
    params:
      recursiveMerge (
        map
        (elem: (
          if isAttrs elem.value
          then elem.value
          else (elem.value params)
        ))
        elems
      )
  );

  mkConfig = key: cfg: (recursiveMerge (attrValues (mkScopedConfig key cfg)));
  mkScopedConfig = key: cfg: (mapAttrs (username: usercfg: usercfg.${key} {inherit username;})) cfg;

  homeOption = mkOption {
    default = _: {};
    type =
      types.raw
      // {
        merge = _: mergeFunctions;
      };
  };
in {
  mkHost = path: attrs @ {system ? sys, ...}:
    nixosSystem {
      inherit system;
      specialArgs = {
        inherit lib inputs system self pkgs;
        vscode-extensions = inputs.nix-vscode-extensions.extensions.${sys}.vscode-marketplace;
      };
      modules = [
        {
          imports =
            [inputs.home-manager.nixosModules.home-manager]
            ++ (mapModulesRec' (toString ../modules) import);
          nixpkgs.pkgs = pkgs;
          networking.hostName = mkDefault (removeSuffix ".nix" (baseNameOf path));
        }
        (filterAttrs (n: v: !elem n ["system"]) attrs)
        (import path)
      ];
    };

  mapHosts = dir: attrs @ {system ? system, ...}:
    mapModules dir
    (hostPath: mkHost hostPath attrs);
}
