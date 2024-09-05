{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs."home-manager".follows = "home-manager";
    };

    stylix = {
      url = "github:danth/stylix/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs."home-manager".follows = "home-manager";
    };

    hyprwm-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    waw = {
      url = "github:dsluijk/waw";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
    ...
  }: let
    inherit (lib.my) mapModules mapModulesRec mapHosts;

    system = "x86_64-linux";

    mkPkgs = pkgs: extraOverlays:
      import pkgs {
        inherit system;
        config.allowUnfree = true; # forgive me Stallman senpai
        overlays = extraOverlays ++ (lib.attrValues self.overlays);
      };

    pkgs = mkPkgs nixpkgs [self.overlay];
    pkgs' = mkPkgs nixpkgs-unstable [self.overlay];

    lib =
      nixpkgs.lib.extend
      (self: super: {
        my = import ./lib {
          inherit pkgs inputs;
          lib = self;
        };
      });
  in {
    lib = lib.my;

    overlay = final: prev: {
      unstable = pkgs';
      my = self.packages."${system}";
    };

    overlays = mapModules ./overlays import;

    nixosModules = mapModulesRec ./modules/system import;

    nixosConfigurations = mapHosts ./hosts {};

    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
  };
}
