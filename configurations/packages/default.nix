{ pkgs, ... }:

{
    # Forgive me Richard
    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
        doas
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
}
