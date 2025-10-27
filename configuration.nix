{ pkgs, lib, ... }:

let
  secureBootEnabled = false;
in
{
  boot.loader = {
    systemd-boot = {
      enable = lib.mkForce (!secureBootEnabled);
    };
    efi.canTouchEfiVariables = true;
    timeout = 10;
  };

  boot.lanzaboote = {
    enable = secureBootEnabled;
    pkiBundle = "/var/lib/sbctl";
  };

  boot.initrd.systemd.enable = secureBootEnabled;

  boot.supportedFilesystems = [ "btrfs" ];
  boot.kernelModules = [
    "tpm_crb"
    "kvm-amd"
  ];

  environment.systemPackages = with pkgs; [
    sbctl
    tpm2-tools
    tpm2-tss
  ];

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

  networking.hostName = "minimal-secureboot-disko";
  networking.useDHCP = lib.mkDefault true;

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = true;
    };
  };

  time.timeZone = "UTC";

  users.users.root.initialPassword = "nixos";

  system.stateVersion = "24.05";
}
