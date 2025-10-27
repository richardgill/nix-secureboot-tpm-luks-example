#!/usr/bin/env nix-shell
#! nix-shell -i bash -p git
set -e

echo "==> Cloning repository..."
[ -d /tmp/nixos-config ] && sudo rm -rf /tmp/nixos-config
git clone "https://github.com/richardgill/nix-secureboot-tpm-luks-example" /tmp/nixos-config
cd /tmp/nixos-config

echo ""
echo "==> Partitioning and formatting disk with disko..."
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./disko.nix

echo ""
echo "==> Installing NixOS..."
sudo nixos-install --flake .#minimal-secureboot --no-root-passwd

echo ""
echo "==> Setting root password to 'nixos'..."
sudo nixos-enter -c 'echo "root:nixos" | chpasswd'

echo ""
echo "==> Installation complete!"
echo "==> Rebooting in 5 seconds..."
sleep 5
sudo reboot
