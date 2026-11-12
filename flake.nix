{
  description = "BuryOS Quickshell configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ...}: {
    homeManagerModules.default = { ... }: {
      programs.quickshell = {
        enable = true;

        configs = {
          bury-os-quickshell = ./src;
        };

        activeConfig = "bury-os-quickshell";
      };
    };
  };
}
