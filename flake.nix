{
  description = "BuryOS Quickshell configuration";

  outputs = { self }: {
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
