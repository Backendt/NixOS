{ pkgs, ... }:

{
    imports = [
        ./hardware/work-hardware-configuration.nix
        ./packages/system/fingerprint.nix
    ];

    networking.hostName = "nixos-work";
    boot.kernelParams = [ "iommu=soft" ];

    environment.systemPackages = [
        pkgs.unstable.ferdium
    ];
}
