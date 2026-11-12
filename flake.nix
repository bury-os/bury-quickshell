{
  description = "BuryOS Quickshell configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }: {
    packages."x86_64-linux".default = nixpkgs.legacyPackages."x86_64-linux".quickshell;

    # Home-manager support
    homeManagerModules.default = { pkgs, ... }: {
      home.packages = [
        pkgs.quickshell
      ];

      # Bind the configuration files
      xdg.configFile."quickshell" = {
        source = "./src";
        recursive = true;
      };
    };
  };
}
