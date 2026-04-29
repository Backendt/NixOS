{ pkgs, ... }:

{
    imports = [
        ./hardware/work-hardware-configuration.nix
        ./packages/system/fingerprint.nix
        ./packages/system/nfc.nix
        ./packages/system/gaming.nix
    ];

    networking.hostName = "nixos-work";
    boot.kernelParams = [ "iommu=soft" ];

    environment.systemPackages = [
        pkgs.unstable.ferdium
        pkgs.anydesk
    ];

    # TLP Power management
    services.tlp.enable = true;
}
