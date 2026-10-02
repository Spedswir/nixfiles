# Virt-Manager with QEMU/KVM (libvirt) and USB passthrough. Desktop only.
# This uses NixOS module syntax, not Home Manager module syntax.
#
# After the first rebuild: log out and back in (for the libvirtd group), then start the
# default NAT network once so VMs get internet:
#   sudo virsh net-autostart default && sudo virsh net-start default
#
# USB passthrough, in a VM's window: Virtual Machine > Redirect USB device.
# To always attach a device instead: Add Hardware > USB Host Device.
{ config, pkgs, ... }:

let
  vars = import ../../modules/vars.nix;
in
{
  programs.virt-manager.enable = true;

  virtualisation.libvirtd = {
    enable = true;
    # Emulated TPM 2.0, needed for Windows 11 VMs. UEFI (OVMF) firmware is included by default.
    qemu.swtpm.enable = true;
  };

  # Lets a running VM take over USB devices through SPICE (Redirect USB device).
  virtualisation.spiceUSBRedirection.enable = true;

  # libvirtd lets me manage system VMs without sudo.
  users.users.${vars.username}.extraGroups = [ "libvirtd" ];
}
