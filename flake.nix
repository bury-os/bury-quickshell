{
  description = "BuryOS Quickshell configuration";

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
