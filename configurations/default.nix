{ inputs, pkgs, lib, settings, ... }:

{
    boot.tmp.cleanOnBoot = true;
    boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
    };

    networking = {
        wireless.iwd.enable = lib.mkDefault true;
        networkmanager.enable = true;
        networkmanager.wifi.backend = "iwd";
        nameservers = [ "1.1.1.1" "9.9.9.9" ]; # Cloudflare DNS
    };

    # Make hosts file writable (Edits are not persistent)
    environment.etc.hosts.mode = "0644";

    time.timeZone = "Europe/Brussels";
    i18n = {
        defaultLocale = "en_US.UTF-8";
        extraLocaleSettings = {
            LC_ADDRESS = "fr_FR.UTF-8";
            LC_IDENTIFICATION = "fr_FR.UTF-8";
            LC_MEASUREMENT = "fr_FR.UTF-8";
            LC_MONETARY = "fr_FR.UTF-8";
            LC_NAME = "fr_FR.UTF-8";
            LC_NUMERIC = "fr_FR.UTF-8";
            LC_PAPER = "fr_FR.UTF-8";
            LC_TELEPHONE = "fr_FR.UTF-8";
            LC_TIME = "fr_FR.UTF-8";
        };
    };

    # Configure keymap in X11
    services.xserver.xkb = {
        layout = "fr";
        variant = "";
    };

    # Configure console keymap
    console.keyMap = "fr";

    imports =
        [
            inputs.home-manager.nixosModules.home-manager
            ./packages
        ];

    home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
    };

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.${settings.username} = {
        isNormalUser = true;
        description = settings.username;
        extraGroups = [ "networkmanager" "wheel" "docker" ];
    };

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    # WARNING Don't change when updating, only change inputs
    system.stateVersion = "24.11"; # Did you read the comment?
}
