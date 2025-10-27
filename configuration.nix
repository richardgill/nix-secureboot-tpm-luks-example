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
