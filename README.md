# Testing NixOS with Btrfs, LUKS, Secure Boot, and TPM2 in a VM

## VM Setup

1. Create a new VM in virt-manager:
   - **OS**: Generic Linux
   - **Firmware**: UEFI x86_64 (OVMF with SecureBoot support)
   - **Disk**: 20GB+ virtio or SATA
   - **Memory**: 4GB+
   - **CPUs**: 2+

2. Before starting, add TPM device:
   - Open VM details
   - Add Hardware → TPM
   - Type: Emulated
   - Model: TIS
   - Version: 2.0

3. Boot NixOS minimal installer ISO

## Installation

1. In the installer console, set a password to enable SSH:

```bash
passwd
```

2. Find the VM's IP address:

```bash
ip addr show
```

3. On your local machine, set the ISO IP and run the install:

```bash
export ISO_IP="192.168.122.XXX"

scp scripts/install.sh nixos@$ISO_IP:/tmp/ && \
  ssh nixos@$ISO_IP "/tmp/install.sh"
```

This will clone the repo, partition the disk, install NixOS, and reboot.

## Post-Install: Enable Secure Boot

1. SSH into the VM (or use console):

```bash
ssh root@<vm-ip>
# password: nixos
```

2. Create Secure Boot keys:

```bash
sudo sbctl create-keys
```

3. Rebuild with Lanzaboote:

```bash
cd /path/to/nix-secureboot-tpm-luks-example
sudo nixos-rebuild boot --flake .#minimal-secureboot
```

4. Verify signing:

```bash
sudo sbctl verify
```

5. Power off VM, enable Secure Boot in OVMF/BIOS settings

6. Boot VM, enroll keys:

```bash
sudo sbctl enroll-keys --microsoft
```

7. Reboot and verify:

```bash
bootctl status
```

Should show "Secure Boot: enabled".

## Enable TPM2 Auto-Unlock

1. Enroll TPM2:

```bash
sudo systemd-cryptenroll --tpm2-device=auto \
  --tpm2-pcrs=0+2+7+12+13+14+15 \
  --wipe-slot=tpm2 /dev/sda2
```

2. Reboot - LUKS should unlock automatically without password prompt
