{
  description = "Minimal NixOS with btrfs, LUKS, Secure Boot, and TPM2 unlock";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, disko, lanzaboote, ... }: {
    nixosConfigurations.minimal-secureboot = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        disko.nixosModules.disko
        lanzaboote.nixosModules.lanzaboote

        ./disko.nix
        ./configuration.nix
        ./hardware-configuration.nix
      ];
    };
  };
}
