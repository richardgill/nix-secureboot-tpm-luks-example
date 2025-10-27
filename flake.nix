{
  description = "Minimal NixOS with btrfs, LUKS, Secure Boot, and TPM2 unlock";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, disko, lanzaboote, ... }: {
    nixosConfigurations.minimal-secureboot = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        disko.nixosModules.disko
        lanzaboote.nixosModules.lanzaboote

        {
          nix.settings = {
            experimental-features = [
              "nix-command"
              "flakes"
            ];
            substituters = [
              "https://cache.nixos.org/"
              "https://nix-community.cachix.org"
            ];
            trusted-public-keys = [
              "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
              "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            ];
          };
        }

        ./disko.nix
        ./configuration.nix
        ./hardware-configuration.nix
      ];
    };
  };
}
