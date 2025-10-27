{
  lib,
  modulesPath,
  ...
}:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.initrd.availableKernelModules = [
    "ata_piix"
    "uhci_hcd"
    "ehci_pci"
    "sd_mod"
    "sr_mod"
    "e1000"
    "virtio_pci"
  ];

  boot.initrd.kernelModules = [ "e1000" ];
  boot.extraModulePackages = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
