{
  description = "BuryOS Quickshell configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }: {
    nixosModules.default = { pkgs, ... }: {
      environment.sessionVariables = rec {
        BURYOS_SHELL_BAR = "qs";
      };
    };

    homeManagerModules.default = { pkgs, ... }: {
      home.packages = [
        pkgs.quickshell
      ];

      # Bind the configuration files
      xdg.configFile."quickshell" = {
        source = ./src;
        recursive = true;
      };
    };
  };
}
