{ pkgs, ... }:

{
    imports = [ ./hardware/work-hardware-configuration.nix ];

    networking.hostName = "nixos-work";
    boot.kernelParams = [ "iommu=soft" ];

    environment.systemPackages = [
        pkgs.ferdium
    ];
}
