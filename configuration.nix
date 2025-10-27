{ pkgs, lib, ... }:

let
  INITIAL_INSTALL = builtins.getEnv "INITIAL_INSTALL" == "1";
in
{
  boot.loader = {
    systemd-boot = {
      enable = lib.mkForce INITIAL_INSTALL;
      configurationLimit = 30;
    };
    efi.canTouchEfiVariables = true;
    timeout = 10;
  };

  boot.lanzaboote = {
    enable = !INITIAL_INSTALL;
    pkiBundle = "/var/lib/sbctl";
  };

  boot.initrd.systemd.enable = !INITIAL_INSTALL;

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
