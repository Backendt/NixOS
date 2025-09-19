{ pkgs, ... }:

{
    imports = [
        ./hardware/work-hardware-configuration.nix
        ./packages/system/fingerprint.nix
        ./packages/system/nfc.nix
    ];

    networking.hostName = "nixos-work";
    boot.kernelParams = [ "iommu=soft" ];

    environment.systemPackages = [
        pkgs.unstable.ferdium
    ];

    # TLP Power management
    services.tlp.enable = true;
}
