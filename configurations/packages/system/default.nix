{ pkgs, ... }:

{
    # Forgive me Richard
    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
        wget
        samba
        libnotify
        killall
        pfetch-rs
        ntfs3g
    ];

    fonts.packages = with pkgs; [
        material-icons
        nerdfonts
    ];

    services.fwupd.enable = true;

    imports = [
        ./doas.nix
        ./git.nix
        ./docker.nix
        ./firewall.nix
        ./bluetooth.nix
        ./pipewire
        ./printer.nix
        ./kde-connect.nix
    ];
}
